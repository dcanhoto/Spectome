-- Data/Warrior/talents-method.lua
-- Arms talent data sourced from Method. Curated manually by the addon
-- owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- Method splits Arms raid talents further by target count, same as Icy
-- Veins/Wowhead's data for this spec -- three builds
-- (singleTargetRaid/multiTargetRaid/mythicPlus). Method's Mythic+ loadout
-- string carries an unusual extra prefix segment not seen in the other
-- three sources' strings for this spec -- that's exactly how Method
-- exported it, so it's kept verbatim rather than reformatted to match; the
-- import path (Shared/TalentImport.lua) reads and applies whatever
-- C_Traits/C_ClassTalents accepts, it doesn't validate string shape.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Warrior = Spectome.Data.Warrior or {}
Spectome.Data.Warrior.Arms = Spectome.Data.Warrior.Arms or {}
Spectome.Data.Warrior.Arms.talents = Spectome.Data.Warrior.Arms.talents or {}

Spectome.Data.Warrior.Arms.talents.method = {
	source = "method",
	class = "Warrior",
	spec = "Arms",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "singleTargetRaid",
			heroTalent = "Slayer",
			loadoutString = "CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMzMmZGAAAghphZGzMWmZmZGMmZAAAAAMzyMDIMWWGYBMgZYCZGsBmZYsNwyMLDwMDAmhBA",
			notes = "",
		},
		{
			context = "multiTargetRaid",
			heroTalent = "Slayer",
			loadoutString = "CcEAAAAAAAAAAAAAAAAAAAAAAAzMzsMz8AmZGAAAghphZGzMWmZmZGMmZAAAAAMWmZgJMWWGYBMgZYCZGsBmZYsNYWmZbAmZAwMMA",
			notes = "",
		},
		{
			context = "mythicPlus",
			heroTalent = "Slayer",
			loadoutString = "CcEASWsDSHNyPDXnbxuIhH3ZdjZmZmFzYmZGAAAghphZGzMWmZmZGMmZAAAAAMWmZgJMW2GYBMgZYCZGsBmZYsNYWmZbAmZAwMMA",
			notes = "",
		},
	},
}
