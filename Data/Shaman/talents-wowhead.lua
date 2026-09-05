-- Data/Shaman/talents-wowhead.lua
-- Restoration talent data sourced from Wowhead. Curated manually by the
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

Spectome.Data.Shaman.Restoration.talents.wowhead = {
	source = "wowhead",
	class = "Shaman",
	spec = "Restoration",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "raid",
			heroTalent = "Totemic",
			loadoutString = "CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsssNjZGjZGzMDjFYDmxmGbDIzAbmhZw2YMTz2yMzmZMLsYegZGzwsMAAAwMzgZGAYwM",
			notes = "",
		},
		{
			context = "mythicPlus",
			heroTalent = "Totemic",
			loadoutString = "CgQAAAAAAAAAAAAAAAAAAAAAAAAAAgBAAAAzMzsstMzMzMjZGjZgFYDmxmGbDIzAbMzMY2mZMa2WmZ2MjZhFjZGDLzyAAAAzMDmZAgBzA",
			notes = "",
		},
	},
}
