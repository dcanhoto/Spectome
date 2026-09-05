-- Data/Warrior/talents-icyveins.lua
-- Arms talent data sourced from Icy Veins. Curated manually by the addon
-- owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Icy Veins splits Arms raid talents further by target count, so this
-- source has three builds (singleTargetRaid/multiTargetRaid/mythicPlus)
-- instead of the usual two (raid/mythicPlus) -- Sections/Talents.lua's
-- context switcher is built dynamically from whatever contexts a source's
-- builds actually contain, so this doesn't need any other source (or any
-- other class's data) to match this shape.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Warrior = Spectome.Data.Warrior or {}
Spectome.Data.Warrior.Arms = Spectome.Data.Warrior.Arms or {}
Spectome.Data.Warrior.Arms.talents = Spectome.Data.Warrior.Arms.talents or {}

Spectome.Data.Warrior.Arms.talents.icyveins = {
	source = "icyveins",
	class = "Warrior",
	spec = "Arms",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "singleTargetRaid",
			heroTalent = "Slayer",
			loadoutString = "CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMzMmZGAAAghphxYmZzMzMzgxMDAAAAgZWmZAhxyyALgBMDTgZwGYmx2YbglZWGgZGAMDDA",
			notes = "",
		},
		{
			context = "multiTargetRaid",
			heroTalent = "Slayer",
			loadoutString = "CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMzYmZGAAAghphxYmxyMzMzgxMDAAAAgZWmZgJMW2GYBMgZYCMD2AzM2GbDsMz2AMzAgZYA",
			notes = "",
		},
		{
			context = "mythicPlus",
			heroTalent = "Slayer",
			loadoutString = "CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphxYmZzMzMzYmxMDAAAAgxyMDMhxy2ALgBMDTgZwGYmhhBzyMbDwMDAmhBA",
			notes = "",
		},
	},
}
