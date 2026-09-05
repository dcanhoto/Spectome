-- Sections/Talents.lua
-- Talents section: a source dropdown (Icy Veins/Wowhead/Archon/Method,
-- showing the selected source's icon + name, via UI/SourceDropdown.lua), a
-- context switcher underneath (Raid/Mythic+, or whatever set of contexts
-- the selected source's data actually splits builds by -- see CONTEXT_LABELS
-- below), and for whichever source+context is selected, the hero talent
-- name, notes (or a computed "recommended build" line when notes are
-- empty), a copyable loadout export string, and an Apply Build button that
-- imports it directly via Spectome.TalentImport (see Shared/TalentImport.lua).
-- First full vertical slice (Data -> Sources -> Section UI) -- other
-- sections/specs replicate this. PvE-focused only for now -- no PvP context
-- (see Shared/Sources.lua).
--
-- Class/spec comes from Shared/PlayerContext.lua (the logged-in
-- character's actual class/spec, re-checked on PLAYER_TALENT_UPDATE and
-- whenever this pane is shown, in case of a mid-session respec) rather
-- than a hardcoded class/spec. If Spectome.Data has no entry at all for
-- the current class/spec (no Data/<Class>/ files exist for it yet), the
-- normal UI is replaced with a "No data yet" message instead of silently
-- showing "No data yet" in every individual field.

Spectome = Spectome or {}

local DATA_TYPE = "talents"
local PLACEHOLDER_TEXT = "No data yet"

-- Display labels for known `context` keys -- matches the `context` field on
-- entries in each build's Data table. The switcher row itself is built
-- dynamically (see RebuildContextButtons below) from whatever distinct
-- context values are actually present in the selected source's builds, so
-- a source can split builds by two contexts (raid/mythicPlus) or three
-- (e.g. Arms Warrior's Icy Veins data splits raid further into
-- single-target/multi-target) without any code change here -- only this
-- label mapping needs a new entry. An unmapped key falls back to itself so
-- nothing silently breaks for a future context type.
local CONTEXT_LABELS = {
	raid = "Raid",
	mythicPlus = "Mythic+",
	singleTargetRaid = "Single-Target Raid",
	multiTargetRaid = "Multi-Target Raid",
}

local function GetEntry(sourceId)
	local classFolder, specName = Spectome.PlayerContext.Get()
	local byClass = classFolder and Spectome.Data and Spectome.Data[classFolder]
	local bySpec = specName and byClass and byClass[specName]
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
	return CONTEXT_LABELS[context] or context
end

--- Returns the distinct `context` values present in sourceId's builds for
--- the current class/spec, in the order they first appear in the Data
--- file -- e.g. {"raid", "mythicPlus"} for Blood DK, or
--- {"singleTargetRaid", "multiTargetRaid", "mythicPlus"} for a source that
--- splits raid further by target count. Empty if there's no entry/builds
--- at all (unselected source, or a source with no data for this spec).
local function GetContextsForSource(sourceId)
	local entry = sourceId and GetEntry(sourceId)
	local builds = entry and entry.builds
	local contexts = {}
	if builds then
		local seen = {}
		for _, build in ipairs(builds) do
			if build.context and not seen[build.context] then
				seen[build.context] = true
				table.insert(contexts, build.context)
			end
		end
	end
	return contexts
end

local function ListContains(list, value)
	for _, item in ipairs(list) do
		if item == value then return true end
	end
	return false
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

--- True if Spectome.Data has ANY entry at all for the current class/spec
--- (talents, gear, or trinkets -- doesn't matter which; existence of the
--- per-spec table is what indicates a Data/<Class>/ folder was scaffolded
--- for this spec). Individual empty/placeholder fields inside that data
--- are a completely separate, already-handled case (DisplayOrPlaceholder
--- etc.) -- this only covers "nothing was ever registered for this
--- class/spec at all".
local function HasAnyDataForCurrentSpec()
	local classFolder, specName = Spectome.PlayerContext.Get()
	return classFolder and specName and Spectome.Data and Spectome.Data[classFolder] and Spectome.Data[classFolder][specName] and true or false
end

Spectome.Sections:Register("talents", "Talents", function(content)
	-- State (declared before the UI widgets below so their closures can
	-- capture these as upvalues).
	-- Pooled context buttons -- contextButtonPool[i] is reused across
	-- source switches even though the number/labels of contexts differ
	-- per source; RebuildContextButtons (below) resizes/repositions/
	-- relabels however many are currently needed and hides the rest.
	local contextButtonPool = {}
	local visibleContextCount = 0
	local activeSourceId
	-- No fixed default -- RebuildContextButtons picks the first context
	-- present in whichever source/build data is actually selected.
	local activeContext
	-- Every top-level widget that should be hidden together when the
	-- current class/spec has no data at all (see noDataMessage below).
	-- Anything anchored as a CHILD of one of these (e.g. the context
	-- buttons, which are children of contextRow) is hidden automatically
	-- when its parent is, so only these top-level ones need tracking.
	local normalWidgets = {}
	local function Tracked(widget)
		table.insert(normalWidgets, widget)
		return widget
	end

	-----------------------------------------------------------------------
	-- Static layout: context switcher row (anchored to the source
	-- dropdown once it exists, at the bottom of this function), then
	-- hero talent / notes / loadout string.
	-----------------------------------------------------------------------

	local contextRow = Tracked(CreateFrame("Frame", nil, content))
	contextRow:SetPoint("TOPRIGHT", content, "TOPRIGHT")
	contextRow:SetHeight(22)
	-- (TOPLEFT anchor is set below, once the source dropdown exists.)

	local heroTalentLabel = Tracked(content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"))
	-- Base gap is -16; RefreshDisplay adds extra padding on top of this to
	-- vertically center this whole data block when it's shorter than the
	-- space available below the context switcher.
	heroTalentLabel:SetPoint("TOPLEFT", contextRow, "BOTTOMLEFT", 0, -16)
	heroTalentLabel:SetText("Hero Talent")

	local heroTalentValue = Tracked(content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge"))
	heroTalentValue:SetPoint("TOPLEFT", heroTalentLabel, "BOTTOMLEFT", 0, -4)

	local notesLabel = Tracked(content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"))
	notesLabel:SetPoint("TOPLEFT", heroTalentValue, "BOTTOMLEFT", 0, -16)
	notesLabel:SetText("Notes")

	local notesValue = Tracked(content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge"))
	notesValue:SetPoint("TOPLEFT", notesLabel, "BOTTOMLEFT", 0, -4)
	notesValue:SetPoint("RIGHT", content, "RIGHT")
	notesValue:SetJustifyH("LEFT")
	notesValue:SetWordWrap(true)

	local loadoutLabel = Tracked(content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"))
	loadoutLabel:SetPoint("TOPLEFT", notesValue, "BOTTOMLEFT", 0, -16)
	loadoutLabel:SetText("Loadout Export String")

	-- WoW addons can't reach the OS clipboard directly, so this EditBox
	-- exists purely so the player can select-all (click, Ctrl+A) and
	-- Ctrl+C the string themselves. OnChar is blocked so the field can't
	-- be typed into/corrupted.
	local loadoutBackdrop = Tracked(CreateFrame("Frame", nil, content, "BackdropTemplate"))
	loadoutBackdrop:SetPoint("TOPLEFT", loadoutLabel, "BOTTOMLEFT", 0, -4)
	loadoutBackdrop:SetPoint("RIGHT", content, "RIGHT")
	loadoutBackdrop:SetHeight(26)
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
	loadoutBox:SetFontObject(GameFontHighlight)
	loadoutBox:SetPoint("LEFT", 6, 0)
	loadoutBox:SetPoint("RIGHT", -6, 0)
	loadoutBox:SetHeight(22)
	loadoutBox:SetScript("OnChar", function() end)
	loadoutBox:SetScript("OnEscapePressed", loadoutBox.ClearFocus)
	loadoutBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)

	-- Imports and applies the current build directly via
	-- Spectome.TalentImport instead of the player manually pasting into
	-- the Blizzard talent UI. Disabled whenever there's no loadout
	-- string to apply.
	local applyButton = Tracked(CreateFrame("Button", nil, content, "UIPanelButtonTemplate"))
	applyButton:SetSize(120, 22)
	applyButton:SetPoint("TOPLEFT", loadoutBackdrop, "BOTTOMLEFT", 0, -10)
	applyButton:SetText("Apply Build")

	-- Shown instead of the widgets above when the current class/spec has
	-- no Data/<Class>/ folder scaffolded at all yet.
	local noDataMessage = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	noDataMessage:SetPoint("TOPLEFT", content, "TOPLEFT")
	noDataMessage:SetPoint("RIGHT", content, "RIGHT")
	noDataMessage:SetJustifyH("LEFT")
	noDataMessage:SetWordWrap(true)
	noDataMessage:Hide()

	-- Forward-declared so GetContextButtonWidget's OnClick (below) can
	-- capture it as an upvalue before it's actually assigned further down
	-- -- by the time a button is clicked, SelectContext has long since been
	-- assigned, since Lua closures capture the variable slot, not its
	-- value at closure-creation time.
	local SelectContext

	local function GetContextButtonWidget(index)
		local button = contextButtonPool[index]
		if button then return button end
		button = CreateFrame("Button", nil, contextRow, "UIPanelButtonTemplate")
		button:SetHeight(22)
		button:SetScript("OnClick", function(self)
			SelectContext(self.context)
		end)
		contextButtonPool[index] = button
		return button
	end

	-- Rebuilds the context switcher row for whichever contexts the
	-- currently selected source's data actually has (see
	-- GetContextsForSource above) -- pooled buttons are relabeled/resized/
	-- repositioned rather than recreated each time, and any left over from
	-- a previously-selected source with more contexts are hidden. Button
	-- width is measured from its own label (fixed 80px was fine for
	-- "Raid"/"Mythic+" but too narrow for "Single-Target Raid" etc).
	local function RebuildContextButtons()
		local contexts = GetContextsForSource(activeSourceId)

		if contexts[1] and not ListContains(contexts, activeContext) then
			activeContext = contexts[1]
		end

		local previousButton
		for i, ctx in ipairs(contexts) do
			local button = GetContextButtonWidget(i)
			button.context = ctx
			button:SetText(GetContextLabel(ctx))

			local fontString = button:GetFontString()
			local textWidth = fontString and fontString:GetStringWidth() or 0
			button:SetWidth(math.max(80, textWidth + 24))

			button:ClearAllPoints()
			if previousButton then
				button:SetPoint("LEFT", previousButton, "RIGHT", 6, 0)
			else
				button:SetPoint("LEFT", contextRow, "LEFT", 0, 0)
			end
			button:Show()
			previousButton = button
		end

		for i = #contexts + 1, #contextButtonPool do
			contextButtonPool[i]:Hide()
		end

		visibleContextCount = #contexts
	end

	local function RefreshDisplay()
		if not HasAnyDataForCurrentSpec() then
			local _, specName, displayClassName = Spectome.PlayerContext.Get()
			noDataMessage:SetText(("No data yet for %s %s -- check back once this spec has been added."):format(
				specName or "your current spec", displayClassName or "your class"
			))
			noDataMessage:Show()
			for _, widget in ipairs(normalWidgets) do
				widget:Hide()
			end
			return
		end

		noDataMessage:Hide()
		for _, widget in ipairs(normalWidgets) do
			widget:Show()
		end

		RebuildContextButtons()

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

		for i = 1, visibleContextCount do
			local button = contextButtonPool[i]
			local isActive = (button.context == activeContext)
			button:SetButtonState(isActive and "PUSHED" or "NORMAL", isActive)
		end

		-- Vertically center this data block (Hero Talent through Apply
		-- Build) within the space below the context switcher when it's
		-- shorter than what's available, instead of always sitting flush
		-- against the switcher with empty space below. The delta between
		-- heroTalentLabel's top and applyButton's bottom is unaffected by
		-- whatever padding is currently applied (shifting heroTalentLabel
		-- shifts the whole chained-anchor block below it by the same
		-- amount), so this is safe to recompute from the current state.
		local dataTop = heroTalentLabel:GetTop()
		local dataBottom = applyButton:GetBottom()
		local switcherBottom = contextRow:GetBottom()
		local contentBottom = content:GetBottom()
		if dataTop and dataBottom and switcherBottom and contentBottom then
			local actualHeight = dataTop - dataBottom
			local available = switcherBottom - contentBottom
			local padding = 0
			if actualHeight < available then
				padding = (available - actualHeight) / 2
			end
			heroTalentLabel:ClearAllPoints()
			heroTalentLabel:SetPoint("TOPLEFT", contextRow, "BOTTOMLEFT", 0, -16 - padding)
		end
	end

	SelectContext = function(context)
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

	local sourceDropdown = Tracked(Spectome.UI.CreateSourceDropdown(content, DATA_TYPE, function(sourceId)
		activeSourceId = sourceId
		-- Reset (rather than preserve) on an explicit source switch, so a
		-- new source always opens on its own first context -- mirrors the
		-- old hardcoded "always reset to raid" behavior, just generalized
		-- to "first context this source's data actually has" instead of a
		-- fixed key. RebuildContextButtons (called from RefreshDisplay)
		-- fills this back in.
		activeContext = nil
		RefreshDisplay()
	end))
	sourceDropdown:SetPoint("TOPLEFT")
	contextRow:SetPoint("TOPLEFT", sourceDropdown, "BOTTOMLEFT", 0, -10)

	-- Re-check class/spec whenever the player's talent loadout changes
	-- (covers respeccing) and whenever this pane becomes visible again
	-- (covers a respec that happened while the panel/tab was closed, which
	-- PLAYER_TALENT_UPDATE wouldn't have reached us for).
	Spectome.PlayerContext.OnChange(RefreshDisplay)
	content:SetScript("OnShow", RefreshDisplay)

	-- The very first RefreshDisplay (triggered above, inside
	-- CreateSourceDropdown's initial selection) ran before contextRow's
	-- TOPLEFT anchor just above was set, so its centering math measured
	-- incomplete geometry. Re-run now that the whole chain is resolved.
	RefreshDisplay()
end)
