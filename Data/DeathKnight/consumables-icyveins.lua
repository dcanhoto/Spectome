-- Data/DeathKnight/consumables-icyveins.lua
-- Blood consumables (flasks/potions/food/augment runes) sourced from Icy
-- Veins. Curated manually by the addon owner (see SPECTOME_GUIDELINES.md
-- "Data policy").
--
-- Flat list grouped for display by `category` (Flask/Potion/Food/Augment
-- Rune, in that order -- see Sections/Enchants.lua's
-- CONSUMABLE_CATEGORY_ORDER), not split by hero tree or context -- unlike
-- Stats/Enchants, consumable choice here doesn't depend on Deathbringer vs
-- San'layn. itemID is used only for icon + tooltip, same convention as
-- everywhere else.
--
-- `warnings` is a separate top-level string (not an item entry) for a
-- consumable Icy Veins explicitly recommends AGAINST -- Draught of Rampant
-- Abandon has higher Strength than Light's Potential, but its
-- silence-in-a-zone downside is a liability for a tank who needs to
-- reposition enemies, so it's called out as a warning rather than listed
-- as a recommended item.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.consumables = Spectome.Data.DeathKnight.Blood.consumables or {}

Spectome.Data.DeathKnight.Blood.consumables.icyveins = {
	source = "icyveins",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	items = {
		{ category = "Flask", name = "Flask of the Shattered Sun", itemID = 241326, notes = "Best for both San'layn and Deathbringer depending on current stats -- sim to confirm, margin of error is small" },
		{ category = "Flask", name = "Flask of the Blood Knights", itemID = 241325, notes = "Alternative for San'layn depending on stats" },
		{ category = "Flask", name = "Flask of Thalassian Resistance", itemID = 241320, notes = "Alternative for Deathbringer depending on stats" },
		{ category = "Potion", name = "Potion of Recklessness", itemID = 241288, notes = "Default potion" },
		{ category = "Potion", name = "Light's Potential", itemID = 241309, notes = "Slightly worse than Potion of Recklessness; fine if much cheaper to craft/buy" },
		{ category = "Potion", name = "Concentrated Silvermoon Health Potion", itemID = 271883, notes = "Use for in-combat healing -- doesn't share a cooldown with Healthstones, so both can be used independently" },
		{ category = "Food", name = "Harandar Celebration", itemID = 255846, notes = "Raid feast (primary stat) -- feasts are the only Midnight food granting Stamina alongside primary/secondary stats" },
		{ category = "Food", name = "Blooming Feast", itemID = 242273, notes = "Raid feast (secondary stats) -- comparable to Harandar Celebration, comes down to which feast your raid is placing" },
		{ category = "Food", name = "Royal Roast", itemID = 242275, notes = "Personal food equivalent (primary stat) -- slightly worse than the feast version since it lacks Stamina" },
		{ category = "Food", name = "Champion's Bento", itemID = 242274, notes = "Personal food equivalent (secondary stat) -- slightly worse than the feast version since it lacks Stamina" },
		{ category = "Augment Rune", name = "Void-Touched Augment Rune", itemID = 259085, notes = "The augment rune to use for the entirety of the expansion" },
		{ category = "Augment Rune", name = "Ethereal Augment Rune", itemID = 243191, notes = "Permanent stopgap from K'aresh -- very small primary stat amount, but always available when Void-Touched is financially out of reach" },
	},
	warnings = "Avoid Draught of Rampant Abandon despite its higher Strength -- its silence-zone downside is a serious liability for a tank's positioning duties.",
}
