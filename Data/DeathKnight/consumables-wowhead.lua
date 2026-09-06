-- Data/DeathKnight/consumables-wowhead.lua
-- Blood consumables sourced from Wowhead. Curated manually by the addon
-- owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Same schema as Data/DeathKnight/consumables-icyveins.lua, with a
-- different category set/order for this source: both potions here are
-- kept under one "Potion" category (no separate Combat/Health split) for
-- consistency with how Icy Veins' data already groups potions, and this
-- source adds a "Weapon Buff" category Icy Veins doesn't have (see
-- Sections/Enchants.lua's CONSUMABLE_CATEGORY_ORDER, extended to include
-- it). No `warnings` field -- that's specific to Icy Veins' explicit
-- "avoid this item" callout and isn't something Wowhead's data has.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.consumables = Spectome.Data.DeathKnight.Blood.consumables or {}

Spectome.Data.DeathKnight.Blood.consumables.wowhead = {
	source = "wowhead",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	items = {
		{ category = "Flask", name = "Flask of the Blood Knights", itemID = 241325, notes = "Either this or Flask of the Shattered Sun -- comes down to your current stats" },
		{ category = "Flask", name = "Flask of the Shattered Sun", itemID = 241326, notes = "Either this or Flask of the Blood Knights -- comes down to your current stats" },
		{ category = "Potion", name = "Potion of Recklessness", itemID = 241288, notes = "Combat potion" },
		{ category = "Potion", name = "Concentrated Silvermoon Health Potion", itemID = 271883, notes = "Health potion" },
		{ category = "Weapon Buff", name = "Thalassian Phoenix Oil", itemID = 243733, notes = "" },
		{ category = "Augment Rune", name = "Void-Touched Augment Rune", itemID = 259085, notes = "" },
		{ category = "Food", name = "Blooming Feast", itemID = 242273, notes = "" },
	},
}
