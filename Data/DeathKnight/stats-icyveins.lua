-- Data/DeathKnight/stats-icyveins.lua
-- Blood stat priority data sourced from Icy Veins. Curated manually by the
-- addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- One build per context, split by hero talent tree (sanlayn/deathbringer)
-- rather than content type (raid/mythicPlus) -- stat priority is a
-- build-mechanics question tied to which hero tree is taken, not what
-- content the player is doing. `priority` is a simple ordered string;
-- `notes` explains why (San'layn's Haste value comes from Essence of the
-- Blood Queen/Gift of the San'layn scaling until a gear-dependent
-- threshold; Deathbringer avoids Haste entirely since nothing in its
-- toolkit is hasted, and favors Crit for Exterminate/Reaper's Mark uptime).

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.stats = Spectome.Data.DeathKnight.Blood.stats or {}

Spectome.Data.DeathKnight.Blood.stats.icyveins = {
	source = "icyveins",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "sanlayn",
			priority = "Strength > Haste > Crit > Mastery > Versatility",
			notes = "Prefers Haste up to ~30% unbuffed thanks to Essence of the Blood Queen and Gift of the San'layn (exact threshold depends on gear/trinkets/cantrips -- let sims balance it out). Mastery and Versatility are typically lowest value per point offensively.",
		},
		{
			context = "deathbringer",
			priority = "Strength > Crit > Mastery = Versatility > Haste",
			notes = "Avoids Haste (no interactions with it) and strongly favors Crit thanks to Exterminate and Reaper's Mark hitting every 30-45s depending on talents. Haste still has relatively good value compared to the others despite being deprioritized.",
		},
	},
}
