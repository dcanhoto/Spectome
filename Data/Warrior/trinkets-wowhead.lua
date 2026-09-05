-- Data/Warrior/trinkets-wowhead.lua
-- Arms trinket tier list sourced from Wowhead. Curated manually by the
-- addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Flat list, not split by context (unlike Data/Warrior/gear-*.lua's
-- Overall/Mythic+ builds) -- ranked S down through C (no D tier listed by
-- Wowhead for this spec). itemID = 0 is the same "no data yet" placeholder
-- convention as BiS gear.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Warrior = Spectome.Data.Warrior or {}
Spectome.Data.Warrior.Arms = Spectome.Data.Warrior.Arms or {}
Spectome.Data.Warrior.Arms.trinkets = Spectome.Data.Warrior.Arms.trinkets or {}

Spectome.Data.Warrior.Arms.trinkets.wowhead = {
	source = "wowhead",
	class = "Warrior",
	spec = "Arms",
	lastUpdated = "2026-09-05",
	trinkets = {
		{ tier = "S", itemID = 270173, notes = "" },
		{ tier = "S", itemID = 270175, notes = "" },
		{ tier = "S", itemID = 270164, notes = "" },
		{ tier = "A", itemID = 273796, notes = "" },
		{ tier = "A", itemID = 250259, notes = "" },
		{ tier = "A", itemID = 250228, notes = "" },
		{ tier = "A", itemID = 270165, notes = "" },
		{ tier = "B", itemID = 250238, notes = "" },
		{ tier = "B", itemID = 250229, notes = "" },
		{ tier = "B", itemID = 193757, notes = "" },
		{ tier = "B", itemID = 193762, notes = "" },
		{ tier = "C", itemID = 270168, notes = "" },
		{ tier = "C", itemID = 273797, notes = "" },
		{ tier = "C", itemID = 270163, notes = "" },
		{ tier = "C", itemID = 273795, notes = "" },
	},
}
