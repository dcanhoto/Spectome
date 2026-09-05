-- Data/Warrior/talents-archon.lua
-- Arms talent data sourced from Archon. Placeholder scaffold -- not
-- yet filled in (see SPECTOME_GUIDELINES.md "Data policy").
--
-- One build per context (raid/mythicPlus), since guide sites often
-- recommend different hero trees/talents depending on content type.
-- PvE-focused only for now -- no pvp context (see Shared/Sources.lua).

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Warrior = Spectome.Data.Warrior or {}
Spectome.Data.Warrior.Arms = Spectome.Data.Warrior.Arms or {}
Spectome.Data.Warrior.Arms.talents = Spectome.Data.Warrior.Arms.talents or {}

Spectome.Data.Warrior.Arms.talents.archon = {
	source = "archon",
	class = "Warrior",
	spec = "Arms",
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
