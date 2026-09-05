-- Data/DeathKnight/talents-method.lua
-- Blood talent data sourced from Method. Curated manually by the addon
-- owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- One build per context (raid/mythicPlus), since guide sites often
-- recommend different hero trees/talents depending on content type.
-- PvE-focused only for now -- no pvp context (see Shared/Sources.lua).

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.talents = Spectome.Data.DeathKnight.Blood.talents or {}

Spectome.Data.DeathKnight.Blood.talents.method = {
	source = "method",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "raid",
			heroTalent = "San'layn",
			loadoutString = "CoPAAAAAAAAAAAAAAAAAAAAAAwYWmZGmxMzMMbzMz0MbGzMmxAAAAAmZmZmZmZYGjBAjZmZGAAADMwMW0YZDklBsBYGzAAAmZghB",
			notes = "",
		},
		{
			context = "mythicPlus",
			heroTalent = "San'layn",
			loadoutString = "CoPAAAAAAAAAAAAAAAAAAAAAAwMzyMzMmxMzMMLzMz0MLGjxMGAAAAwMmZmZmZYGDAYmZmZGAAADMwMW0YZBklBsBYGzAAAmZghB",
			notes = "",
		},
	},
}
