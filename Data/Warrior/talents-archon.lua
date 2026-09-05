-- Data/Warrior/talents-archon.lua
-- Arms talent data sourced from Archon. Curated manually by the addon
-- owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- One build per context (raid/mythicPlus) -- unlike Icy Veins/Wowhead,
-- Archon doesn't split Arms raid talents further by target count for this
-- spec, so this stays the usual two-context shape.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Warrior = Spectome.Data.Warrior or {}
Spectome.Data.Warrior.Arms = Spectome.Data.Warrior.Arms or {}
Spectome.Data.Warrior.Arms.talents = Spectome.Data.Warrior.Arms.talents or {}

Spectome.Data.Warrior.Arms.talents.archon = {
	source = "archon",
	class = "Warrior",
	spec = "Arms",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "raid",
			heroTalent = "Slayer",
			loadoutString = "CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMzYmZGAAAghphZGzMWmZmZGMmZAAAAAMzyMDMhxy2ALgBMDTgZwGYmhx2ALzsNAzMAYGGA",
			notes = "",
		},
		{
			context = "mythicPlus",
			heroTalent = "Slayer",
			loadoutString = "CcEAAAAAAAAAAAAAAAAAAAAAAgZmZmFzYmZGAAAghphZGzMbmZmZGmxMDAAAAgxyMDMhxy2ALgBMDTgZwGYmhhBzyMbDwMDAmhBA",
			notes = "",
		},
	},
}
