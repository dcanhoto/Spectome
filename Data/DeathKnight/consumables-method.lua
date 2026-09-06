-- Data/DeathKnight/consumables-method.lua
-- Blood consumables sourced from Method. Curated manually by the addon
-- owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Same schema as Data/DeathKnight/consumables-icyveins.lua. Both Flask
-- entries are hero-tree-specific (noted per-tree rather than split via a
-- separate field -- consumables aren't a context-switched view, just a
-- flat categorized list, so "Deathbringer"/"San'layn" live in `notes`
-- exactly like any other caveat). No `warnings` field -- that's specific
-- to Icy Veins' explicit "avoid this item" callout.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.consumables = Spectome.Data.DeathKnight.Blood.consumables or {}

Spectome.Data.DeathKnight.Blood.consumables.method = {
	source = "method",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	items = {
		{ category = "Flask", name = "Flask of the Shattered Sun", itemID = 241326, notes = "Deathbringer" },
		{ category = "Flask", name = "Flask of the Blood Knights", itemID = 241325, notes = "San'layn" },
		{ category = "Potion", name = "Potion of Recklessness", itemID = 241288, notes = "Combat potion" },
		{ category = "Potion", name = "Light's Potential", itemID = 241309, notes = "Combat potion, cheaper alternative" },
		{ category = "Potion", name = "Concentrated Silvermoon Health Potion", itemID = 271883, notes = "Health potion" },
		{ category = "Food", name = "Harandar Celebration", itemID = 255846, notes = "" },
		{ category = "Food", name = "Royal Roast", itemID = 242275, notes = "" },
		{ category = "Weapon Buff", name = "Thalassian Phoenix Oil", itemID = 243733, notes = "" },
		{ category = "Augment Rune", name = "Void-Touched Augment Rune", itemID = 259085, notes = "" },
	},
}
