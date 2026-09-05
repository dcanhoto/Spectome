-- Data/Shaman/trinkets-wowhead.lua
-- Restoration trinket tier list sourced from Wowhead. Curated manually by
-- the addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Flat list, not split by context (unlike Data/Shaman/gear-*.lua's
-- Overall/Mythic+ builds) -- ranked S down through F (Wowhead calls out two
-- trinkets as actively bad picks for this spec, hence the F tier -- see
-- TRINKET_TIER_ORDER in Sections/Gear.lua, extended to include "F" for this
-- data). itemID = 0 is the same "no data yet" placeholder convention as
-- BiS gear.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Shaman = Spectome.Data.Shaman or {}
Spectome.Data.Shaman.Restoration = Spectome.Data.Shaman.Restoration or {}
Spectome.Data.Shaman.Restoration.trinkets = Spectome.Data.Shaman.Restoration.trinkets or {}

Spectome.Data.Shaman.Restoration.trinkets.wowhead = {
	source = "wowhead",
	class = "Shaman",
	spec = "Restoration",
	lastUpdated = "2026-09-05",
	trinkets = {
		{ tier = "S", itemID = 270162, notes = "" },
		{ tier = "S", itemID = 270164, notes = "" },
		{ tier = "S", itemID = 270167, notes = "" },
		{ tier = "S", itemID = 270169, notes = "" },
		{ tier = "A", itemID = 193757, notes = "" },
		{ tier = "A", itemID = 250215, notes = "" },
		{ tier = "A", itemID = 248583, notes = "" },
		{ tier = "A", itemID = 251792, notes = "" },
		{ tier = "A", itemID = 250255, notes = "" },
		{ tier = "B", itemID = 250214, notes = "" },
		{ tier = "B", itemID = 273796, notes = "" },
		{ tier = "C", itemID = 250248, notes = "" },
		{ tier = "D", itemID = 273649, notes = "" },
		{ tier = "D", itemID = 270171, notes = "" },
		{ tier = "D", itemID = 250254, notes = "" },
		{ tier = "F", itemID = 193748, notes = "" },
		{ tier = "F", itemID = 264701, notes = "" },
	},
}
