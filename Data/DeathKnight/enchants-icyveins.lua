-- Data/DeathKnight/enchants-icyveins.lua
-- Blood enchant recommendations sourced from Icy Veins. Curated manually by
-- the addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Flat list, one entry per slot, in the order Icy Veins presents them.
-- `itemID` is the enchant's scroll/formula item (used only for its icon +
-- tooltip -- the displayed name is always the curated `enchant` string,
-- never the live item name); itemID = 0 is the "no data yet"/"no single
-- default for this slot" placeholder, same convention as BiS gear.
--
-- `heroSpecific` is present only on slots where Deathbringer and San'layn
-- want different enchants (Rings, Weapon) -- keyed by hero tree id (see
-- Shared/ContextLabels.lua for their display names), each value an
-- itemID-based option (Rings) or a spellID-based one (Weapon runeforges --
-- runeforges are spells, not items, so there's no itemID/tooltip for
-- them). Rings has no single "default" enchant at all (every recommendation
-- is hero-tree-specific), hence its top-level `enchant`/`itemID` stay
-- empty/0 rather than picking one tree's option as a fake default.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.enchants = Spectome.Data.DeathKnight.Blood.enchants or {}

Spectome.Data.DeathKnight.Blood.enchants.icyveins = {
	source = "icyveins",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	slots = {
		{ slot = "Head", enchant = "Empowered Blessing of Speed", itemID = 243981, notes = "" },
		{ slot = "Shoulders", enchant = "Akil'zon's Swiftness", itemID = 243962, notes = "" },
		{ slot = "Chest", enchant = "Mark of the Worldsoul", itemID = 243977, notes = "" },
		{ slot = "Legs", enchant = "Forest Hunter's Armor Kit", itemID = 244640, notes = "" },
		{ slot = "Feet", enchant = "Farstrider's Hunt", itemID = 244008, notes = "" },
		{
			slot = "Rings",
			enchant = "",
			itemID = 0,
			notes = "",
			heroSpecific = {
				deathbringer = { name = "Silvermoon's Tenacity", itemID = 244016 },
				sanlayn = { name = "Nature's Fury", itemID = 243986 },
			},
		},
		{
			slot = "Weapon",
			enchant = "Thalassian Phoenix Oil",
			itemID = 243733,
			notes = "Default weapon imbuement once fully geared, for all content.",
			heroSpecific = {
				deathbringer = { name = "Rune of Sanguination (up to 10T) -> Rune of the Fallen Crusader (10T+)", spellID = 326805 },
				sanlayn = { name = "Rune of Sanguination", spellID = 326805 },
			},
		},
	},
}
