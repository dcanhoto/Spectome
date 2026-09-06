-- Data/DeathKnight/stats-archon.lua
-- Blood stat priority data sourced from Archon. Curated manually by the
-- addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- One build per context, split by hero talent tree (sanlayn/deathbringer)
-- rather than content type (raid/mythicPlus) -- stat priority is a
-- build-mechanics question tied to which hero tree is taken, not what
-- content the player is doing. Unlike Icy Veins/Wowhead, Archon's data is
-- population-based (parses/logs) rather than theorycrafted per hero tree,
-- so it only publishes one number reflecting San'layn (the dominant tree
-- by pick rate) -- deathbringer's `priority` is intentionally left empty
-- here, with `notes` explaining why, rather than inventing a number Archon
-- doesn't actually provide.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.stats = Spectome.Data.DeathKnight.Blood.stats or {}

Spectome.Data.DeathKnight.Blood.stats.archon = {
	source = "archon",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "sanlayn",
			priority = "Strength > Haste > Crit > Mastery > Versatility",
			notes = "Based on population data (last 2 weeks), consistent between Raid and Mythic+ -- reflects San'layn as the dominant hero tree rather than a distinct per-context breakdown. May carry some bias from gear availability.",
		},
		{
			context = "deathbringer",
			priority = "",
			notes = "Archon doesn't break this out separately -- its stat data reflects population-wide (San'layn-dominant) results only.",
		},
	},
}
