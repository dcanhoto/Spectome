-- Sections/Enchants.lua
-- Enchants section: a source dropdown (Icy Veins for now -- see
-- Shared/Sources.lua's "enchants" provides list), then an Enchants /
-- Consumables view toggle (same pattern as Sections/Gear.lua's BiS Gear /
-- Trinket Tier List toggle), then whichever view is active:
--
--   Enchants     -- one row per slot (Head/Shoulders/Chest/Legs/Feet/
--                    Rings/Weapon), each with an icon (itemID-based, same
--                    icon-hitbox tooltip pattern as Gear) + curated enchant
--                    name + notes. A slot with no single top-level enchant
--                    of its own (itemID == 0 and enchant == "" -- e.g. Icy
--                    Veins' Rings, which is entirely hero-tree-specific, or
--                    Wowhead's Weapon, which has hero-tree-specific
--                    runeforges but no universal default oil) skips the
--                    main icon/name/notes line entirely rather than
--                    showing an empty "No data yet" row, and goes straight
--                    to its `heroSpecific` sub-rows; a slot with a real
--                    top-level enchant (e.g. Icy Veins' Weapon, which has
--                    both a default oil AND hero-specific runeforges) shows
--                    that normally with any heroSpecific entries as
--                    indented sub-rows underneath. Hero-tree sub-rows show
--                    an icon when the option has an itemID, or no
--                    icon/tooltip at all when it's spellID-only (runeforges
--                    are spells, not items) -- never
--                    GameTooltip:SetSpellByID, per the "keep it simple and
--                    safe" rule. A slot can also carry an `alternative`
--                    (name + itemID, e.g. Method's cheaper-but-still-good
--                    pick) shown as its own icon-hitbox row right under the
--                    main pick, styled secondary (dim/disabled font, same
--                    treatment as notes) -- distinct from `heroSpecific`,
--                    which is a hero-tree split rather than a plain
--                    best-vs-cheaper choice; a slot never needs to mix the
--                    two conventions, but nothing here assumes they're
--                    mutually exclusive.
--   Consumables  -- a flat list grouped by category (in
--                    CONSUMABLE_CATEGORY_ORDER below), each item showing an
--                    icon + name + notes, plus an optional `warnings` note
--                    shown distinctly (accent color) below the list if the
--                    source's data has one.
--
-- Both views share the same item icon loading + hover tooltip logic
-- (RenderIcon + SetupItemTooltip below) as Sections/Gear.lua, duplicated
-- here rather than imported since Gear.lua doesn't expose them as reusable
-- Spectome.UI helpers -- same reasoning as Sections/Stats.lua duplicating
-- Sections/Talents.lua's context-switcher pattern instead of extracting a
-- shared module. Unlike Gear's BiS rows (which have no curated name and
-- show whatever C_Item.GetItemInfo returns), every entry here already has
-- an addon-curated name (`enchant`/`name`), so the item lookup only ever
-- supplies the icon texture -- the label text is always the curated
-- string, never overwritten by the live item name.
--
-- Class/spec comes from Shared/PlayerContext.lua, same as every other
-- section -- re-checked on PLAYER_TALENT_UPDATE and whenever this pane is
-- shown, and replaced with a "No data yet" message if Spectome.Data has no
-- entry at all for the current class/spec.

Spectome = Spectome or {}

local DATA_TYPE = "enchants" -- source filter for the dropdown -- Consumables
                              -- is a sibling data type from the same
                              -- sources, same assumption Sections/Gear.lua
                              -- makes for gear/trinkets sharing one filter.
local NO_DATA_TEXT = "No data yet"
local PLACEHOLDER_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"

local VIEWS = {
	{ view = "enchants", label = "Enchants" },
	{ view = "consumables", label = "Consumables" },
}
local DEFAULT_VIEW = "enchants"

-- Fixed display order for per-hero-tree sub-options (Rings/Weapon) --
-- reuses Shared/ContextLabels.lua for display text (Deathbringer/San'layn),
-- the same lookup Sections/Talents.lua and Sections/Stats.lua use for
-- their own hero-tree/context switchers.
local HERO_TREE_ORDER = { "deathbringer", "sanlayn" }

-- Fixed category display order for Consumables, shared across every
-- source (Icy Veins doesn't have a "Weapon Buff" category, Wowhead does --
-- a source simply contributes no rows to a category it has nothing for,
-- same as Trinket Tier List skipping tiers with no entries).
local CONSUMABLE_CATEGORY_ORDER = { "Flask", "Potion", "Weapon Buff", "Augment Rune", "Food" }

local SLOT_LABEL_WIDTH = 80
local ICON_SIZE = 18
local ROW_HEIGHT = 20
local ROW_GAP = 8
local HERO_ROW_INDENT = 12
local CATEGORY_HEADER_HEIGHT = 18
-- Warning accent color -- distinct from the addon's usual teal-green
-- highlight (see Sections/Gear.lua's CATALYST_COLOR) since a warning is a
-- "don't do this" rather than an actionable positive suggestion.
local WARNING_COLOR = { 1.0, 0.4, 0.3 }

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

local function GetEnchantsEntry(sourceId)
	return GetEntry("enchants", sourceId)
end

local function GetConsumablesEntry(sourceId)
	return GetEntry("consumables", sourceId)
end

local function GetHeroTreeLabel(key)
	return Spectome.ContextLabels[key] or key
end

-------------------------------------------------------------------------------
-- Shared item icon loading + tooltip: used by both Enchants rows (main and
-- hero sub-rows) and Consumables rows. itemID 0/nil shows the same
-- desaturated placeholder icon as Sections/Gear.lua's itemID == 0 case;
-- real IDs try the cache first and refresh once ITEM_DATA_LOAD_RESULT
-- fires if the icon wasn't cached yet. Never touches any name text --
-- every caller already has a curated label to show regardless of the
-- item's load state.
-------------------------------------------------------------------------------

local pendingRows = {} -- itemId -> { row, row, ... } waiting on that item's load

local function RenderIcon(row, itemId)
	row.itemId = itemId

	if not itemId or itemId == 0 then
		row.icon:Show()
		row.icon:SetTexture(PLACEHOLDER_ICON)
		row.icon:SetDesaturated(true)
		row.icon:SetAlpha(0.4)
		return
	end

	row.icon:Show()
	row.icon:SetDesaturated(false)
	row.icon:SetAlpha(1)
	local icon = C_Item.GetItemIconByID(itemId)
	row.icon:SetTexture(icon or PLACEHOLDER_ICON)

	if not C_Item.GetItemInfo(itemId) then
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
			-- this load was in flight -- only refresh it if it's still
			-- showing the item we requested.
			if row.itemId == itemId then
				RenderIcon(row, itemId)
			end
		end
	end
end)

--- Same pattern as Sections/Gear.lua's SetupItemTooltip -- hoverRegion is a
--- small hitbox over the icon, since a plain Texture can't receive mouse
--- events itself. Does nothing for the itemID == 0/nil placeholder state.
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

Spectome.Sections:Register("enchants", "Enchants", function(content)
	local activeSourceId
	local activeView = DEFAULT_VIEW
	local viewButtons = {}

	-- Every top-level widget that should be hidden together when the
	-- current class/spec has no data at all (see noDataMessage below).
	local normalWidgets = {}
	local function Tracked(widget)
		table.insert(normalWidgets, widget)
		return widget
	end

	-----------------------------------------------------------------------
	-- Static layout: view toggle (anchored to the source dropdown once it
	-- exists, at the bottom of this function), then whichever of the two
	-- scrollframes below is active.
	-----------------------------------------------------------------------

	local viewToggleRow = Tracked(CreateFrame("Frame", nil, content))
	viewToggleRow:SetPoint("TOPRIGHT", content, "TOPRIGHT")
	viewToggleRow:SetHeight(22)
	-- (TOPLEFT anchor is set below, once the source dropdown exists.)

	-- Enchants view -------------------------------------------------------

	-- Wrapped in a scrollframe since row count/height varies (hero-specific
	-- sub-rows add extra height to some slots) and could overflow past the
	-- bottom of the fixed-size main frame -- same reasoning as Gear's
	-- Trinket Tier List.
	local enchantScroll = Tracked(CreateFrame("ScrollFrame", nil, content, "UIPanelScrollFrameTemplate"))
	enchantScroll:SetPoint("TOPLEFT", viewToggleRow, "BOTTOMLEFT", 0, -8)
	enchantScroll:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", -22, 0)

	local enchantArea = CreateFrame("Frame", nil, enchantScroll)
	enchantArea:SetSize(math.max(1, enchantScroll:GetWidth()), 1)
	enchantScroll:SetScrollChild(enchantArea)

	local enchantRowPool = {}

	local function GetHeroRow(row, index)
		local heroRow = row.heroRows[index]
		if heroRow then return heroRow end

		heroRow = CreateFrame("Frame", nil, row)
		heroRow:SetHeight(ROW_HEIGHT)

		local icon = heroRow:CreateTexture(nil, "ARTWORK")
		icon:SetSize(ICON_SIZE, ICON_SIZE)
		icon:SetPoint("TOPLEFT", 0, 0)
		heroRow.icon = icon

		local iconHitbox = CreateFrame("Frame", nil, heroRow)
		iconHitbox:SetAllPoints(icon)
		SetupItemTooltip(heroRow, iconHitbox)

		local nameText = heroRow:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		nameText:SetJustifyH("LEFT")
		nameText:SetWordWrap(true)
		heroRow.nameText = nameText

		row.heroRows[index] = heroRow
		return heroRow
	end

	local function GetEnchantRow(index)
		local row = enchantRowPool[index]
		if row then return row end

		row = CreateFrame("Frame", nil, enchantArea)

		local slotLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		slotLabel:SetPoint("TOPLEFT", 0, 0)
		slotLabel:SetWidth(SLOT_LABEL_WIDTH)
		slotLabel:SetJustifyH("LEFT")
		row.slotLabel = slotLabel

		local icon = row:CreateTexture(nil, "ARTWORK")
		icon:SetSize(ICON_SIZE, ICON_SIZE)
		icon:SetPoint("TOPLEFT", slotLabel, "TOPRIGHT", 6, 0)
		row.icon = icon

		-- Textures can't receive mouse events themselves -- see the
		-- matching comment in Sections/Gear.lua.
		local iconHitbox = CreateFrame("Frame", nil, row)
		iconHitbox:SetAllPoints(icon)
		SetupItemTooltip(row, iconHitbox)

		local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		nameText:SetJustifyH("LEFT")
		nameText:SetWordWrap(true)
		row.nameText = nameText

		local notesText = row:CreateFontString(nil, "OVERLAY", "GameFontDisable")
		notesText:SetJustifyH("LEFT")
		notesText:SetWordWrap(true)
		row.notesText = notesText

		-- Optional "alternative" pick (e.g. Method's cheaper-but-still-good
		-- option) -- a single row, not pooled/indexed like heroRows since a
		-- slot only ever has at most one. Styled secondary (GameFontDisable,
		-- same as notesText) rather than GameFontHighlight like the main
		-- pick or hero sub-rows, since it's supplementary info, not a
		-- distinct recommendation of equal weight.
		local altRow = CreateFrame("Frame", nil, row)
		altRow:SetHeight(ROW_HEIGHT)

		local altIcon = altRow:CreateTexture(nil, "ARTWORK")
		altIcon:SetSize(ICON_SIZE, ICON_SIZE)
		altIcon:SetPoint("TOPLEFT", 0, 0)
		altRow.icon = altIcon

		local altIconHitbox = CreateFrame("Frame", nil, altRow)
		altIconHitbox:SetAllPoints(altIcon)
		SetupItemTooltip(altRow, altIconHitbox)

		local altNameText = altRow:CreateFontString(nil, "OVERLAY", "GameFontDisable")
		altNameText:SetPoint("LEFT", altIcon, "RIGHT", 6, 0)
		altNameText:SetPoint("RIGHT", altRow, "RIGHT")
		altNameText:SetJustifyH("LEFT")
		altNameText:SetWordWrap(true)
		altRow.nameText = altNameText

		row.altRow = altRow

		row.heroRows = {}

		enchantRowPool[index] = row
		return row
	end

	--- Renders one slot entry (from Data/<Class>/enchants-<source>.lua's
	--- `slots` array) into `row`, which must already be anchored (position
	--- is read back via GetTop/GetBottom below to size the row). A slot
	--- with no top-level enchant of its own (itemID == 0 AND enchant == ""
	--- -- Icy Veins' Rings, Wowhead's Weapon) skips the main icon/name/notes
	--- entirely rather than showing an empty "No data yet" line, and goes
	--- straight from the slot label to its heroSpecific sub-rows; a slot
	--- with a real top-level enchant renders it normally and any
	--- heroSpecific entries as indented sub-rows underneath that. A
	--- sub-option with only a spellID (the Weapon runeforges) shows no
	--- icon/tooltip at all -- text flush to the row's left edge -- since
	--- there's no item to look up.
	local function RenderEnchantRow(row, slotData)
		row.slotLabel:SetText(slotData.slot or "")

		local itemId = slotData.itemID or 0
		local hasMain = itemId ~= 0 or (slotData.enchant and slotData.enchant ~= "")
		local previousFrame = row.slotLabel

		if hasMain then
			RenderIcon(row, itemId)
			row.nameText:ClearAllPoints()
			row.nameText:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
			row.nameText:SetPoint("RIGHT", row, "RIGHT")
			row.nameText:SetText((slotData.enchant and slotData.enchant ~= "") and slotData.enchant or NO_DATA_TEXT)
			row.nameText:Show()

			local notes = slotData.notes or ""
			if notes ~= "" then
				row.notesText:ClearAllPoints()
				row.notesText:SetPoint("TOPLEFT", row.icon, "BOTTOMLEFT", 0, -2)
				row.notesText:SetPoint("RIGHT", row, "RIGHT")
				row.notesText:SetText(notes)
				row.notesText:Show()
				previousFrame = row.notesText
			else
				row.notesText:Hide()
				previousFrame = row.nameText
			end
		else
			row.itemId = nil
			row.icon:Hide()
			row.nameText:Hide()
			row.notesText:Hide()
		end

		-- Optional "alternative" pick -- rendered right under the main pick
		-- (only makes sense when there is one), before any heroSpecific
		-- sub-rows.
		local alternative = hasMain and slotData.alternative
		if alternative then
			row.altRow:ClearAllPoints()
			row.altRow:SetPoint("TOPLEFT", previousFrame, "BOTTOMLEFT", 0, -4)
			row.altRow:SetPoint("RIGHT", row, "RIGHT")
			RenderIcon(row.altRow, alternative.itemID)
			row.altRow.nameText:SetText("Alternative: " .. (alternative.name or ""))
			row.altRow:SetHeight(math.max(ICON_SIZE, row.altRow.nameText:GetStringHeight()))
			row.altRow:Show()
			previousFrame = row.altRow
		else
			row.altRow:Hide()
		end

		local heroSpecific = slotData.heroSpecific
		local usedHeroRows = 0
		for _, key in ipairs(HERO_TREE_ORDER) do
			local heroData = heroSpecific and heroSpecific[key]
			if heroData then
				usedHeroRows = usedHeroRows + 1
				local heroRow = GetHeroRow(row, usedHeroRows)
				heroRow:ClearAllPoints()
				-- Horizontal position anchors to `row` (this slot's own
				-- row, fixed) via LEFT/RIGHT, independent of vertical
				-- position, which still chains from previousFrame via TOP
				-- -- anchoring the left edge to the previous hero-tree
				-- sub-row instead (as before) meant the second sub-row
				-- (typically San'layn) inherited the first sub-row's own
				-- +HERO_ROW_INDENT offset and added another one on top,
				-- landing further right than the first. Same fix as
				-- Sections/Gear.lua's RenderTrinketList and this file's
				-- own RenderConsumablesList.
				heroRow:SetPoint("TOP", previousFrame, "BOTTOM", 0, -4)
				heroRow:SetPoint("LEFT", row, "LEFT", HERO_ROW_INDENT, 0)
				heroRow:SetPoint("RIGHT", row, "RIGHT")

				if heroData.itemID then
					RenderIcon(heroRow, heroData.itemID)
					heroRow.nameText:ClearAllPoints()
					heroRow.nameText:SetPoint("LEFT", heroRow.icon, "RIGHT", 6, 0)
					heroRow.nameText:SetPoint("RIGHT", heroRow, "RIGHT")
				else
					-- spellID-only (runeforge) -- no item to look up, so no
					-- icon/tooltip at all, per the "keep it simple and
					-- safe" instruction (no GameTooltip:SetSpellByID).
					heroRow.itemId = nil
					heroRow.icon:Hide()
					heroRow.nameText:ClearAllPoints()
					heroRow.nameText:SetPoint("LEFT", heroRow, "LEFT", 0, 0)
					heroRow.nameText:SetPoint("RIGHT", heroRow, "RIGHT")
				end
				heroRow.nameText:SetText(("%s: %s"):format(GetHeroTreeLabel(key), heroData.name or ""))
				heroRow.nameText:SetTextColor(1, 1, 1)
				heroRow:SetHeight(math.max(ICON_SIZE, heroRow.nameText:GetStringHeight()))
				heroRow:Show()
				previousFrame = heroRow
			end
		end

		for i = usedHeroRows + 1, #row.heroRows do
			row.heroRows[i]:Hide()
		end

		-- Row height = distance from the row's own top to whatever the
		-- last rendered piece of content is (main notes/name, or the last
		-- hero sub-row) -- measured via GetTop/GetBottom deltas rather than
		-- summed GetStringHeight() calls, since hero sub-rows are
		-- separately-anchored child frames, not stacked text within `row`.
		local top = row:GetTop()
		local bottom = previousFrame:GetBottom()
		if top and bottom then
			row:SetHeight(math.max(ICON_SIZE, top - bottom))
		else
			row:SetHeight(ROW_HEIGHT)
		end
	end

	-- Rebuilds the whole enchant list every call (source/view changes are
	-- infrequent user actions, and the list is short) rather than tracking
	-- incremental diffs -- same approach as Gear's RenderTrinketList.
	local function RenderEnchantList()
		local scrollWidth = enchantScroll:GetWidth()
		if scrollWidth and scrollWidth > 0 then
			enchantArea:SetWidth(scrollWidth)
		end

		local entry = activeSourceId and GetEnchantsEntry(activeSourceId)
		local slots = entry and entry.slots or {}

		local previousRow
		local firstRow
		local contentHeight = 0

		for i, slotData in ipairs(slots) do
			local row = GetEnchantRow(i)
			row:ClearAllPoints()
			if previousRow then
				row:SetPoint("TOPLEFT", previousRow, "BOTTOMLEFT", 0, -ROW_GAP)
				row:SetPoint("TOPRIGHT", previousRow, "BOTTOMRIGHT", 0, -ROW_GAP)
				contentHeight = contentHeight + ROW_GAP
			else
				row:SetPoint("TOPLEFT", enchantArea, "TOPLEFT")
				row:SetPoint("TOPRIGHT", enchantArea, "TOPRIGHT")
				firstRow = row
			end
			row:Show()
			RenderEnchantRow(row, slotData)
			contentHeight = contentHeight + row:GetHeight()
			previousRow = row
		end

		for i = #slots + 1, #enchantRowPool do
			enchantRowPool[i]:Hide()
		end

		-- Center the rendered content vertically within the scrollframe's
		-- viewport when it's shorter than the available space -- same
		-- reasoning as Gear's RenderTrinketList.
		local topPadding = 0
		if firstRow then
			local viewportHeight = enchantScroll:GetHeight() or 0
			if contentHeight > 0 and contentHeight < viewportHeight then
				topPadding = (viewportHeight - contentHeight) / 2
			end
			firstRow:ClearAllPoints()
			firstRow:SetPoint("TOPLEFT", enchantArea, "TOPLEFT", 0, -topPadding)
			firstRow:SetPoint("TOPRIGHT", enchantArea, "TOPRIGHT", 0, -topPadding)
		end

		enchantArea:SetHeight(math.max(1, contentHeight + topPadding))
	end

	-- Consumables view ------------------------------------------------------

	local consumablesScroll = Tracked(CreateFrame("ScrollFrame", nil, content, "UIPanelScrollFrameTemplate"))
	consumablesScroll:SetPoint("TOPLEFT", viewToggleRow, "BOTTOMLEFT", 0, -8)
	consumablesScroll:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", -22, 0)
	consumablesScroll:Hide()

	local consumablesArea = CreateFrame("Frame", nil, consumablesScroll)
	consumablesArea:SetSize(math.max(1, consumablesScroll:GetWidth()), 1)
	consumablesScroll:SetScrollChild(consumablesArea)

	local categoryHeaderPool = {}
	local consumableRowPool = {}
	-- Created lazily on first RenderConsumablesList call (needs
	-- consumablesArea to already exist as its parent).
	local warningTextWidget

	local function GetCategoryHeader(category)
		local header = categoryHeaderPool[category]
		if header then return header end
		header = consumablesArea:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		header:SetJustifyH("LEFT")
		header:SetText(category)
		categoryHeaderPool[category] = header
		return header
	end

	local function GetConsumableRow(index)
		local row = consumableRowPool[index]
		if row then return row end

		row = CreateFrame("Frame", nil, consumablesArea)
		row:SetHeight(ROW_HEIGHT)

		local icon = row:CreateTexture(nil, "ARTWORK")
		icon:SetSize(ICON_SIZE, ICON_SIZE)
		icon:SetPoint("TOPLEFT", 0, 0)
		row.icon = icon

		local iconHitbox = CreateFrame("Frame", nil, row)
		iconHitbox:SetAllPoints(icon)
		SetupItemTooltip(row, iconHitbox)

		local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		nameText:SetPoint("LEFT", icon, "RIGHT", 6, 0)
		nameText:SetPoint("RIGHT", row, "RIGHT")
		nameText:SetJustifyH("LEFT")
		row.nameText = nameText

		local notesText = row:CreateFontString(nil, "OVERLAY", "GameFontDisable")
		notesText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -2)
		notesText:SetPoint("RIGHT", row, "RIGHT")
		notesText:SetJustifyH("LEFT")
		notesText:SetWordWrap(true)
		notesText:Hide()
		row.notesText = notesText

		consumableRowPool[index] = row
		return row
	end

	local function RenderConsumableRow(row, itemData)
		RenderIcon(row, itemData.itemID or 0)
		row.nameText:SetText(itemData.name or NO_DATA_TEXT)

		local notes = itemData.notes or ""
		if notes ~= "" then
			row.notesText:SetText(notes)
			row.notesText:Show()
		else
			row.notesText:Hide()
		end

		local height = ICON_SIZE
		if notes ~= "" then
			height = height + 2 + row.notesText:GetStringHeight()
		end
		row:SetHeight(math.max(height, ROW_HEIGHT))
	end

	-- Rebuilds the whole consumables list every call -- same approach as
	-- Gear's RenderTrinketList and RenderEnchantList above.
	local function RenderConsumablesList()
		local scrollWidth = consumablesScroll:GetWidth()
		if scrollWidth and scrollWidth > 0 then
			consumablesArea:SetWidth(scrollWidth)
		end

		local entry = activeSourceId and GetConsumablesEntry(activeSourceId)
		local items = entry and entry.items or {}
		local warnings = entry and entry.warnings

		local byCategory = {}
		for _, itemData in ipairs(items) do
			byCategory[itemData.category] = byCategory[itemData.category] or {}
			table.insert(byCategory[itemData.category], itemData)
		end

		local previousFrame
		local firstFrame
		local rowCount = 0
		local usedCategories = {}
		local contentHeight = 0

		for _, category in ipairs(CONSUMABLE_CATEGORY_ORDER) do
			local categoryItems = byCategory[category]
			if categoryItems and #categoryItems > 0 then
				usedCategories[category] = true
				local header = GetCategoryHeader(category)
				header:ClearAllPoints()
				if previousFrame then
					-- Horizontal position anchors to consumablesArea's
					-- fixed LEFT edge, not `previousFrame` (the previous
					-- category's last item row, which itself sits +12 to
					-- the right of ITS OWN header after the item-row fix
					-- below) -- otherwise each header inherited the prior
					-- category's item indent, compounding into a
					-- rightward drift the further down the list a
					-- category sat. Same bug class as the item-row fix,
					-- just one level up (headers drifting relative to
					-- each other instead of items drifting within a
					-- category).
					header:SetPoint("TOP", previousFrame, "BOTTOM", 0, -10)
					header:SetPoint("LEFT", consumablesArea, "LEFT", 0, 0)
					contentHeight = contentHeight + 10
				else
					header:SetPoint("TOPLEFT", consumablesArea, "TOPLEFT", 0, 0)
					firstFrame = header
				end
				header:Show()
				previousFrame = header
				contentHeight = contentHeight + CATEGORY_HEADER_HEIGHT

				for _, itemData in ipairs(categoryItems) do
					rowCount = rowCount + 1
					local row = GetConsumableRow(rowCount)
					row:ClearAllPoints()
					-- Horizontal position anchors to `header` (fixed for
					-- this whole category) via LEFT/RIGHT, independent of
					-- vertical position, which still chains from
					-- previousFrame via TOP -- anchoring the left edge to
					-- the previous ITEM row instead (as before) meant each
					-- row inherited the +12 indent already baked into the
					-- row above it, compounding into a rightward
					-- "staircase" the more items a category had. TOP +
					-- LEFT + RIGHT together fully determine the rect
					-- (height comes from RenderConsumableRow's SetHeight
					-- below) without that compounding.
					row:SetPoint("TOP", previousFrame, "BOTTOM", 0, -4)
					row:SetPoint("LEFT", header, "LEFT", 12, 0)
					row:SetPoint("RIGHT", consumablesArea, "RIGHT")
					RenderConsumableRow(row, itemData)
					row:Show()
					previousFrame = row
					contentHeight = contentHeight + 4 + row:GetHeight()
				end
			end
		end

		for _, category in ipairs(CONSUMABLE_CATEGORY_ORDER) do
			if not usedCategories[category] and categoryHeaderPool[category] then
				categoryHeaderPool[category]:Hide()
			end
		end
		for i = rowCount + 1, #consumableRowPool do
			consumableRowPool[i]:Hide()
		end

		-- Warning note, shown distinctly (accent color) below the
		-- categorized list, only if this source's data has one.
		if not warningTextWidget then
			warningTextWidget = consumablesArea:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			warningTextWidget:SetJustifyH("LEFT")
			warningTextWidget:SetWordWrap(true)
			warningTextWidget:SetTextColor(unpack(WARNING_COLOR))
		end
		warningTextWidget:ClearAllPoints()
		if warnings and warnings ~= "" then
			warningTextWidget:SetText("Warning: " .. warnings)
			if previousFrame then
				warningTextWidget:SetPoint("TOPLEFT", previousFrame, "BOTTOMLEFT", 0, -16)
				contentHeight = contentHeight + 16
			else
				warningTextWidget:SetPoint("TOPLEFT", consumablesArea, "TOPLEFT", 0, 0)
				firstFrame = warningTextWidget
			end
			warningTextWidget:SetPoint("RIGHT", consumablesArea, "RIGHT")
			warningTextWidget:Show()
			contentHeight = contentHeight + warningTextWidget:GetStringHeight()
		else
			warningTextWidget:Hide()
		end

		local topPadding = 0
		if firstFrame then
			local viewportHeight = consumablesScroll:GetHeight() or 0
			if contentHeight > 0 and contentHeight < viewportHeight then
				topPadding = (viewportHeight - contentHeight) / 2
			end
			firstFrame:ClearAllPoints()
			firstFrame:SetPoint("TOPLEFT", consumablesArea, "TOPLEFT", 0, -topPadding)
		end

		consumablesArea:SetHeight(math.max(1, contentHeight + topPadding))
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

		-- The view toggle governs which of enchantScroll/consumablesScroll
		-- should actually be visible (set here, not in SelectView, so this
		-- stays correct on every RefreshDisplay call) -- same fix already
		-- applied to Sections/Gear.lua's BiS/Trinket toggle.
		local isEnchants = (activeView == "enchants")
		enchantScroll:SetShown(isEnchants)
		consumablesScroll:SetShown(not isEnchants)

		if isEnchants then
			RenderEnchantList()
		else
			RenderConsumablesList()
		end
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

	local previousViewButton
	for _, v in ipairs(VIEWS) do
		local button = CreateFrame("Button", nil, viewToggleRow, "UIPanelButtonTemplate")
		button:SetSize(v.view == "enchants" and 90 or 120, 22)
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
		RefreshDisplay()
	end))
	sourceDropdown:SetPoint("TOPLEFT")
	viewToggleRow:SetPoint("TOPLEFT", sourceDropdown, "BOTTOMLEFT", 0, -8)

	-- Re-check class/spec whenever the player's talent loadout changes
	-- (covers respeccing) and whenever this pane becomes visible again.
	Spectome.PlayerContext.OnChange(RefreshDisplay)
	content:SetScript("OnShow", RefreshDisplay)

	-- The very first RefreshDisplay (triggered above, inside
	-- CreateSourceDropdown's initial selection) ran before viewToggleRow's
	-- TOPLEFT anchor just above was set, so scrollframe geometry wasn't
	-- fully resolved yet. Re-run now that the whole chain is complete.
	RefreshDisplay()
end)
