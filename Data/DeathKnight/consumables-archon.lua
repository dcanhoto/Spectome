-- Data/DeathKnight/consumables-archon.lua
-- Blood consumables sourced from Archon. Curated manually by the addon
-- owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Same schema as Data/DeathKnight/consumables-icyveins.lua. Uses the
-- "Weapon Buff" category Wowhead's data introduced (see
-- Sections/Enchants.lua's CONSUMABLE_CATEGORY_ORDER) rather than Icy
-- Veins' plain item list, since Thalassian Phoenix Oil doesn't fit Flask/
-- Potion/Food/Augment Rune. No `warnings` field -- that's specific to Icy
-- Veins' explicit "avoid this item" callout and isn't something Archon's
-- population-based data has.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.consumables = Spectome.Data.DeathKnight.Blood.consumables or {}

Spectome.Data.DeathKnight.Blood.consumables.archon = {
	source = "archon",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	items = {
		{ category = "Flask", name = "Flask of the Blood Knights", itemID = 241325, notes = "" },
		{ category = "Potion", name = "Concentrated Silvermoon Health Potion", itemID = 271883, notes = "Health potion" },
		{ category = "Potion", name = "Light's Potential", itemID = 241309, notes = "Combat potion" },
		{ category = "Food", name = "Harandar Celebration", itemID = 255846, notes = "" },
		{ category = "Weapon Buff", name = "Thalassian Phoenix Oil", itemID = 243733, notes = "" },
	},
}
