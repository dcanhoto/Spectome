-- Data/DeathKnight/trinkets-icyveins.lua
-- Blood trinket tier list sourced from Icy Veins. Curated manually by the
-- addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Flat list, not split by context (unlike Data/DeathKnight/gear-*.lua's
-- Overall/Mythic+ builds) -- ranked S down through C. itemID = 0 is the
-- same "no data yet" placeholder convention as BiS gear.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.trinkets = Spectome.Data.DeathKnight.Blood.trinkets or {}

Spectome.Data.DeathKnight.Blood.trinkets.icyveins = {
	source = "icyveins",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	trinkets = {
		{ tier = "S", itemID = 270175, notes = "" }, -- Voracious Heart of Ula'tek
		{ tier = "S", itemID = 158367, notes = "" }, -- Merektha's Fang
		{ tier = "A", itemID = 270165, notes = "" }, -- Keeper's Seething Core
		{ tier = "A", itemID = 270164, notes = "" }, -- Gebbo's Bottomless Bag
		{ tier = "A", itemID = 270173, notes = "" }, -- Zul'jin's Guillotine Technique
		{ tier = "A", itemID = 270163, notes = "Mythic+ only, per Icy Veins" }, -- Sszorak's Ferocity
		{ tier = "B", itemID = 274493, notes = "" }, -- Effigy of Ula'tek's Faithful
		{ tier = "B", itemID = 250245, notes = "" }, -- Tumor of the Swarm
		{ tier = "B", itemID = 250259, notes = "" }, -- Sapling of the Dawnroot
		{ tier = "B", itemID = 250238, notes = "" }, -- Seed of the Devouring Wild
		{ tier = "B", itemID = 273796, notes = "" }, -- Vile Vial of Volatile Venom
		{ tier = "B", itemID = 193757, notes = "When trained" }, -- Ruby Whelp Shell
		{ tier = "B", itemID = 250226, notes = "" }, -- Latch's Crooked Hook
	},
}
