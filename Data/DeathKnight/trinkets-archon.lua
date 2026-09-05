-- Data/DeathKnight/trinkets-archon.lua
-- Blood trinket tier list sourced from Archon. Curated manually by the
-- addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Flat list, not split by context (unlike Data/DeathKnight/gear-*.lua's
-- Overall/Mythic+ builds) -- ranked S down through B. itemID = 0 is the
-- same "no data yet" placeholder convention as BiS gear.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.trinkets = Spectome.Data.DeathKnight.Blood.trinkets or {}

Spectome.Data.DeathKnight.Blood.trinkets.archon = {
	source = "archon",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	trinkets = {
		{ tier = "S", itemID = 270175, notes = "Archon BiS pick" }, -- Voracious Heart of Ula'tek
		{ tier = "S", itemID = 270173, notes = "Archon BiS pick" }, -- Zul'jin's Guillotine Technique
		{ tier = "A", itemID = 250245, notes = "" }, -- Tumor of the Swarm
		{ tier = "A", itemID = 250228, notes = "" }, -- Resonant Bellowstone
		{ tier = "A", itemID = 249344, notes = "" }, -- Light Company Guidon
		{ tier = "A", itemID = 273796, notes = "" }, -- Vile Vial of Volatile Venom
		{ tier = "A", itemID = 250229, notes = "" }, -- Idol of the War Loa
		{ tier = "A", itemID = 249343, notes = "" }, -- Gaze of the Alnseer
		{ tier = "A", itemID = 270165, notes = "" }, -- Keeper's Seething Core
		{ tier = "B", itemID = 250259, notes = "" }, -- Sapling of the Dawnroot
		{ tier = "B", itemID = 193762, notes = "" }, -- Blazebinder's Hoof
		{ tier = "B", itemID = 250238, notes = "" }, -- Seed of the Devouring Wild
		{ tier = "B", itemID = 274493, notes = "" }, -- Effigy of Ula'tek's Faithful
		{ tier = "B", itemID = 273797, notes = "" }, -- Tattered Amani War Banner
		{ tier = "B", itemID = 273795, notes = "" }, -- Coiled Fangstone
	},
}
