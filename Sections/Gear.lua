-- Sections/Gear.lua
-- Gear section: source dropdown (UI/SourceDropdown.lua) at the top, then a
-- BiS Gear / Trinket Tier List view toggle, then whichever view is active:
--
--   BiS Gear         -- Overall/Mythic+ switcher + two-column slot list,
--                        one row per entry in the current build's `items`
--                        array (in data order) -- most class/spec/source
--                        combos have the usual 15 slots, but a combo can
--                        add an extra slot (e.g. Arms Warrior's "Alt Main
--                        Hand") without touching any other combo's data or
--                        this rendering code.
--   Trinket Tier List -- a single flat list of trinkets grouped by tier
--                        (S down through C), not split by context.
--
-- Both views share the same item icon/name loading + hover tooltip logic
-- (RenderItemIcon + SetupItemTooltip below) rather than each reimplementing
-- it. Item loading follows the pattern reference/ClassCodex's
-- Shared/GearingUtils.lua uses: C_Item.GetItemIconByID + C_Item.GetItemInfo
-- first (works instantly if the item is already cached), and if the name
-- isn't cached yet, C_Item.RequestLoadItemDataByID + a shared
-- ITEM_DATA_LOAD_RESULT listener refreshes just the affected row once the
-- server responds. itemID == 0 is the "no data yet" placeholder (for both
-- BiS slots and trinkets) and is never queried.
--
-- Class/spec comes from Shared/PlayerContext.lua (the logged-in
-- character's actual class/spec, re-checked on PLAYER_TALENT_UPDATE and
-- whenever this pane is shown) rather than a hardcoded class/spec. If
-- Spectome.Data has no entry at all for the current class/spec, the normal
-- UI is replaced with a "No data yet" message.

Spectome = Spectome or {}

local DATA_TYPE = "gear" -- source filter for the dropdown -- trinket tier
                         -- lists are a gear subtype, so both views draw
                         -- their source list from the same "gear" sources.
local NO_DATA_TEXT = "No data yet"
local LOADING_TEXT = "Loading..."

local CONTEXTS = {
	{ context = "overall", label = "Overall" },
	{ context = "mythicPlus", label = "Mythic+" },
}
local DEFAULT_CONTEXT = "overall"

-- BiS Gear / Trinket Tier List toggle.
local VIEWS = {
	{ view = "bis", label = "BiS Gear" },
	{ view = "trinkets", label = "Trinket Tier List" },
}
local DEFAULT_VIEW = "bis"

local TRINKET_TIER_ORDER = { "S", "A", "B", "C", "D", "F" }
-- Approximate rendered height of a GameFontNormal tier header line, used
-- only to size the trinket scrollframe's content height (a slight
-- overestimate just means a few extra px of scrollable space, not a bug).
local TIER_HEADER_HEIGHT = 18

-- Widened from 70 to fit "Trinket 1"/"Trinket 2" at the bumped label font
-- (GameFontNormalSmall -> GameFontNormal, see slotLabel below).
local SLOT_LABEL_WIDTH = 80
local SLOT_ICON_SIZE = 18
local SLOT_ROW_HEIGHT = 20
-- Vertical breathing room between one row's rendered content and the next
-- row's slot label below it (rows previously sat flush against each
-- other with no gap at all).
local ROW_GAP = 8

-- Two-column BiS layout: a single long column of rows overflowed past the
-- bottom of the fixed-size main frame, so slots split into a fixed
-- 6/rest pair of columns instead of resizing the window. COLUMN_SPLIT is
-- how many of the current build's items (in data order) go in the left
-- column before the rest fall into the right column -- e.g. with the usual
-- 15-slot data that's items 1-6 (Head-Wrist) left, 7-15 (Hands-Weapon)
-- right; a 16-slot build (an extra "Alt Main Hand" appended at the end)
-- naturally puts its 16th item at the bottom of the right column with no
-- other change needed. Column 1 ends up with extra empty space below its
-- rows whenever column 2 has more, which is expected and not something to
-- rebalance.
local COLUMN_SPLIT = 6
local COLUMN_GAP = 16
local PLACEHOLDER_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"
local CATALYST_TEXT = "Use Catalyst for Set Piece"
-- Addon accent color -- same teal-green used for the "Spectome:" chat
-- prefix elsewhere (Shared/TalentImport.lua), reused here so the catalyst
-- note reads as actionable/addon-highlighted rather than flavor text.
local CATALYST_COLOR = { 0.2, 1.0, 0.6 }

local function GetEntry(dataType, sourceId)
	local classFolder, specName = Spectome.PlayerContext.Get()
	local byClass = classFolder and Spectome.Data and Spectome.Data[classFolder]
	local bySpec = specName and byClass and byClass[specName]
	local byDataType = bySpec and bySpec[dataType]
	return byDataType and byDataType[sourceId]
end

--- True if Spectome.Data has ANY entry at all for the current class/spec
--- (see the matching helper in Sections/Talents.lua for the full
--- reasoning) -- individual empty/placeholder fields inside existing data
--- are a separate, already-handled case.
local function HasAnyDataForCurrentSpec()
	local classFolder, specName = Spectome.PlayerContext.Get()
	return classFolder and specName and Spectome.Data and Spectome.Data[classFolder] and Spectome.Data[classFolder][specName] and true or false
end

local function GetBuild(sourceId, context)
	local entry = GetEntry("gear", sourceId)
	local builds = entry and entry.builds
	if not builds then return nil end
	for _, build in ipairs(builds) do
		if build.context == context then
			return build
		end
	end
	return nil
end

local function GetTrinketEntry(sourceId)
	return GetEntry("trinkets", sourceId)
end

-------------------------------------------------------------------------------
-- Shared item loading + tooltip: used by both BiS slot rows and Trinket
-- Tier List rows. itemID 0 is never queried. Real IDs try the cache first;
-- if the name isn't cached yet, request it and refresh the row once
-- ITEM_DATA_LOAD_RESULT fires for that id.
-------------------------------------------------------------------------------

local pendingRows = {} -- itemId -> { row, row, ... } waiting on that item's load

local function RenderItemIcon(row, itemId)
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
			-- this load was in flight (source/context/view switch) -- only
			-- refresh it if it's still showing the item we requested.
			if row.itemId == itemId then
				RenderItemIcon(row, itemId)
			end
		end
	end
end)

--- Wires up the hover tooltip common to any item row (BiS slot or
--- trinket): shows the real item tooltip via GameTooltip:SetItemByID, and
--- does nothing for the itemID == 0 placeholder state.
--- `hoverRegion` is the frame that should actually catch the mouse (a
--- small hitbox sized to the icon, since the icon itself is a plain
--- Texture and can't be made mouse-interactive) -- everything else about
--- the item (itemId) still lives on `row`, so the tooltip stays correct
--- even though the frame receiving OnEnter/OnLeave is a different object.
--- Falls back to `row` itself if no region is given.
local function SetupItemTooltip(row, hoverRegion)
	hoverRegion = hoverRegion or row
	hoverRegion:EnableMouse(true)
	hoverRegion:SetScript("OnEnter", function(self)
		if not row.itemId or row.itemId == 0 then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetItemByID(row.itemId)
		GameTooltip:Show()
	end)
	hoverRegion:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local function RenderSlotRow(row, slotData)
	local itemId = slotData and slotData.itemID or 0
	RenderItemIcon(row, itemId)

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
		row.secondaryText:SetPoint("TOPLEFT", row.icon, "BOTTOMLEFT", 0, -2)
	end
	row.secondaryText:SetPoint("RIGHT", row, "RIGHT")

	if showSecondary then
		row.secondaryText:SetText(table.concat(secondaryParts, " -- "))
		row.secondaryText:Show()
	else
		row.secondaryText:Hide()
	end

	-- Measure each visible line's actual rendered height (GetStringHeight
	-- reflects word-wrap, so a long obtainedFrom string that wraps to two
	-- lines is accounted for) instead of assuming a fixed per-line height
	-- -- a fixed guess under/overshoots depending on text length and was
	-- letting rows overlap the one below them in the same column.
	local height = SLOT_ICON_SIZE -- icon sets the row's floor height
	if showCatalyst then
		height = height + 2 + row.catalystText:GetStringHeight()
	end
	if showSecondary then
		height = height + 2 + row.secondaryText:GetStringHeight()
	end
	row:SetHeight(math.max(height, SLOT_ROW_HEIGHT))
end

local function RenderTrinketRow(row, trinketData)
	local itemId = trinketData and trinketData.itemID or 0
	RenderItemIcon(row, itemId)

	local notes = trinketData and trinketData.notes or ""
	local showNotes = notes ~= ""
	if showNotes then
		row.notesText:SetText(notes)
		row.notesText:Show()
	else
		row.notesText:Hide()
	end

	-- Same reasoning as RenderSlotRow: measure the actual rendered height
	-- (accounts for word-wrap) instead of assuming a fixed per-line height.
	local height = SLOT_ICON_SIZE
	if showNotes then
		height = height + 2 + row.notesText:GetStringHeight()
	end
	row:SetHeight(math.max(height, SLOT_ROW_HEIGHT))
end

Spectome.Sections:Register("gear", "Gear", function(content)
	local activeSourceId
	local activeContext = DEFAULT_CONTEXT
	local activeView = DEFAULT_VIEW
	local contextButtons = {}
	local viewButtons = {}

	-- Every top-level widget that should be hidden together when the
	-- current class/spec has no data at all (see noDataMessage below).
	-- Children (context buttons, slot rows, etc.) are hidden automatically
	-- when their parent is, so only these top-level ones need tracking.
	-- Note this is separate from the BiS/Trinket view toggle's own
	-- show/hide of contextRow/slotArea/trinketScroll (see SelectView) --
	-- that logic only runs when there IS data, and hasData gates it.
	local normalWidgets = {}
	local function Tracked(widget)
		table.insert(normalWidgets, widget)
		return widget
	end

	-----------------------------------------------------------------------
	-- Static layout: view toggle (anchored to the source dropdown once it
	-- exists, at the bottom of this function), then either the BiS
	-- Overall/Mythic+ switcher + two-column slot list, or the Trinket Tier
	-- List -- only one of which is shown at a time.
	-----------------------------------------------------------------------

	local viewToggleRow = Tracked(CreateFrame("Frame", nil, content))
	viewToggleRow:SetPoint("TOPRIGHT", content, "TOPRIGHT")
	viewToggleRow:SetHeight(22)
	-- (TOPLEFT anchor is set below, once the source dropdown exists.)

	-- BiS Gear view -----------------------------------------------------

	local contextRow = Tracked(CreateFrame("Frame", nil, content))
	contextRow:SetPoint("TOPLEFT", viewToggleRow, "BOTTOMLEFT", 0, -8)
	contextRow:SetPoint("RIGHT", content, "RIGHT")
	contextRow:SetHeight(22)

	local slotArea = Tracked(CreateFrame("Frame", nil, content))
	slotArea:SetPoint("TOPLEFT", contextRow, "BOTTOMLEFT", 0, -8)
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

	-- Pooled per-column row widgets -- built on demand (GetSlotRow below)
	-- rather than one fixed-size loop, since the number of rows in each
	-- column now depends on how many items the currently selected build
	-- actually has (see RenderSlotRows), not a fixed slot list. A pool
	-- index only ever renders slots from its own column (item i <=
	-- COLUMN_SPLIT always left, i > COLUMN_SPLIT always right), so each
	-- pooled row's parent never needs to change once created.
	local leftRowPool = {}
	local rightRowPool = {}
	-- First/last row actually rendered per column on the most recent
	-- RenderSlotRows call, so RefreshDisplay's centering math (below) can
	-- measure and re-anchor them -- reset and repopulated every call
	-- rather than fixed once at setup, since which rows are "first"/"last"
	-- can change as the item count changes between sources.
	local firstRowByColumn = {}
	local previousRowByColumn = {}

	local function ClearTable(t)
		for key in pairs(t) do
			t[key] = nil
		end
	end

	--- Builds one fully-wired (but not yet positioned or filled with
	--- data) row widget under `column` -- identical to what used to be
	--- built inline for each entry of a fixed slot list, just factored out
	--- so GetSlotRow can create these on demand as more rows are needed.
	local function CreateSlotRowWidget(column)
		local row = CreateFrame("Frame", nil, column)
		row:SetHeight(SLOT_ROW_HEIGHT)

		local slotLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		slotLabel:SetPoint("TOPLEFT", 0, 0)
		slotLabel:SetWidth(SLOT_LABEL_WIDTH)
		slotLabel:SetJustifyH("LEFT")
		row.slotLabel = slotLabel

		local icon = row:CreateTexture(nil, "ARTWORK")
		icon:SetSize(SLOT_ICON_SIZE, SLOT_ICON_SIZE)
		icon:SetPoint("TOPLEFT", slotLabel, "TOPRIGHT", 6, 0)
		row.icon = icon

		-- Textures can't receive mouse events themselves, so this small
		-- frame sits exactly over the icon (SetAllPoints keeps it in sync)
		-- to scope hover/tooltip to just the icon area -- not the whole
		-- row, which used to trigger the tooltip from anywhere across its
		-- full width, including empty space past the text.
		local iconHitbox = CreateFrame("Frame", nil, row)
		iconHitbox:SetAllPoints(icon)

		local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		nameText:SetPoint("LEFT", icon, "RIGHT", 6, 0)
		nameText:SetPoint("RIGHT", row, "RIGHT")
		nameText:SetJustifyH("LEFT")
		row.nameText = nameText

		-- Actionable, addon-highlighted note -- distinct from the plain
		-- gray secondaryText below, since "catalyze this" is something to
		-- act on, not just flavor text. Anchored under the icon (not
		-- nameText) so it starts flush with the content block's own left
		-- edge instead of losing the icon's width+gap to indentation.
		local catalystText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		catalystText:SetPoint("TOPLEFT", icon, "BOTTOMLEFT", 0, -2)
		catalystText:SetPoint("RIGHT", row, "RIGHT")
		catalystText:SetJustifyH("LEFT")
		catalystText:SetTextColor(unpack(CATALYST_COLOR))
		catalystText:SetText(CATALYST_TEXT)
		catalystText:Hide()
		row.catalystText = catalystText

		-- Same reasoning as catalystText: anchored under the icon so it
		-- gets the full content-block width for obtainedFrom/notes text
		-- (RenderSlotRow re-anchors this below catalystText instead when
		-- catalyst is shown, which is itself icon-aligned, so both cases
		-- stay flush).
		local secondaryText = row:CreateFontString(nil, "OVERLAY", "GameFontDisable")
		secondaryText:SetPoint("TOPLEFT", icon, "BOTTOMLEFT", 0, -2)
		secondaryText:SetPoint("RIGHT", row, "RIGHT")
		secondaryText:SetJustifyH("LEFT")
		secondaryText:Hide()
		row.secondaryText = secondaryText

		SetupItemTooltip(row, iconHitbox)

		return row
	end

	local function GetSlotRow(pool, column, index)
		local row = pool[index]
		if row then return row end
		row = CreateSlotRowWidget(column)
		pool[index] = row
		return row
	end

	--- Renders one row per entry in `items` (in data order), splitting
	--- the first COLUMN_SPLIT into leftColumn and the rest into
	--- rightColumn -- generalizes what used to be a fixed SLOT_ORDER loop
	--- so a build can have any number of slots (e.g. an extra "Alt Main
	--- Hand" appended after the usual 15) without any other code needing
	--- to change. Pooled rows beyond what's needed this call are hidden,
	--- not destroyed, so switching back to a build with more slots later
	--- doesn't have to recreate widgets.
	local function RenderSlotRows(items)
		ClearTable(firstRowByColumn)
		ClearTable(previousRowByColumn)

		local leftCount, rightCount = 0, 0
		for i, itemData in ipairs(items) do
			local isLeft = (i <= COLUMN_SPLIT)
			local column = isLeft and leftColumn or rightColumn
			local pool = isLeft and leftRowPool or rightRowPool
			local poolIndex = isLeft and i or (i - COLUMN_SPLIT)

			local row = GetSlotRow(pool, column, poolIndex)
			row.slotLabel:SetText(itemData.slot or "")

			local previousRow = previousRowByColumn[column]
			row:ClearAllPoints()
			if previousRow then
				row:SetPoint("TOPLEFT", previousRow, "BOTTOMLEFT", 0, -ROW_GAP)
				row:SetPoint("TOPRIGHT", previousRow, "BOTTOMRIGHT", 0, -ROW_GAP)
			else
				row:SetPoint("TOPLEFT", column, "TOPLEFT")
				row:SetPoint("TOPRIGHT", column, "TOPRIGHT")
				firstRowByColumn[column] = row
			end

			RenderSlotRow(row, itemData)
			row:Show()
			previousRowByColumn[column] = row

			if isLeft then
				leftCount = leftCount + 1
			else
				rightCount = rightCount + 1
			end
		end

		for i = leftCount + 1, #leftRowPool do
			leftRowPool[i]:Hide()
		end
		for i = rightCount + 1, #rightRowPool do
			rightRowPool[i]:Hide()
		end
	end

	-- Trinket Tier List view ---------------------------------------------

	-- Wrapped in a scrollframe since the tier-grouped list has no fixed
	-- height (a source can list any number of trinkets) and would
	-- otherwise overflow past the bottom of the fixed-size main frame.
	local trinketScroll = Tracked(CreateFrame("ScrollFrame", nil, content, "UIPanelScrollFrameTemplate"))
	trinketScroll:SetPoint("TOPLEFT", viewToggleRow, "BOTTOMLEFT", 0, -8)
	trinketScroll:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", -22, 0)
	trinketScroll:Hide()

	-- Scroll child: needs an explicit width/height via SetSize -- unlike a
	-- normally-anchored frame, a ScrollFrame's scroll child doesn't reliably
	-- resolve a width from anchors alone (this was the cause of the tier
	-- list rendering completely empty: the child's width stayed effectively
	-- unset, so nothing inside it had anywhere to lay out). Width is fixed
	-- to the scrollframe's own width (no horizontal scrolling needed);
	-- height grows to fit whatever's been laid out -- both are (re)applied
	-- at the top of RenderTrinketList too, since this main frame's size
	-- never changes but re-asserting costs nothing and removes any doubt
	-- about ordering.
	local trinketArea = CreateFrame("Frame", nil, trinketScroll)
	trinketArea:SetSize(math.max(1, trinketScroll:GetWidth()), 1)
	trinketScroll:SetScrollChild(trinketArea)

	local trinketHeaderByTier = {}
	local trinketRowPool = {}

	local function GetTrinketTierHeader(tier)
		local header = trinketHeaderByTier[tier]
		if header then return header end
		header = trinketArea:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		header:SetJustifyH("LEFT")
		header:SetText(tier .. " Tier")
		trinketHeaderByTier[tier] = header
		return header
	end

	local function GetTrinketRow(index)
		local row = trinketRowPool[index]
		if row then return row end

		row = CreateFrame("Frame", nil, trinketArea)
		row:SetHeight(SLOT_ROW_HEIGHT)

		local icon = row:CreateTexture(nil, "ARTWORK")
		icon:SetSize(SLOT_ICON_SIZE, SLOT_ICON_SIZE)
		icon:SetPoint("TOPLEFT", 0, 0)
		row.icon = icon

		-- See the matching comment in the BiS row loop above -- textures
		-- can't receive mouse events, so this hitbox scopes hover/tooltip
		-- to just the icon instead of the whole row.
		local iconHitbox = CreateFrame("Frame", nil, row)
		iconHitbox:SetAllPoints(icon)

		local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		nameText:SetPoint("LEFT", icon, "RIGHT", 6, 0)
		nameText:SetPoint("RIGHT", row, "RIGHT")
		nameText:SetJustifyH("LEFT")
		row.nameText = nameText

		local notesText = row:CreateFontString(nil, "OVERLAY", "GameFontDisable")
		notesText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -2)
		notesText:SetPoint("RIGHT", row, "RIGHT")
		notesText:SetJustifyH("LEFT")
		notesText:Hide()
		row.notesText = notesText

		SetupItemTooltip(row, iconHitbox)

		trinketRowPool[index] = row
		return row
	end

	-- Rebuilds the whole tier list every call (source/view changes are
	-- infrequent user actions, and the list is short) rather than tracking
	-- incremental diffs. Rows/headers are pooled and reused across calls;
	-- indent (12px) visually nests trinkets under their tier header.
	local function RenderTrinketList()
		local scrollWidth = trinketScroll:GetWidth()
		if scrollWidth and scrollWidth > 0 then
			trinketArea:SetWidth(scrollWidth)
		end

		local entry = activeSourceId and GetTrinketEntry(activeSourceId)
		local trinkets = entry and entry.trinkets or {}

		local byTier = {}
		for _, trinketData in ipairs(trinkets) do
			byTier[trinketData.tier] = byTier[trinketData.tier] or {}
			table.insert(byTier[trinketData.tier], trinketData)
		end

		local previousFrame
		local firstFrame -- the very first tier header rendered, for the centering re-anchor below
		local rowCount = 0
		local usedTiers = {}
		-- Tracked alongside the anchor chain (rather than read back via
		-- GetTop/GetBottom afterward) so the scroll child's height is
		-- known exactly regardless of current scroll position.
		local contentHeight = 0

		for _, tier in ipairs(TRINKET_TIER_ORDER) do
			local tierEntries = byTier[tier]
			if tierEntries and #tierEntries > 0 then
				usedTiers[tier] = true
				local header = GetTrinketTierHeader(tier)
				header:ClearAllPoints()
				if previousFrame then
					-- Horizontal position anchors to trinketArea's fixed
					-- LEFT edge, not `previousFrame` (the previous tier's
					-- last trinket row, which itself sits +12 to the
					-- right of ITS OWN header after the trinket-row fix
					-- below) -- otherwise each tier header inherited the
					-- prior tier's item indent, compounding into a
					-- rightward drift the further down the list a tier
					-- sat. Same bug class as the trinket-row fix, just one
					-- level up (headers drifting relative to each other
					-- instead of rows drifting within a tier) -- also
					-- found and fixed in Sections/Enchants.lua's
					-- RenderConsumablesList category headers.
					header:SetPoint("TOP", previousFrame, "BOTTOM", 0, -10)
					header:SetPoint("LEFT", trinketArea, "LEFT", 0, 0)
					contentHeight = contentHeight + 10
				else
					header:SetPoint("TOPLEFT", trinketArea, "TOPLEFT", 0, 0)
					firstFrame = header
				end
				header:Show()
				previousFrame = header
				contentHeight = contentHeight + TIER_HEADER_HEIGHT

				for _, trinketData in ipairs(tierEntries) do
					rowCount = rowCount + 1
					local row = GetTrinketRow(rowCount)
					row:ClearAllPoints()
					-- Horizontal position anchors to `header` (fixed for
					-- this whole tier) via LEFT/RIGHT, independent of
					-- vertical position, which still chains from
					-- previousFrame via TOP -- anchoring the left edge to
					-- the previous trinket row instead (as before) meant
					-- each row inherited the +12 indent already baked into
					-- the row above it, compounding into a rightward
					-- "staircase" the more trinkets a tier had. TOP + LEFT
					-- + RIGHT together fully determine the rect (height
					-- comes from RenderTrinketRow's SetHeight) without
					-- that compounding. Same fix as
					-- Sections/Enchants.lua's RenderConsumablesList.
					row:SetPoint("TOP", previousFrame, "BOTTOM", 0, -4)
					row:SetPoint("LEFT", header, "LEFT", 12, 0)
					row:SetPoint("RIGHT", trinketArea, "RIGHT")
					RenderTrinketRow(row, trinketData)
					row:Show()
					previousFrame = row
					contentHeight = contentHeight + 4 + row:GetHeight()
				end
			end
		end

		for _, tier in ipairs(TRINKET_TIER_ORDER) do
			if not usedTiers[tier] and trinketHeaderByTier[tier] then
				trinketHeaderByTier[tier]:Hide()
			end
		end
		for i = rowCount + 1, #trinketRowPool do
			trinketRowPool[i]:Hide()
		end

		-- Center the rendered content vertically within the scrollframe's
		-- viewport when it's shorter than the available space, instead of
		-- always sitting flush against the top with empty space below.
		-- Padding is added to both the first header's offset AND the
		-- content height, so the scroll range still matches what's
		-- actually laid out (avoiding a mismatch that would make the last
		-- bit of padding-shifted content unreachable by scrolling).
		local topPadding = 0
		if firstFrame then
			local viewportHeight = trinketScroll:GetHeight() or 0
			if contentHeight > 0 and contentHeight < viewportHeight then
				topPadding = (viewportHeight - contentHeight) / 2
			end
			firstFrame:ClearAllPoints()
			firstFrame:SetPoint("TOPLEFT", trinketArea, "TOPLEFT", 0, -topPadding)
		end

		trinketArea:SetHeight(math.max(1, contentHeight + topPadding))
	end

	-- Shown instead of the widgets above when the current class/spec has
	-- no Data/<Class>/ folder scaffolded at all yet.
	local noDataMessage = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	noDataMessage:SetPoint("TOPLEFT", content, "TOPLEFT")
	noDataMessage:SetPoint("RIGHT", content, "RIGHT")
	noDataMessage:SetJustifyH("LEFT")
	noDataMessage:SetWordWrap(true)
	noDataMessage:Hide()

	-----------------------------------------------------------------------
	-- Refresh + selection plumbing
	-----------------------------------------------------------------------

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

		-- The view toggle governs which of contextRow/slotArea/trinketScroll
		-- should actually be visible (set here, not in SelectView, so this
		-- stays correct on every RefreshDisplay call -- e.g. one triggered
		-- by OnChange/OnShow rather than a click on the toggle itself).
		local isBis = (activeView == "bis")
		contextRow:SetShown(isBis)
		slotArea:SetShown(isBis)
		trinketScroll:SetShown(not isBis)

		if activeView == "trinkets" then
			RenderTrinketList()
			return
		end

		local build = activeSourceId and GetBuild(activeSourceId, activeContext)
		local items = (build and build.items) or {}

		RenderSlotRows(items)

		for context, button in pairs(contextButtons) do
			local isActive = (context == activeContext)
			button:SetButtonState(isActive and "PUSHED" or "NORMAL", isActive)
		end

		-- Vertically center the two-column slot list within slotArea when
		-- the taller column's actual content is shorter than the space
		-- available, instead of always sitting flush against the top with
		-- empty space below. Both columns get the SAME padding (derived
		-- from whichever column is taller) so their rows stay aligned
		-- side by side rather than drifting to different starting rows.
		local function ColumnContentHeight(column, lastRow)
			if not lastRow then return 0 end
			local top = column:GetTop()
			local bottom = lastRow:GetBottom()
			if not top or not bottom then return 0 end
			return top - bottom
		end

		local leftHeight = ColumnContentHeight(leftColumn, previousRowByColumn[leftColumn])
		local rightHeight = ColumnContentHeight(rightColumn, previousRowByColumn[rightColumn])
		local actualHeight = math.max(leftHeight, rightHeight)
		local available = slotArea:GetHeight() or 0
		local padding = 0
		if actualHeight > 0 and actualHeight < available then
			padding = (available - actualHeight) / 2
		end

		for _, column in ipairs({ leftColumn, rightColumn }) do
			local firstRow = firstRowByColumn[column]
			if firstRow then
				firstRow:ClearAllPoints()
				firstRow:SetPoint("TOPLEFT", column, "TOPLEFT", 0, -padding)
				firstRow:SetPoint("TOPRIGHT", column, "TOPRIGHT", 0, -padding)
			end
		end
	end

	local function SelectContext(context)
		activeContext = context
		RefreshDisplay()
	end

	local function SelectView(view)
		if activeView == view then return end
		activeView = view

		for viewId, button in pairs(viewButtons) do
			local isActive = (viewId == view)
			button:SetButtonState(isActive and "PUSHED" or "NORMAL", isActive)
		end

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

	local previousViewButton
	for _, v in ipairs(VIEWS) do
		local button = CreateFrame("Button", nil, viewToggleRow, "UIPanelButtonTemplate")
		button:SetSize(v.view == "bis" and 80 or 140, 22)
		button:SetText(v.label)
		if previousViewButton then
			button:SetPoint("LEFT", previousViewButton, "RIGHT", 6, 0)
		else
			button:SetPoint("LEFT", viewToggleRow, "LEFT", 0, 0)
		end
		button:SetScript("OnClick", function() SelectView(v.view) end)

		viewButtons[v.view] = button
		previousViewButton = button
	end
	viewButtons[DEFAULT_VIEW]:SetButtonState("PUSHED", true)

	local sourceDropdown = Tracked(Spectome.UI.CreateSourceDropdown(content, DATA_TYPE, function(sourceId)
		activeSourceId = sourceId
		activeContext = DEFAULT_CONTEXT
		RefreshDisplay()
	end))
	sourceDropdown:SetPoint("TOPLEFT")
	viewToggleRow:SetPoint("TOPLEFT", sourceDropdown, "BOTTOMLEFT", 0, -8)

	-- Re-check class/spec whenever the player's talent loadout changes
	-- (covers respeccing) and whenever this pane becomes visible again
	-- (covers a respec that happened while the panel/tab was closed, which
	-- PLAYER_TALENT_UPDATE wouldn't have reached us for).
	Spectome.PlayerContext.OnChange(RefreshDisplay)
	content:SetScript("OnShow", RefreshDisplay)

	-- The very first RefreshDisplay (triggered above, inside
	-- CreateSourceDropdown's initial selection) ran before viewToggleRow's
	-- TOPLEFT anchor just above was set, so contextRow/slotArea's geometry
	-- (and this centering math) wasn't fully resolved yet. Re-run now that
	-- the whole chain is complete.
	RefreshDisplay()
end)
