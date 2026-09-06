-- Data/DeathKnight/enchants-method.lua
-- Blood enchant recommendations sourced from Method. Curated manually by
-- the addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Same schema as Data/DeathKnight/enchants-icyveins.lua, plus Method's own
-- addition: an `alternative` (name + itemID) on Head/Shoulders/Chest/Legs/
-- Feet -- a plain best-vs-cheaper choice, not a hero-tree split, so it's a
-- separate field from `heroSpecific` (Sections/Enchants.lua renders it as
-- its own secondary icon-hitbox row under the main pick). Rings has no
-- alternative (single pick, no split at all). Weapon has no universal
-- default -- same as Wowhead/Archon, its top-level `enchant`/`itemID` stay
-- empty/0 and the row renderer skips straight to `heroSpecific`.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.enchants = Spectome.Data.DeathKnight.Blood.enchants or {}

Spectome.Data.DeathKnight.Blood.enchants.method = {
	source = "method",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	slots = {
		{ slot = "Head", enchant = "Empowered Rune of Avoidance", itemID = 244007, notes = "", alternative = { name = "Empowered Blessing of Speed", itemID = 243981 } },
		{ slot = "Shoulders", enchant = "Amirdrassil's Grace", itemID = 243990, notes = "", alternative = { name = "Akil'zon's Swiftness", itemID = 243962 } },
		{ slot = "Chest", enchant = "Mark of the Worldsoul", itemID = 243977, notes = "", alternative = { name = "Mark of Nalorakk", itemID = 243946 } },
		{ slot = "Legs", enchant = "Forest Hunter's Armor Kit", itemID = 244640, notes = "", alternative = { name = "Blood Knight's Armor Kit", itemID = 244643 } },
		{ slot = "Feet", enchant = "Lynx's Dexterity", itemID = 243953, notes = "", alternative = { name = "Farstrider's Hunt", itemID = 244008 } },
		{ slot = "Rings", enchant = "Eyes of the Eagle", itemID = 243957, notes = "" },
		{
			slot = "Weapon",
			enchant = "",
			itemID = 0,
			notes = "",
			heroSpecific = {
				deathbringer = { name = "Rune of Sanguination (default) / Rune of the Fallen Crusader (higher target counts, minor extra defensive benefit)", spellID = 326805 },
				sanlayn = { name = "Rune of Sanguination", spellID = 326805 },
			},
		},
	},
}
