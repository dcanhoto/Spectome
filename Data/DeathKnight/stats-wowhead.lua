-- Data/DeathKnight/stats-wowhead.lua
-- Blood stat priority data sourced from Wowhead. Curated manually by the
-- addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- One build per context, split by hero talent tree (sanlayn/deathbringer)
-- rather than content type (raid/mythicPlus) -- stat priority is a
-- build-mechanics question tied to which hero tree is taken, not what
-- content the player is doing. `priority` is a simple ordered string;
-- `notes` explains why (San'layn gets a small Haste boost from Essence of
-- the Blood Queen's multiplicative scaling and Dancing Rune Weapon's GCD
-- count; Deathbringer eschews Haste since its toolkit centers on a
-- fixed-cooldown ability, Reaper's Mark).

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.stats = Spectome.Data.DeathKnight.Blood.stats or {}

Spectome.Data.DeathKnight.Blood.stats.wowhead = {
	source = "wowhead",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "sanlayn",
			priority = "Strength > Haste > Mastery/Crit/Vers (roughly equal)",
			notes = "Haste amplification comes from the multiplicative aspect of Essence of the Blood Queen and GCD count in Dancing Rune Weapon -- small but non-negligible. Priorities hold roughly the same in AoE. Simulate your own character with Raidbots Top Gear for precision.",
		},
		{
			context = "deathbringer",
			priority = "Strength > Crit > Mastery/Vers (roughly equal) > Haste",
			notes = "Deathbringer eschews Haste since none of its bonuses are hasted, and its toolkit centers on a fixed-cooldown ability (Reaper's Mark). Simulate your own character with Raidbots Top Gear for precision.",
		},
	},
}
