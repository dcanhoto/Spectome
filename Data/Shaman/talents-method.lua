-- Data/Shaman/talents-method.lua
-- Restoration talent data sourced from Method. Curated manually by the
-- addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- One build per context (raid/mythicPlus), since guide sites often
-- recommend different hero trees/talents depending on content type.
-- PvE-focused only for now -- no pvp context (see Shared/Sources.lua).

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Shaman = Spectome.Data.Shaman or {}
Spectome.Data.Shaman.Restoration = Spectome.Data.Shaman.Restoration or {}
Spectome.Data.Shaman.Restoration.talents = Spectome.Data.Shaman.Restoration.talents or {}

Spectome.Data.Shaman.Restoration.talents.method = {
	source = "method",
	class = "Shaman",
	spec = "Restoration",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "raid",
			heroTalent = "Totemic",
			loadoutString = "CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsssNjZGjZGzMMjFYDmxiGbDIzAbmBDWmZmRz2yMzmZMLsMzDMzYwsMAAAwMzgZGAYwM",
			notes = "",
		},
		{
			context = "mythicPlus",
			heroTalent = "Totemic",
			loadoutString = "CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsstMmZGjZmZMjZsAbwMW0YbAZGYjZMDz2MjRz2yMzmZMbsYMzYYZWmBAgBwMDmZAAYG",
			notes = "",
		},
	},
}
