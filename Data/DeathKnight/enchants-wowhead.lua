-- Data/DeathKnight/enchants-wowhead.lua
-- Blood enchant recommendations sourced from Wowhead. Curated manually by
-- the addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Same schema as Data/DeathKnight/enchants-icyveins.lua (see that file for
-- the fuller field-by-field reasoning), with two notable differences from
-- Icy Veins' data:
--   - Rings has a single universal enchant (Wowhead doesn't split it by
--     hero tree) -- no `heroSpecific` table at all for this slot.
--   - Weapon has NO universal default -- unlike Icy Veins (which has a
--     default oil plus hero-specific runeforge options on top of it),
--     Wowhead's Weapon recommendation is purely hero-tree-specific. Its
--     top-level `enchant`/`itemID` are left empty/0 (the same "nothing at
--     this level" placeholder Rings uses on Icy Veins), and
--     Sections/Enchants.lua's row renderer already handles this generically
--     -- a slot with no top-level enchant just skips straight to its
--     `heroSpecific` sub-rows instead of showing an empty line.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.enchants = Spectome.Data.DeathKnight.Blood.enchants or {}

Spectome.Data.DeathKnight.Blood.enchants.wowhead = {
	source = "wowhead",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	slots = {
		{ slot = "Head", enchant = "Empowered Blessing of Speed", itemID = 243981, notes = "" },
		{ slot = "Shoulders", enchant = "Akil'zon's Swiftness", itemID = 243962, notes = "" },
		{ slot = "Chest", enchant = "Mark of the Worldsoul", itemID = 243977, notes = "" },
		{ slot = "Legs", enchant = "Forest Hunter's Armor Kit", itemID = 244640, notes = "" },
		{ slot = "Feet", enchant = "Farstrider's Hunt", itemID = 244008, notes = "" },
		{ slot = "Rings", enchant = "Nature's Fury", itemID = 243986, notes = "Wowhead recommends this for both hero trees (no split)" },
		{
			slot = "Weapon",
			enchant = "",
			itemID = 0,
			notes = "",
			heroSpecific = {
				deathbringer = { name = "Rune of Sanguination (Single-Target) / Rune of the Fallen Crusader (10T+ AoE)", spellID = 326805 },
				sanlayn = { name = "Rune of Sanguination", spellID = 326805 },
			},
		},
	},
}
