-- Sections/Gear.lua
-- Gear section: same source dropdown (UI/SourceDropdown.lua) pattern as
-- Sections/Talents.lua, with its own Overall/Mythic+ switcher (Gear-
-- specific contexts -- Talents keeps its separate Raid/Mythic+ pair),
-- rendering the recommended 15-slot gear list for whichever
-- source+context is selected.
--
-- Item icon/name loading follows the pattern reference/ClassCodex's
-- Shared/GearingUtils.lua uses: C_Item.GetItemIconByID + GetItemInfo first
-- (works instantly if the item is already cached), and if the name isn't
-- cached yet, C_Item.RequestLoadItemDataByID + a shared ITEM_DATA_LOAD_RESULT
-- listener refreshes just the affected row once the server responds.
-- itemID == 0 is the "no data yet" placeholder and is never queried.

Spectome = Spectome or {}

local CURRENT_CLASS = "DeathKnight"
local CURRENT_SPEC = "Blood"
local DATA_TYPE = "gear"
local NO_DATA_TEXT = "No data yet"
local LOADING_TEXT = "Loading..."

-- Fixed slot order -- matches Data/<Class>/gear-<source>.lua's `items`
-- array exactly, so builds don't need to be searched/matched by name.
local SLOT_ORDER = {
	"Head", "Neck", "Shoulder", "Back", "Chest", "Wrist", "Hands", "Waist",
	"Legs", "Feet", "Ring 1", "Ring 2", "Trinket 1", "Trinket 2", "Weapon",
}

local CONTEXTS = {
	{ context = "overall", label = "Overall" },
	{ context = "mythicPlus", label = "Mythic+" },
}
local DEFAULT_CONTEXT = "overall"

local SLOT_LABEL_WIDTH = 70
local SLOT_ICON_SIZE = 18
local SLOT_ROW_HEIGHT = 20
local SLOT_ROW_EXTRA_LINE_HEIGHT = 14

-- Two-column layout: 15 rows in one long column overflowed past the
-- bottom of the fixed-size main frame, so slots split into a fixed
-- 6/9 pair of columns instead of resizing the window. COLUMN_SPLIT is
-- the SLOT_ORDER index of the last left-column slot (6 = Wrist; index 7,
-- Hands, starts the right column) -- column 1 ends up with extra empty
-- space below its 6 rows since column 2 has more, which is expected and
-- not something to rebalance.
local COLUMN_SPLIT = 6
local COLUMN_GAP = 16
local PLACEHOLDER_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"
local CATALYST_TEXT = "Use Catalyst for Set Piece"
-- Addon accent color -- same teal-green used for the "Spectome:" chat
-- prefix elsewhere (Shared/TalentImport.lua), reused here so the catalyst
-- note reads as actionable/addon-highlighted rather than flavor text.
local CATALYST_COLOR = { 0.2, 1.0, 0.6 }

local function GetEntry(sourceId)
	local byClass = Spectome.Data and Spectome.Data[CURRENT_CLASS]
	local bySpec = byClass and byClass[CURRENT_SPEC]
	local byDataType = bySpec and bySpec[DATA_TYPE]
	return byDataType and byDataType[sourceId]
end

local function GetBuild(sourceId, context)
	local entry = GetEntry(sourceId)
	local builds = entry and entry.builds
	if not builds then return nil end
	for _, build in ipairs(builds) do
		if build.context == context then
			return build
		end
	end
	return nil
end

-------------------------------------------------------------------------------
-- Item loading: itemID 0 is never queried. Real IDs try the cache first;
-- if the name isn't cached yet, request it and refresh the row once
-- ITEM_DATA_LOAD_RESULT fires for that id.
-------------------------------------------------------------------------------

local pendingRows = {} -- itemId -> { row, row, ... } waiting on that item's load

local function RenderSlotItem(row, itemId)
	row.itemId = itemId

	if not itemId or itemId == 0 then
		row.icon:SetTexture(PLACEHOLDER_ICON)
		row.icon:SetDesaturated(true)
		row.icon:SetAlpha(0.4)
		row.nameText:SetText(NO_DATA_TEXT)
		row.nameText:SetTextColor(0.6, 0.6, 0.6)
		return
	end

	row.icon:SetDesaturated(false)
	row.icon:SetAlpha(1)
	local icon = C_Item.GetItemIconByID(itemId)
	row.icon:SetTexture(icon or PLACEHOLDER_ICON)

	local name = C_Item.GetItemInfo(itemId)
	if name then
		row.nameText:SetText(name)
		row.nameText:SetTextColor(1, 1, 1)
	else
		row.nameText:SetText(LOADING_TEXT)
		row.nameText:SetTextColor(0.6, 0.6, 0.6)
		C_Item.RequestLoadItemDataByID(itemId)
		pendingRows[itemId] = pendingRows[itemId] or {}
		table.insert(pendingRows[itemId], row)
	end
end

local itemEventFrame = CreateFrame("Frame")
itemEventFrame:RegisterEvent("ITEM_DATA_LOAD_RESULT")
itemEventFrame:SetScript("OnEvent", function(_, _, itemId, success)
	local rows = pendingRows[itemId]
	if not rows then return end
	pendingRows[itemId] = nil
	if success then
		for _, row in ipairs(rows) do
			-- The row may have been reassigned to a different item while
			-- this load was in flight (source/context switch) -- only
			-- refresh it if it's still showing the item we requested.
			if row.itemId == itemId then
				RenderSlotItem(row, itemId)
			end
		end
	end
end)

local function RenderSlotRow(row, slotData)
	local itemId = slotData and slotData.itemID or 0
	RenderSlotItem(row, itemId)

	-- No item selected yet means nothing to catalyze, regardless of the
	-- data flag -- keep the row exactly as-is (no icon/badge/text) for
	-- the itemID == 0 placeholder state.
	local showCatalyst = itemId ~= 0 and slotData and slotData.useCatalyst and true or false
	row.catalystText:SetShown(showCatalyst)

	local secondaryParts = {}
	if slotData and slotData.obtainedFrom and slotData.obtainedFrom ~= "" then
		table.insert(secondaryParts, slotData.obtainedFrom)
	end
	if slotData and slotData.notes and slotData.notes ~= "" then
		table.insert(secondaryParts, slotData.notes)
	end
	local showSecondary = #secondaryParts > 0

	row.secondaryText:ClearAllPoints()
	if showCatalyst then
		row.secondaryText:SetPoint("TOPLEFT", row.catalystText, "BOTTOMLEFT", 0, -2)
	else
		row.secondaryText:SetPoint("TOPLEFT", row.nameText, "BOTTOMLEFT", 0, -2)
	end
	row.secondaryText:SetPoint("RIGHT", row, "RIGHT")

	if showSecondary then
		row.secondaryText:SetText(table.concat(secondaryParts, " -- "))
		row.secondaryText:Show()
	else
		row.secondaryText:Hide()
	end

	local extraLines = (showCatalyst and 1 or 0) + (showSecondary and 1 or 0)
	row:SetHeight(SLOT_ROW_HEIGHT + extraLines * SLOT_ROW_EXTRA_LINE_HEIGHT)
end

Spectome.Sections:Register("gear", "Gear", function(content)
	local activeSourceId
	local activeContext = DEFAULT_CONTEXT
	local contextButtons = {}
	local rows = {}

	-----------------------------------------------------------------------
	-- Static layout: context switcher row (anchored to the source
	-- dropdown once it exists, at the bottom of this function), then the
	-- 15 slot rows.
	-----------------------------------------------------------------------

	local contextRow = CreateFrame("Frame", nil, content)
	contextRow:SetPoint("TOPRIGHT", content, "TOPRIGHT")
	contextRow:SetHeight(22)
	-- (TOPLEFT anchor is set below, once the source dropdown exists.)

	local slotArea = CreateFrame("Frame", nil, content)
	slotArea:SetPoint("TOPLEFT", contextRow, "BOTTOMLEFT", 0, -12)
	slotArea:SetPoint("RIGHT", content, "RIGHT")
	slotArea:SetPoint("BOTTOM", content, "BOTTOM")

	-- Two side-by-side columns, split roughly in half with a small gap
	-- between them, both anchored off slotArea's center so each gets
	-- ~half the available width regardless of the frame's exact size.
	local leftColumn = CreateFrame("Frame", nil, slotArea)
	leftColumn:SetPoint("TOPLEFT", slotArea, "TOPLEFT")
	leftColumn:SetPoint("BOTTOMLEFT", slotArea, "BOTTOMLEFT")
	leftColumn:SetPoint("RIGHT", slotArea, "CENTER", -COLUMN_GAP / 2, 0)

	local rightColumn = CreateFrame("Frame", nil, slotArea)
	rightColumn:SetPoint("TOPRIGHT", slotArea, "TOPRIGHT")
	rightColumn:SetPoint("BOTTOMRIGHT", slotArea, "BOTTOMRIGHT")
	rightColumn:SetPoint("LEFT", slotArea, "CENTER", COLUMN_GAP / 2, 0)

	local previousRowByColumn = {}
	for i, slot in ipairs(SLOT_ORDER) do
		local column = (i <= COLUMN_SPLIT) and leftColumn or rightColumn
		local previousRow = previousRowByColumn[column]

		local row = CreateFrame("Frame", nil, column)
		if previousRow then
			row:SetPoint("TOPLEFT", previousRow, "BOTTOMLEFT")
			row:SetPoint("TOPRIGHT", previousRow, "BOTTOMRIGHT")
		else
			row:SetPoint("TOPLEFT", column, "TOPLEFT")
			row:SetPoint("TOPRIGHT", column, "TOPRIGHT")
		end
		row:SetHeight(SLOT_ROW_HEIGHT)

		local slotLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		slotLabel:SetPoint("TOPLEFT", 0, 0)
		slotLabel:SetWidth(SLOT_LABEL_WIDTH)
		slotLabel:SetJustifyH("LEFT")
		slotLabel:SetText(slot)
		row.slotLabel = slotLabel

		local icon = row:CreateTexture(nil, "ARTWORK")
		icon:SetSize(SLOT_ICON_SIZE, SLOT_ICON_SIZE)
		icon:SetPoint("TOPLEFT", slotLabel, "TOPRIGHT", 6, 0)
		row.icon = icon

		local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		nameText:SetPoint("LEFT", icon, "RIGHT", 6, 0)
		nameText:SetPoint("RIGHT", row, "RIGHT")
		nameText:SetJustifyH("LEFT")
		row.nameText = nameText

		-- Actionable, addon-highlighted note -- distinct from the plain
		-- gray secondaryText below, since "catalyze this" is something to
		-- act on, not just flavor text.
		local catalystText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		catalystText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -2)
		catalystText:SetPoint("RIGHT", row, "RIGHT")
		catalystText:SetJustifyH("LEFT")
		catalystText:SetTextColor(unpack(CATALYST_COLOR))
		catalystText:SetText(CATALYST_TEXT)
		catalystText:Hide()
		row.catalystText = catalystText

		local secondaryText = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		secondaryText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -2)
		secondaryText:SetPoint("RIGHT", row, "RIGHT")
		secondaryText:SetJustifyH("LEFT")
		secondaryText:Hide()
		row.secondaryText = secondaryText

		row:EnableMouse(true)
		row:SetScript("OnEnter", function(self)
			if not self.itemId or self.itemId == 0 then return end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetItemByID(self.itemId)
			GameTooltip:Show()
		end)
		row:SetScript("OnLeave", function() GameTooltip:Hide() end)

		table.insert(rows, row)
		previousRowByColumn[column] = row
	end

	local function RefreshDisplay()
		local build = activeSourceId and GetBuild(activeSourceId, activeContext)
		local items = build and build.items

		for i, row in ipairs(rows) do
			RenderSlotRow(row, items and items[i])
		end

		for context, button in pairs(contextButtons) do
			local isActive = (context == activeContext)
			button:SetButtonState(isActive and "PUSHED" or "NORMAL", isActive)
		end
	end

	local function SelectContext(context)
		activeContext = context
		RefreshDisplay()
	end

	local previousContextButton
	for _, ctx in ipairs(CONTEXTS) do
		local button = CreateFrame("Button", nil, contextRow, "UIPanelButtonTemplate")
		button:SetSize(80, 22)
		button:SetText(ctx.label)
		if previousContextButton then
			button:SetPoint("LEFT", previousContextButton, "RIGHT", 6, 0)
		else
			button:SetPoint("LEFT", contextRow, "LEFT", 0, 0)
		end
		button:SetScript("OnClick", function() SelectContext(ctx.context) end)

		contextButtons[ctx.context] = button
		previousContextButton = button
	end

	local sourceDropdown = Spectome.UI.CreateSourceDropdown(content, DATA_TYPE, function(sourceId)
		activeSourceId = sourceId
		activeContext = DEFAULT_CONTEXT
		RefreshDisplay()
	end)
	sourceDropdown:SetPoint("TOPLEFT")
	contextRow:SetPoint("TOPLEFT", sourceDropdown, "BOTTOMLEFT", 0, -10)
end)
