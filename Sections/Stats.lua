-- Sections/Stats.lua
-- Stats section: a source dropdown (Icy Veins/Wowhead/Archon -- Method
-- doesn't provide "stats", see Shared/Sources.lua's `provides` field) and,
-- underneath it, a hero-talent-tree switcher (Deathbringer/San'layn for
-- Blood Death Knight, or whatever set of contexts the selected source's
-- data actually has -- see Shared/ContextLabels.lua). Stat priority is a
-- build-mechanics question tied to hero tree choice, not content type, so
-- this switches by hero tree instead of Raid/Mythic+ like Talents/Gear do.
--
-- Reuses the exact same dynamic context-switcher pattern built for
-- Sections/Talents.lua (pooled buttons rebuilt from whatever `context`
-- values are present in the selected build data, shared label lookup) --
-- see that file for the fuller reasoning; this is a trimmed-down copy
-- without the loadout-string/Apply-Build machinery, since stats are just
-- priority + notes text, not an importable build.
--
-- Class/spec comes from Shared/PlayerContext.lua, same as every other
-- section -- re-checked on PLAYER_TALENT_UPDATE and whenever this pane is
-- shown, and replaced with a "No data yet" message if Spectome.Data has no
-- entry at all for the current class/spec.

Spectome = Spectome or {}

local DATA_TYPE = "stats"
local PLACEHOLDER_TEXT = "No data yet"

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
	return Spectome.ContextLabels[context] or context
end

--- Returns the distinct `context` values present in sourceId's builds for
--- the current class/spec, in the order they first appear in the Data
--- file -- e.g. {"deathbringer", "sanlayn"} for Blood DK. Empty if there's
--- no entry/builds at all (unselected source, or a source with no stats
--- data for this spec). See the matching helper in Sections/Talents.lua.
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

--- True if Spectome.Data has ANY entry at all for the current class/spec
--- (see the matching helper in Sections/Talents.lua for the full
--- reasoning) -- individual empty/placeholder fields inside existing data
--- are a separate, already-handled case.
local function HasAnyDataForCurrentSpec()
	local classFolder, specName = Spectome.PlayerContext.Get()
	return classFolder and specName and Spectome.Data and Spectome.Data[classFolder] and Spectome.Data[classFolder][specName] and true or false
end

Spectome.Sections:Register("stats", "Stats", function(content)
	-- Pooled context buttons -- see Sections/Talents.lua's matching state
	-- for the full reasoning (a pool index is reused across source
	-- switches even though the number/labels of contexts differ per
	-- source).
	local contextButtonPool = {}
	local visibleContextCount = 0
	local activeSourceId
	-- No fixed default -- RebuildContextButtons picks the first context
	-- present in whichever source/build data is actually selected.
	local activeContext
	-- Every top-level widget that should be hidden together when the
	-- current class/spec has no data at all (see noDataMessage below).
	local normalWidgets = {}
	local function Tracked(widget)
		table.insert(normalWidgets, widget)
		return widget
	end

	-----------------------------------------------------------------------
	-- Static layout: context switcher row (anchored to the source
	-- dropdown once it exists, at the bottom of this function), then stat
	-- priority (prominent, this is the main content) and notes (smaller
	-- secondary text below it) -- same Label-above-Value structure as
	-- Talents' Hero Talent/Notes, but priority uses a visibly larger/
	-- bolder value than notes since there's no loadout string/Apply
	-- Build section competing for emphasis here.
	-----------------------------------------------------------------------

	local contextRow = Tracked(CreateFrame("Frame", nil, content))
	contextRow:SetPoint("TOPRIGHT", content, "TOPRIGHT")
	contextRow:SetHeight(22)
	-- (TOPLEFT anchor is set below, once the source dropdown exists.)

	local priorityLabel = Tracked(content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"))
	-- Base gap is -16; RefreshDisplay adds extra padding on top of this to
	-- vertically center this whole data block when it's shorter than the
	-- space available below the context switcher.
	priorityLabel:SetPoint("TOPLEFT", contextRow, "BOTTOMLEFT", 0, -16)
	priorityLabel:SetText("Stat Priority")

	local priorityValue = Tracked(content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge"))
	priorityValue:SetPoint("TOPLEFT", priorityLabel, "BOTTOMLEFT", 0, -4)
	priorityValue:SetPoint("RIGHT", content, "RIGHT")
	priorityValue:SetJustifyH("LEFT")
	priorityValue:SetWordWrap(true)

	local notesLabel = Tracked(content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"))
	notesLabel:SetPoint("TOPLEFT", priorityValue, "BOTTOMLEFT", 0, -16)
	notesLabel:SetText("Notes")

	-- Smaller/secondary compared to priorityValue (GameFontHighlight, not
	-- ...Large) -- priority is the main content here, notes are a
	-- supporting caveat underneath it.
	local notesValue = Tracked(content:CreateFontString(nil, "OVERLAY", "GameFontHighlight"))
	notesValue:SetPoint("TOPLEFT", notesLabel, "BOTTOMLEFT", 0, -4)
	notesValue:SetPoint("RIGHT", content, "RIGHT")
	notesValue:SetJustifyH("LEFT")
	notesValue:SetWordWrap(true)

	-- Shown instead of the widgets above when the current class/spec has
	-- no Data/<Class>/ folder scaffolded at all yet.
	local noDataMessage = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	noDataMessage:SetPoint("TOPLEFT", content, "TOPLEFT")
	noDataMessage:SetPoint("RIGHT", content, "RIGHT")
	noDataMessage:SetJustifyH("LEFT")
	noDataMessage:SetWordWrap(true)
	noDataMessage:Hide()

	-- Forward-declared so GetContextButtonWidget's OnClick (below) can
	-- capture it as an upvalue before it's actually assigned further down.
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
	-- currently selected source's data actually has -- see the matching
	-- function in Sections/Talents.lua for the fuller reasoning.
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

		priorityValue:SetText(DisplayOrPlaceholder(build and build.priority))
		notesValue:SetText(DisplayOrPlaceholder(build and build.notes))

		for i = 1, visibleContextCount do
			local button = contextButtonPool[i]
			local isActive = (button.context == activeContext)
			button:SetButtonState(isActive and "PUSHED" or "NORMAL", isActive)
		end

		-- Vertically center this data block (Stat Priority through Notes)
		-- within the space below the context switcher when it's shorter
		-- than what's available -- same reasoning as Sections/Talents.lua's
		-- matching block.
		local dataTop = priorityLabel:GetTop()
		local dataBottom = notesValue:GetBottom()
		local switcherBottom = contextRow:GetBottom()
		local contentBottom = content:GetBottom()
		if dataTop and dataBottom and switcherBottom and contentBottom then
			local actualHeight = dataTop - dataBottom
			local available = switcherBottom - contentBottom
			local padding = 0
			if actualHeight < available then
				padding = (available - actualHeight) / 2
			end
			priorityLabel:ClearAllPoints()
			priorityLabel:SetPoint("TOPLEFT", contextRow, "BOTTOMLEFT", 0, -16 - padding)
		end
	end

	SelectContext = function(context)
		activeContext = context
		RefreshDisplay()
	end

	local sourceDropdown = Tracked(Spectome.UI.CreateSourceDropdown(content, DATA_TYPE, function(sourceId)
		activeSourceId = sourceId
		-- Reset (rather than preserve) on an explicit source switch, so a
		-- new source always opens on its own first context -- see
		-- Sections/Talents.lua's matching comment.
		activeContext = nil
		RefreshDisplay()
	end))
	sourceDropdown:SetPoint("TOPLEFT")
	contextRow:SetPoint("TOPLEFT", sourceDropdown, "BOTTOMLEFT", 0, -10)

	-- Re-check class/spec whenever the player's talent loadout changes
	-- (covers respeccing) and whenever this pane becomes visible again.
	Spectome.PlayerContext.OnChange(RefreshDisplay)
	content:SetScript("OnShow", RefreshDisplay)

	-- The very first RefreshDisplay (triggered above, inside
	-- CreateSourceDropdown's initial selection) ran before contextRow's
	-- TOPLEFT anchor just above was set, so its centering math measured
	-- incomplete geometry. Re-run now that the whole chain is resolved.
	RefreshDisplay()
end)
