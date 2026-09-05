-- Data/DeathKnight/trinkets-method.lua
-- Blood trinket tier list sourced from Method. Curated manually by the
-- addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Flat list, not split by context (unlike Data/DeathKnight/gear-*.lua's
-- Overall/Mythic+ builds) -- ranked S down through A (no lower tiers listed
-- by Method for this spec). itemID = 0 is the same "no data yet"
-- placeholder convention as BiS gear.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.trinkets = Spectome.Data.DeathKnight.Blood.trinkets or {}

Spectome.Data.DeathKnight.Blood.trinkets.method = {
	source = "method",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	trinkets = {
		{ tier = "S", itemID = 270175, notes = "Particularly good for San'layn; macro with Dancing Rune Weapon to buff its cooldown window" },
		{ tier = "S", itemID = 270173, notes = "Very strong with Cantrip Raid Weapons; use a passive A-tier trinket instead if you lack one" },
		{ tier = "A", itemID = 250238, notes = "Good farmable alternative to Voracious Heart of Ula'tek" },
		{ tier = "A", itemID = 270164, notes = "Random secondary stats, not great for consistency but decent uptime" },
		{ tier = "A", itemID = 250245, notes = "Easy to farm, large damage with no extra effort" },
		{ tier = "A", itemID = 250259, notes = "Similar option to Tumor of the Swarm" },
		{ tier = "A", itemID = 250229, notes = "Good passive/defensive alternative, likely seen in Mythic+ instead of Gebbo's Bottomless Bag" },
	},
}
