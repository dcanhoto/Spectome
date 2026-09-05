-- Data/Warrior/talents-wowhead.lua
-- Arms talent data sourced from Wowhead. Curated manually by the addon
-- owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Wowhead splits Arms raid talents further by target count, same as Icy
-- Veins' data for this spec -- three builds
-- (singleTargetRaid/multiTargetRaid/mythicPlus) instead of the usual two
-- (raid/mythicPlus). See Data/Warrior/talents-icyveins.lua and
-- Sections/Talents.lua's dynamic context switcher for why this doesn't
-- need any other source or class/spec to match this shape.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Warrior = Spectome.Data.Warrior or {}
Spectome.Data.Warrior.Arms = Spectome.Data.Warrior.Arms or {}
Spectome.Data.Warrior.Arms.talents = Spectome.Data.Warrior.Arms.talents or {}

Spectome.Data.Warrior.Arms.talents.wowhead = {
	source = "wowhead",
	class = "Warrior",
	spec = "Arms",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "singleTargetRaid",
			heroTalent = "Slayer",
			loadoutString = "CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMzMmZGAAAghphxYmxyMzMzgxMDAAAAgZWmZAhxyyALgBMDTIzgNwMjtx2ALzsMAzMAYGGA",
			notes = "",
		},
		{
			context = "multiTargetRaid",
			heroTalent = "Slayer",
			loadoutString = "CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMzYmZGAAAghphxYmxyMzMzgxMDAAAAgZWmZgJMW2GYBMgZYCZGsBmZsN2GYZmtBYmBAzwA",
			notes = "",
		},
		{
			context = "mythicPlus",
			heroTalent = "Slayer",
			loadoutString = "CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphxYmZzMzMzYmxMDAAAAgxyMDMhxy2AbgBMDTIzgNwMDDDmlZ2GgZGAMDDA",
			notes = "",
		},
	},
}
