-- Data/DeathKnight/trinkets-wowhead.lua
-- Blood trinket tier list sourced from Wowhead. Curated manually by the
-- addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Flat list, not split by context (unlike Data/DeathKnight/gear-*.lua's
-- Overall/Mythic+ builds) -- ranked S down through D. itemID = 0 is the
-- same "no data yet" placeholder convention as BiS gear.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.trinkets = Spectome.Data.DeathKnight.Blood.trinkets or {}

Spectome.Data.DeathKnight.Blood.trinkets.wowhead = {
	source = "wowhead",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	trinkets = {
		{ tier = "S", itemID = 270173, notes = "" }, -- Zul'jin's Guillotine Technique
		{ tier = "S", itemID = 270175, notes = "" }, -- Voracious Heart of Ula'tek
		{ tier = "A", itemID = 270165, notes = "" }, -- Keeper's Seething Core
		{ tier = "A", itemID = 273796, notes = "" }, -- Vile Vial of Volatile Venom
		{ tier = "A", itemID = 250238, notes = "" }, -- Seed of the Devouring Wild
		{ tier = "A", itemID = 250259, notes = "" }, -- Sapling of the Dawnroot
		{ tier = "A", itemID = 193762, notes = "" }, -- Blazebinder's Hoof
		{ tier = "A", itemID = 273797, notes = "" }, -- Tattered Amani War Banner
		{ tier = "A", itemID = 270164, notes = "" }, -- Gebbo's Bottomless Bag
		{ tier = "A", itemID = 274493, notes = "" }, -- Effigy of Ula'tek's Faithful
		{ tier = "A", itemID = 158367, notes = "" }, -- Merektha's Fang
		{ tier = "B", itemID = 250245, notes = "" }, -- Tumor of the Swarm
		{ tier = "B", itemID = 270168, notes = "" }, -- Font of Venomous Rage
		{ tier = "B", itemID = 270163, notes = "" }, -- Sszorak's Ferocity
		{ tier = "B", itemID = 251783, notes = "" }, -- Lost Idol of the Hash'ey
		{ tier = "B", itemID = 250228, notes = "" }, -- Resonant Bellowstone
		{ tier = "C", itemID = 273795, notes = "" }, -- Coiled Fangstone
		{ tier = "C", itemID = 250229, notes = "" }, -- Idol of the War Loa
		{ tier = "D", itemID = 250244, notes = "" }, -- Permafrost Essence
	},
}
