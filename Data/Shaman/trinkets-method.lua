-- Data/Shaman/trinkets-method.lua
-- Restoration trinket tier list sourced from Method. Placeholder scaffold --
-- not yet filled in (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Flat list, not split by context (unlike Data/Shaman/gear-*.lua's
-- Overall/Mythic+ builds) -- ranked S down through D. itemID = 0 is the
-- same "no data yet" placeholder convention as BiS gear.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Shaman = Spectome.Data.Shaman or {}
Spectome.Data.Shaman.Restoration = Spectome.Data.Shaman.Restoration or {}
Spectome.Data.Shaman.Restoration.trinkets = Spectome.Data.Shaman.Restoration.trinkets or {}

Spectome.Data.Shaman.Restoration.trinkets.method = {
	source = "method",
	class = "Shaman",
	spec = "Restoration",
	lastUpdated = "",
	trinkets = {
		{ tier = "S", itemID = 0, notes = "" },
		{ tier = "A", itemID = 0, notes = "" },
		{ tier = "B", itemID = 0, notes = "" },
	},
}
