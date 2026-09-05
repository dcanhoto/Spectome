-- Sections/Talents.lua
-- Talents section: a source dropdown (Icy Veins/Wowhead/Archon/Method,
-- showing the selected source's icon + name, via UI/SourceDropdown.lua), a
-- Raid/Mythic+ context switcher underneath, and for whichever
-- source+context is selected, the hero talent name, notes (or a computed
-- "recommended build" line when notes are empty), a copyable loadout export
-- string, and an Apply Build button that imports it directly via
-- Spectome.TalentImport (see Shared/TalentImport.lua). First full vertical
-- slice (Data -> Sources -> Section UI) -- other sections/specs replicate
-- this. PvE-focused only for now -- no PvP context (see Shared/Sources.lua).

Spectome = Spectome or {}

-- Hardcoded until more than one class/spec is supported. Later this should
-- read the player's actual class/spec via UnitClass("player") and
-- GetSpecialization()/GetSpecializationInfo() instead of these constants.
local CURRENT_CLASS = "DeathKnight"
local CURRENT_SPEC = "Blood"

local DATA_TYPE = "talents"
local PLACEHOLDER_TEXT = "No data yet"

-- Raid/Mythic+ sub-switcher shown underneath the source dropdown. `context`
-- matches the `context` field on entries in each build's Data table.
local CONTEXTS = {
	{ context = "raid", label = "Raid" },
	{ context = "mythicPlus", label = "Mythic+" },
}
local DEFAULT_CONTEXT = "raid"

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

local function DisplayOrPlaceholder(value)
	if value == nil or value == "" then
		return PLACEHOLDER_TEXT
	end
	return value
end

local function GetContextLabel(context)
	for _, ctx in ipairs(CONTEXTS) do
		if ctx.context == context then
			return ctx.label
		end
	end
	return context
end

-- Empty notes still mean something for a talent build (it's the site's top
-- pick for that context) unlike an empty loadoutString, which genuinely has
-- nothing -- so show a computed line instead of the generic placeholder.
-- This is computed here, never stored in the Data files.
local function GetNotesText(sourceId, context, build)
	if build and build.notes and build.notes ~= "" then
		return build.notes
	end
	if not build then
		return PLACEHOLDER_TEXT
	end
	local source = Spectome.Sources:Get(sourceId)
	local sourceName = source and source.displayName or sourceId
	return ("This is %s's recommended build for %s."):format(sourceName, GetContextLabel(context))
end

Spectome.Sections:Register("talents", "Talents", function(content)
	-- State (declared before the UI widgets below so their closures can
	-- capture these as upvalues).
	local contextButtons = {}
	local activeSourceId
	local activeContext = DEFAULT_CONTEXT

	-----------------------------------------------------------------------
	-- Static layout: context switcher row (anchored to the source
	-- dropdown once it exists, at the bottom of this function), then
	-- hero talent / notes / loadout string.
	-----------------------------------------------------------------------

	local contextRow = CreateFrame("Frame", nil, content)
	contextRow:SetPoint("TOPRIGHT", content, "TOPRIGHT")
	contextRow:SetHeight(22)
	-- (TOPLEFT anchor is set below, once the source dropdown exists.)

	local heroTalentLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	heroTalentLabel:SetPoint("TOPLEFT", contextRow, "BOTTOMLEFT", 0, -16)
	heroTalentLabel:SetText("Hero Talent")

	local heroTalentValue = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	heroTalentValue:SetPoint("TOPLEFT", heroTalentLabel, "BOTTOMLEFT", 0, -4)

	local notesLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	notesLabel:SetPoint("TOPLEFT", heroTalentValue, "BOTTOMLEFT", 0, -16)
	notesLabel:SetText("Notes")

	local notesValue = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	notesValue:SetPoint("TOPLEFT", notesLabel, "BOTTOMLEFT", 0, -4)
	notesValue:SetPoint("RIGHT", content, "RIGHT")
	notesValue:SetJustifyH("LEFT")
	notesValue:SetWordWrap(true)

	local loadoutLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	loadoutLabel:SetPoint("TOPLEFT", notesValue, "BOTTOMLEFT", 0, -16)
	loadoutLabel:SetText("Loadout Export String")

	-- WoW addons can't reach the OS clipboard directly, so this EditBox
	-- exists purely so the player can select-all (click, Ctrl+A) and
	-- Ctrl+C the string themselves. OnChar is blocked so the field can't
	-- be typed into/corrupted.
	local loadoutBackdrop = CreateFrame("Frame", nil, content, "BackdropTemplate")
	loadoutBackdrop:SetPoint("TOPLEFT", loadoutLabel, "BOTTOMLEFT", 0, -4)
	loadoutBackdrop:SetPoint("RIGHT", content, "RIGHT")
	loadoutBackdrop:SetHeight(24)
	loadoutBackdrop:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 12,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	loadoutBackdrop:SetBackdropColor(0, 0, 0, 0.6)
	loadoutBackdrop:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8)

	local loadoutBox = CreateFrame("EditBox", nil, loadoutBackdrop)
	loadoutBox:SetAutoFocus(false)
	loadoutBox:SetFontObject(GameFontHighlightSmall)
	loadoutBox:SetPoint("LEFT", 6, 0)
	loadoutBox:SetPoint("RIGHT", -6, 0)
	loadoutBox:SetHeight(20)
	loadoutBox:SetScript("OnChar", function() end)
	loadoutBox:SetScript("OnEscapePressed", loadoutBox.ClearFocus)
	loadoutBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)

	-- Imports and applies the current build directly via
	-- Spectome.TalentImport instead of the player manually pasting into
	-- the Blizzard talent UI. Disabled whenever there's no loadout
	-- string to apply.
	local applyButton = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	applyButton:SetSize(120, 22)
	applyButton:SetPoint("TOPLEFT", loadoutBackdrop, "BOTTOMLEFT", 0, -10)
	applyButton:SetText("Apply Build")

	local function RefreshDisplay()
		local build = activeSourceId and GetBuild(activeSourceId, activeContext)

		heroTalentValue:SetText(DisplayOrPlaceholder(build and build.heroTalent))
		notesValue:SetText(GetNotesText(activeSourceId, activeContext, build))

		local loadoutString = build and build.loadoutString
		if loadoutString and loadoutString ~= "" then
			loadoutBox:SetText(loadoutString)
			applyButton:Enable()
		else
			loadoutBox:SetText(PLACEHOLDER_TEXT)
			applyButton:Disable()
		end
		loadoutBox:SetCursorPosition(0)

		for context, button in pairs(contextButtons) do
			local isActive = (context == activeContext)
			button:SetButtonState(isActive and "PUSHED" or "NORMAL", isActive)
		end
	end

	local function SelectContext(context)
		activeContext = context
		RefreshDisplay()
	end

	applyButton:SetScript("OnClick", function()
		local build = activeSourceId and GetBuild(activeSourceId, activeContext)
		if not build or not build.loadoutString or build.loadoutString == "" then return end
		local loadoutString = build.loadoutString

		local source = Spectome.Sources:Get(activeSourceId)
		local loadoutName = ("%s: %s %s"):format(
			source and source.displayName or activeSourceId,
			GetContextLabel(activeContext),
			build.heroTalent or ""
		)
		local ok, err = Spectome.TalentImport.Apply(loadoutString, loadoutName)
		if not ok then
			print("|cff33ff99Spectome:|r " .. (err or "Could not apply build."))
		end
	end)

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
