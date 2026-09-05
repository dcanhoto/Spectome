-- Data/Shaman/talents-wowhead.lua
-- Restoration talent data sourced from Wowhead. Placeholder scaffold -- not
-- yet filled in (see SPECTOME_GUIDELINES.md "Data policy").
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
	lastUpdated = "",
	builds = {
		{
			context = "raid",
			heroTalent = "",
			loadoutString = "",
			notes = "",
		},
		{
			context = "mythicPlus",
			heroTalent = "",
			loadoutString = "",
			notes = "",
		},
	},
}
