-- Data/Warrior/trinkets-icyveins.lua
-- Arms trinket tier list sourced from Icy Veins. Placeholder scaffold --
-- not yet filled in (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Flat list, not split by context (unlike Data/Warrior/gear-*.lua's
-- Overall/Mythic+ builds) -- ranked S down through D. itemID = 0 is the
-- same "no data yet" placeholder convention as BiS gear.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Warrior = Spectome.Data.Warrior or {}
Spectome.Data.Warrior.Arms = Spectome.Data.Warrior.Arms or {}
Spectome.Data.Warrior.Arms.trinkets = Spectome.Data.Warrior.Arms.trinkets or {}

Spectome.Data.Warrior.Arms.trinkets.icyveins = {
	source = "icyveins",
	class = "Warrior",
	spec = "Arms",
	lastUpdated = "",
	trinkets = {
		{ tier = "S", itemID = 0, notes = "" },
		{ tier = "A", itemID = 0, notes = "" },
		{ tier = "B", itemID = 0, notes = "" },
	},
}
