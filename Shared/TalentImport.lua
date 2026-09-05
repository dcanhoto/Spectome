-- Shared/TalentImport.lua
-- Decodes a Blizzard talent export string (V2 format) and applies it to the
-- player's active spec via a dedicated "Spectome" loadout slot, using
-- C_Traits/C_ClassTalents. Adapted from reference/ClassCodex's
-- Shared/ImportExport.lua (same Blizzard API, trimmed to what this addon
-- needs -- no leveling/partial-apply support, no inspect mode, single spec).

Spectome = Spectome or {}
Spectome.TalentImport = Spectome.TalentImport or {}

if not ExportUtil or not C_Traits or not C_ClassTalents then
	function Spectome.TalentImport.Apply()
		return nil, "Required talent APIs not available"
	end
	return
end

-------------------------------------------------------------------------------
-- Constants (match Blizzard's V2 serialization format)
-------------------------------------------------------------------------------

local BIT_WIDTH_HEADER_VERSION = 8
local BIT_WIDTH_SPEC_ID = 16
local BIT_WIDTH_RANKS_PURCHASED = 6

local SLOT_NAME = "Spectome" -- name of our dedicated C_ClassTalents loadout slot

local function Msg(text)
	print("|cff33ff99Spectome:|r " .. text)
end

local function GetSpecID()
	local specIndex = GetSpecialization()
	if not specIndex then return nil end
	return (GetSpecializationInfo(specIndex))
end

local function GetTreeID()
	local configInfo = C_Traits.GetConfigInfo(C_ClassTalents.GetActiveConfigID())
	return configInfo and configInfo.treeIDs and configInfo.treeIDs[1]
end

-------------------------------------------------------------------------------
-- V2 export-string parser -- the bit layout is fixed by Blizzard, not
-- something we can simplify away. Adapted from TalentLoadoutManager's
-- approach (same one reference/ClassCodex's ImportExport.lua uses).
-------------------------------------------------------------------------------

local function ReadLoadoutHeader(importStream)
	local headerBitWidth = BIT_WIDTH_HEADER_VERSION + BIT_WIDTH_SPEC_ID + 128
	if importStream:GetNumberOfBits() < headerBitWidth then
		return false
	end
	local serializationVersion = importStream:ExtractValue(BIT_WIDTH_HEADER_VERSION)
	local specID = importStream:ExtractValue(BIT_WIDTH_SPEC_ID)
	for _ = 1, 16 do
		importStream:ExtractValue(8) -- treeHash, unused here
	end
	return true, serializationVersion, specID
end

local function ReadLoadoutContent(importStream, treeID)
	local results = {}
	local treeNodes = C_Traits.GetTreeNodes(treeID)
	for i, nodeID in ipairs(treeNodes) do
		local isNodeSelected = importStream:ExtractValue(1) == 1
		local isNodePurchased, isPartiallyRanked, partialRanksPurchased = false, false, 0
		local isChoiceNode, choiceNodeSelection = false, 0

		if isNodeSelected then
			isNodePurchased = importStream:ExtractValue(1) == 1
			if isNodePurchased then
				isPartiallyRanked = importStream:ExtractValue(1) == 1
				if isPartiallyRanked then
					partialRanksPurchased = importStream:ExtractValue(BIT_WIDTH_RANKS_PURCHASED)
				end
				isChoiceNode = importStream:ExtractValue(1) == 1
				if isChoiceNode then
					choiceNodeSelection = importStream:ExtractValue(2)
				end
			end
		end

		results[i] = {
			nodeID = nodeID,
			isNodePurchased = isNodePurchased,
			isPartiallyRanked = isPartiallyRanked,
			partialRanksPurchased = partialRanksPurchased,
			isChoiceNode = isChoiceNode,
			choiceNodeSelection = choiceNodeSelection + 1, -- zero-indexed -> lua
		}
	end
	return results
end

local function ConvertToEntryInfo(configID, treeID, loadoutContent)
	local results = {}
	local treeNodes = C_Traits.GetTreeNodes(treeID)
	for i, treeNodeID in ipairs(treeNodes) do
		local indexInfo = loadoutContent[i]
		if indexInfo and indexInfo.isNodePurchased then
			local nodeInfo = C_Traits.GetNodeInfo(configID, treeNodeID)
			if nodeInfo and nodeInfo.ID ~= 0 then
				local selectionEntryID
				if indexInfo.isChoiceNode and nodeInfo.entryIDs then
					selectionEntryID = nodeInfo.entryIDs[indexInfo.choiceNodeSelection]
				elseif nodeInfo.activeEntry then
					selectionEntryID = nodeInfo.activeEntry.entryID
				end

				local ranks = nodeInfo.maxRanks or 1
				if indexInfo.isPartiallyRanked then
					ranks = indexInfo.partialRanksPurchased
				end

				results[treeNodeID] = {
					nodeID = treeNodeID,
					ranksPurchased = ranks,
					selectionEntryID = selectionEntryID,
					isChoiceNode = indexInfo.isChoiceNode,
				}
			end
		end
	end
	return results
end

local function ParseExportString(exportString, treeID)
	local ok, importStream = pcall(ExportUtil.MakeImportDataStream, exportString)
	if not ok or not importStream then
		return nil, "Failed to decode export string"
	end

	local headerValid, version, specID = ReadLoadoutHeader(importStream)
	if not headerValid then
		return nil, "Invalid export string"
	end
	if version ~= C_Traits.GetLoadoutSerializationVersion() then
		return nil, "Serialization version mismatch"
	end
	if specID ~= GetSpecID() then
		return nil, "Export string is for a different specialization"
	end

	local loadoutContent = ReadLoadoutContent(importStream, treeID)
	local configID = C_ClassTalents.GetActiveConfigID()
	return ConvertToEntryInfo(configID, treeID, loadoutContent)
end

-------------------------------------------------------------------------------
-- Purchase entries, deferred across frames so a full tree doesn't freeze the
-- UI. Multi-pass: some nodes can't be purchased until a prerequisite earlier
-- in iteration order is purchased first, so a pass that made progress
-- re-runs until a pass makes none.
-------------------------------------------------------------------------------

local BATCH_SIZE = 100
local applyToken = 0

local function ResetAndPurchaseDeferred(configID, treeID, entryInfo, onComplete)
	applyToken = applyToken + 1
	local myToken = applyToken

	C_Traits.ResetTree(configID, treeID)

	local orderedNodes = C_Traits.GetTreeNodes(treeID)
	table.sort(orderedNodes, function(a, b)
		local aInfo = C_Traits.GetNodeInfo(configID, a)
		local bInfo = C_Traits.GetNodeInfo(configID, b)
		if aInfo.posY ~= bInfo.posY then return aInfo.posY < bInfo.posY end
		return aInfo.posX < bInfo.posX
	end)

	local i = 1
	local passProgress = 0

	local function step()
		if myToken ~= applyToken then return end -- superseded by a newer apply
		local processed = 0
		while i <= #orderedNodes and processed < BATCH_SIZE do
			local nodeID = orderedNodes[i]
			local entry = entryInfo[nodeID]
			if entry then
				local success = false
				if entry.isChoiceNode then
					success = C_Traits.SetSelection(configID, entry.nodeID, entry.selectionEntryID)
				elseif entry.ranksPurchased then
					local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID)
					for _ = 1, (entry.ranksPurchased - (nodeInfo and nodeInfo.ranksPurchased or 0)) do
						success = C_Traits.PurchaseRank(configID, entry.nodeID)
					end
				end
				if success then
					passProgress = passProgress + 1
					entryInfo[nodeID] = nil
				end
			end
			i = i + 1
			processed = processed + 1
		end

		if i <= #orderedNodes then
			C_Timer.After(0, step)
		elseif passProgress > 0 then
			i = 1
			passProgress = 0
			C_Timer.After(0, step)
		else
			onComplete()
		end
	end

	step()
end

-------------------------------------------------------------------------------
-- Dedicated "Spectome" loadout slot. The configID is cached per spec in
-- SpectomeCharDB so repeated applies reuse the same slot instead of eating a
-- new one every time.
-------------------------------------------------------------------------------

local pendingApply = nil
local pendingApplySeq = 0

-- pendingApply stays set across the whole async lifecycle (request slot ->
-- load config -> stage/purchase -> commit -> rename) so a second click
-- mid-flight is rejected instead of starting a competing apply. The
-- watchdog auto-clears it if Blizzard ever silently drops an expected
-- event, so a stuck apply doesn't require a /reload to recover from.
local PENDING_APPLY_WATCHDOG_SECS = 10

local function SetPendingApply(pa)
	pendingApplySeq = pendingApplySeq + 1
	local mySeq = pendingApplySeq
	pendingApply = pa
	C_Timer.After(PENDING_APPLY_WATCHDOG_SECS, function()
		if pendingApplySeq == mySeq then
			pendingApply = nil
		end
	end)
end

local function ClearPendingApply()
	pendingApplySeq = pendingApplySeq + 1
	pendingApply = nil
end

local function GetStoredConfigID()
	local specID = GetSpecID()
	if not specID or not SpectomeCharDB then return nil end
	local stored = SpectomeCharDB.talentLoadout and SpectomeCharDB.talentLoadout[specID]
	if not stored then return nil end

	if C_ClassTalents.GetConfigIDsBySpecID then
		local validIDs = C_ClassTalents.GetConfigIDsBySpecID(specID)
		if validIDs then
			for _, id in ipairs(validIDs) do
				if id == stored then return stored end
			end
			SpectomeCharDB.talentLoadout[specID] = nil
			return nil
		end
	end

	local ok, info = pcall(C_Traits.GetConfigInfo, stored)
	if ok and info then return stored end
	SpectomeCharDB.talentLoadout[specID] = nil
	return nil
end

local function StoreConfigID(configID)
	local specID = GetSpecID()
	if not specID or not SpectomeCharDB then return end
	SpectomeCharDB.talentLoadout = SpectomeCharDB.talentLoadout or {}
	SpectomeCharDB.talentLoadout[specID] = configID
end

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
	if event == "TRAIT_CONFIG_CREATED" then
		if type(arg1) ~= "table" then return end
		if not pendingApply then return end
		if arg1.type ~= Enum.TraitConfigType.Combat then return end
		if arg1.name ~= SLOT_NAME then return end
		self:UnregisterEvent("TRAIT_CONFIG_CREATED")
		StoreConfigID(arg1.ID)
		local pa = pendingApply
		RunNextFrame(function()
			Spectome.TalentImport.Apply(pa.exportString, pa.loadoutName, true)
		end)
	elseif event == "TRAIT_CONFIG_UPDATED" then
		if arg1 ~= C_ClassTalents.GetActiveConfigID() then return end
		if not pendingApply then return end
		self:UnregisterEvent("TRAIT_CONFIG_UPDATED")
		local pa = pendingApply
		if pa.renameOnly then
			local configID = GetStoredConfigID()
			if configID and C_ClassTalents.RenameConfig then
				C_ClassTalents.RenameConfig(configID, pa.loadoutName)
			end
			Msg("Applied '" .. pa.loadoutName .. "'.")
			ClearPendingApply()
		else
			RunNextFrame(function()
				Spectome.TalentImport.Apply(pa.exportString, pa.loadoutName, true)
			end)
		end
	end
end)

-------------------------------------------------------------------------------
-- Spectome.TalentImport.Apply(exportString, loadoutName)
-- Returns true if the apply was started (it finishes asynchronously and
-- prints its own confirmation), or nil+error if it couldn't be started.
-------------------------------------------------------------------------------

-- Terminal-failure helper: every bail-out path runs through here so a
-- precondition error never leaves pendingApply set (which would otherwise
-- lock the next click behind the "already in progress" guard).
local function Fail(msg)
	ClearPendingApply()
	return nil, msg
end

-- _isContinuation is true only when re-entered from an event handler to
-- continue an in-flight apply. User-initiated calls always omit it.
function Spectome.TalentImport.Apply(exportString, loadoutName, _isContinuation)
	if not exportString or exportString == "" then
		return Fail("Empty export string")
	end

	if pendingApply and not _isContinuation then
		return nil, "Apply already in progress -- wait for it to finish."
	end

	local activeConfigID = C_ClassTalents.GetActiveConfigID()
	if not activeConfigID then return Fail("No active talent configuration") end

	if InCombatLockdown and InCombatLockdown() then
		return Fail("Cannot change talents in combat.")
	end

	if not _isContinuation and C_Traits.ConfigHasStagedChanges
		and C_Traits.ConfigHasStagedChanges(activeConfigID)
	then
		return Fail("You have unsaved talent changes. Open the talents pane and click Apply Changes (or discard them) before applying a Spectome build.")
	end

	local treeID = GetTreeID()
	if not treeID then return Fail("Cannot determine talent tree") end

	local entryInfo, parseErr = ParseExportString(exportString, treeID)
	if not entryInfo then return Fail(parseErr) end

	local storedConfigID = GetStoredConfigID()
	if not storedConfigID then
		if C_ClassTalents.CanCreateNewConfig and not C_ClassTalents.CanCreateNewConfig() then
			return Fail("No free loadout slots -- delete one to use Spectome builds")
		end
		C_ClassTalents.RequestNewConfig(SLOT_NAME)
		SetPendingApply({ exportString = exportString, loadoutName = loadoutName })
		eventFrame:RegisterEvent("TRAIT_CONFIG_CREATED")
		Msg("Creating loadout slot...")
		return true
	end

	local specID = GetSpecID()
	local currentLoadoutID = C_ClassTalents.GetLastSelectedSavedConfigID(specID)
	if currentLoadoutID ~= storedConfigID then
		local result = C_ClassTalents.LoadConfig(storedConfigID, true)
		if result == Enum.LoadConfigResult.LoadInProgress then
			SetPendingApply({ exportString = exportString, loadoutName = loadoutName })
			eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
			return true
		elseif result == Enum.LoadConfigResult.Error then
			if SpectomeCharDB.talentLoadout then SpectomeCharDB.talentLoadout[specID] = nil end
			return Fail("Could not load the Spectome loadout. Open the talents pane, click Apply Changes, then try again.")
		end
	end

	-- Re-fetch: LoadConfig above may have changed the active config.
	activeConfigID = C_ClassTalents.GetActiveConfigID()

	ResetAndPurchaseDeferred(activeConfigID, treeID, entryInfo, function()
		if not C_Traits.ConfigHasStagedChanges(activeConfigID) then
			if C_ClassTalents.RenameConfig then
				C_ClassTalents.RenameConfig(storedConfigID, loadoutName)
			end
			Msg("Applied '" .. loadoutName .. "'.")
			ClearPendingApply()
			return
		end

		if not C_ClassTalents.CommitConfig(storedConfigID) then
			Msg("|cffff0000Commit failed.|r Open the talents pane and click Apply Changes.")
			ClearPendingApply()
			return
		end

		-- CommitConfig triggers a cast bar -- defer the rename+confirmation
		-- until that finishes (TRAIT_CONFIG_UPDATED, renameOnly branch above).
		SetPendingApply({ loadoutName = loadoutName, renameOnly = true })
		eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")

		if C_ClassTalents.UpdateLastSelectedSavedConfigID then
			C_ClassTalents.UpdateLastSelectedSavedConfigID(specID, storedConfigID)
		end
	end)

	return true
end
