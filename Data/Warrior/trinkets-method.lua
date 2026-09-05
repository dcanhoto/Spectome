-- Data/Warrior/trinkets-method.lua
-- Arms trinket tier list sourced from Method. Curated manually by the
-- addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Flat list, not split by context (unlike Data/Warrior/gear-*.lua's
-- Overall/Mythic+ builds) -- ranked S down through A (no lower tiers listed
-- by Method for this spec). itemID = 0 is the same "no data yet"
-- placeholder convention as BiS gear.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Warrior = Spectome.Data.Warrior or {}
Spectome.Data.Warrior.Arms = Spectome.Data.Warrior.Arms or {}
Spectome.Data.Warrior.Arms.trinkets = Spectome.Data.Warrior.Arms.trinkets or {}

Spectome.Data.Warrior.Arms.trinkets.method = {
	source = "method",
	class = "Warrior",
	spec = "Arms",
	lastUpdated = "2026-09-05",
	trinkets = {
		{ tier = "S", itemID = 270173, notes = "Ideal pick" },
		{ tier = "S", itemID = 270175, notes = "Ideal pick" },
		{ tier = "A", itemID = 270165, notes = "Decent alternative if you can't get either S-tier pick" },
		{ tier = "A", itemID = 193762, notes = "Decent alternative if you can't get either S-tier pick" },
	},
}
