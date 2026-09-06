-- Data/DeathKnight/enchants-archon.lua
-- Blood enchant recommendations sourced from Archon. Curated manually by
-- the addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Same schema as Data/DeathKnight/enchants-icyveins.lua (see that file for
-- the fuller field-by-field reasoning). Like Wowhead, Archon's Weapon
-- recommendation has no universal default -- its top-level
-- `enchant`/`itemID` stay empty/0 and Sections/Enchants.lua's row renderer
-- skips straight to the `heroSpecific` sub-rows for it, same as any other
-- slot with nothing at the top level. Unlike Icy Veins/Wowhead, Archon's
-- data is population-based (see Data/DeathKnight/stats-archon.lua's
-- matching reasoning) rather than theorycrafted per hero tree, so Rings
-- shows one pick with no split, and Weapon's two hero-tree entries happen
-- to be identical (Rune of Sanguination for both) rather than Archon
-- distinguishing them.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.enchants = Spectome.Data.DeathKnight.Blood.enchants or {}

Spectome.Data.DeathKnight.Blood.enchants.archon = {
	source = "archon",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	slots = {
		{ slot = "Head", enchant = "Empowered Blessing of Speed", itemID = 243981, notes = "" },
		{ slot = "Shoulders", enchant = "Akil'zon's Swiftness", itemID = 243962, notes = "" },
		{ slot = "Chest", enchant = "Mark of the Worldsoul", itemID = 243977, notes = "" },
		{ slot = "Legs", enchant = "Forest Hunter's Armor Kit", itemID = 244640, notes = "" },
		{ slot = "Feet", enchant = "Farstrider's Hunt", itemID = 244008, notes = "" },
		{ slot = "Rings", enchant = "Eyes of the Eagle", itemID = 243957, notes = "Archon's most popular ring enchant pick (population data, no hero-tree split shown)" },
		{
			slot = "Weapon",
			enchant = "",
			itemID = 0,
			notes = "",
			heroSpecific = {
				deathbringer = { name = "Rune of Sanguination", spellID = 326805 },
				sanlayn = { name = "Rune of Sanguination", spellID = 326805 },
			},
		},
	},
}
