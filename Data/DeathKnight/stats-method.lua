-- Data/DeathKnight/stats-method.lua
-- Blood stat priority data sourced from Method. Curated manually by the
-- addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- One build per context, split by hero talent tree (deathbringer/sanlayn)
-- rather than content type (raid/mythicPlus) -- stat priority is a
-- build-mechanics question tied to which hero tree is taken, not what
-- content the player is doing. `priority` is a simple ordered string;
-- `notes` is for caveats (soft caps, diminishing-returns thresholds,
-- situational swaps) -- here, why each stat behaves the way it does
-- (Crit->Parry conversion, Versatility's flat value, Haste's diminishing
-- returns, Mastery/Blood Shield's 65% cap), and why San'layn weighs Haste
-- above Crit/Vers/Mastery while Deathbringer doesn't (GCD/Essence of the
-- Blood Queen synergy).

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.stats = Spectome.Data.DeathKnight.Blood.stats or {}

Spectome.Data.DeathKnight.Blood.stats.method = {
	source = "method",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "deathbringer",
			priority = "Strength > Crit = Vers = Mastery > Haste",
			notes = "Crit converts 1:1 to Parry, which scales defensively with more parryable attacks. Versatility is the most expensive stat but has flat, consistent value. Haste has diminishing returns past a certain point and mainly helps Blood Boil/Carnage cooldowns and Rune generation. Mastery scales with Blood Shield but is capped at 65% (extendable via Bloody Reflection) and less effective when tanking harder content.",
		},
		{
			context = "sanlayn",
			priority = "Strength > Haste > Crit = Vers = Mastery",
			notes = "Same stat mechanics as Deathbringer (Crit->Parry conversion, Versatility's flat value, Haste's diminishing returns, Mastery/Blood Shield scaling and its 65% cap) -- San'layn just weighs Haste higher due to its GCD/Essence of the Blood Queen synergy.",
		},
	},
}
