-- Data/Warrior/trinkets-archon.lua
-- Arms trinket tier list sourced from Archon. Curated manually by the
-- addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Flat list, not split by context (unlike Data/Warrior/gear-*.lua's
-- Overall/Mythic+ builds) -- ranked S down through C (no D tier listed by
-- Archon for this spec). itemID = 0 is the same "no data yet" placeholder
-- convention as BiS gear.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Warrior = Spectome.Data.Warrior or {}
Spectome.Data.Warrior.Arms = Spectome.Data.Warrior.Arms or {}
Spectome.Data.Warrior.Arms.trinkets = Spectome.Data.Warrior.Arms.trinkets or {}

Spectome.Data.Warrior.Arms.trinkets.archon = {
	source = "archon",
	class = "Warrior",
	spec = "Arms",
	lastUpdated = "2026-09-05",
	trinkets = {
		{ tier = "S", itemID = 270173, notes = "Archon BiS pick" },
		{ tier = "S", itemID = 270175, notes = "Archon BiS pick" },
		{ tier = "A", itemID = 270165, notes = "" },
		{ tier = "A", itemID = 273796, notes = "" },
		{ tier = "A", itemID = 249342, notes = "" },
		{ tier = "A", itemID = 250228, notes = "" },
		{ tier = "A", itemID = 250229, notes = "" },
		{ tier = "B", itemID = 274493, notes = "" },
		{ tier = "B", itemID = 249343, notes = "" },
		{ tier = "B", itemID = 248583, notes = "" },
		{ tier = "C", itemID = 250259, notes = "" },
		{ tier = "C", itemID = 265657, notes = "" },
		{ tier = "C", itemID = 270164, notes = "" },
		{ tier = "C", itemID = 260235, notes = "" },
	},
}
