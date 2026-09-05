-- Data/Shaman/trinkets-method.lua
-- Restoration trinket tier list sourced from Method. Curated manually by
-- the addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Flat list, not split by context (unlike Data/Shaman/gear-*.lua's
-- Overall/Mythic+ builds) -- ranked S down through B (no C/D/F tier listed
-- by Method for this spec). itemID = 0 is the same "no data yet"
-- placeholder convention as BiS gear.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Shaman = Spectome.Data.Shaman or {}
Spectome.Data.Shaman.Restoration = Spectome.Data.Shaman.Restoration or {}
Spectome.Data.Shaman.Restoration.trinkets = Spectome.Data.Shaman.Restoration.trinkets or {}

Spectome.Data.Shaman.Restoration.trinkets.method = {
	source = "method",
	class = "Shaman",
	spec = "Restoration",
	lastUpdated = "2026-09-05",
	trinkets = {
		{ tier = "S", itemID = 270162, notes = "Strong absorb + cooldown reduction on ally death; great Progression/M+ pick" },
		{ tier = "S", itemID = 270167, notes = "Passive, high uptime, equip-and-forget" },
		{ tier = "A", itemID = 250215, notes = "Crit on-use; regains mana on crit from Resurgence, macro into Healing Tide Totem/Ascendance" },
		{ tier = "B", itemID = 193757, notes = "Passive M+ option; few good alternatives this tier. Train it daily for 7 days for the stat proc" },
	},
}
