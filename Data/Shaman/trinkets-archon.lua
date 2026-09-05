-- Data/Shaman/trinkets-archon.lua
-- Restoration trinket tier list sourced from Archon. Curated manually by
-- the addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Flat list, not split by context (unlike Data/Shaman/gear-*.lua's
-- Overall/Mythic+ builds) -- ranked S down through C (no D or F tier
-- listed by Archon for this spec). itemID = 0 is the same "no data yet"
-- placeholder convention as BiS gear.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Shaman = Spectome.Data.Shaman or {}
Spectome.Data.Shaman.Restoration = Spectome.Data.Shaman.Restoration or {}
Spectome.Data.Shaman.Restoration.trinkets = Spectome.Data.Shaman.Restoration.trinkets or {}

Spectome.Data.Shaman.Restoration.trinkets.archon = {
	source = "archon",
	class = "Shaman",
	spec = "Restoration",
	lastUpdated = "2026-09-05",
	trinkets = {
		{ tier = "S", itemID = 270162, notes = "" },
		{ tier = "A", itemID = 270164, notes = "" },
		{ tier = "A", itemID = 250215, notes = "" },
		{ tier = "A", itemID = 264507, notes = "" },
		{ tier = "A", itemID = 270167, notes = "" },
		{ tier = "B", itemID = 248583, notes = "" },
		{ tier = "B", itemID = 251792, notes = "" },
		{ tier = "B", itemID = 268292, notes = "" },
		{ tier = "B", itemID = 274493, notes = "" },
		{ tier = "B", itemID = 273796, notes = "" },
		{ tier = "B", itemID = 193757, notes = "" },
		{ tier = "B", itemID = 249343, notes = "" },
		{ tier = "B", itemID = 250255, notes = "" },
		{ tier = "B", itemID = 250214, notes = "" },
		{ tier = "B", itemID = 250248, notes = "" },
		{ tier = "C", itemID = 270171, notes = "" },
	},
}
