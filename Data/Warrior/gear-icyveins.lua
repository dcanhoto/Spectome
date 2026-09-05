-- Data/Warrior/gear-icyveins.lua
-- Arms gear data sourced from Icy Veins. Curated manually by the addon
-- owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- One build per context (overall/mythicPlus), each a fixed 15-slot list.
-- itemID = 0 is the "no data yet" placeholder -- 0 is never a valid item
-- id, so the UI can detect and skip/gray it out without querying it.
-- useCatalyst flags an item meant to be catalyzed into a tier set piece.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Warrior = Spectome.Data.Warrior or {}
Spectome.Data.Warrior.Arms = Spectome.Data.Warrior.Arms or {}
Spectome.Data.Warrior.Arms.gear = Spectome.Data.Warrior.Arms.gear or {}

Spectome.Data.Warrior.Arms.gear.icyveins = {
	source = "icyveins",
	class = "Warrior",
	spec = "Arms",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "overall",
			items = {
				{ slot = "Head", itemID = 268229, useCatalyst = true, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Neck", itemID = 268265, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Shoulder", itemID = 271444, useCatalyst = false, obtainedFrom = "BoE trash drop, Venomous Abyss (raid)", notes = "" },
				{ slot = "Back", itemID = 268253, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Chest", itemID = 268222, useCatalyst = true, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Wrist", itemID = 237834, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Hands", itemID = 271457, useCatalyst = false, obtainedFrom = "Entombed Sentinels, Venomous Abyss (raid)", notes = "" },
				{ slot = "Waist", itemID = 268259, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Legs", itemID = 271878, useCatalyst = true, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Feet", itemID = 237828, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Ring 1", itemID = 252258, useCatalyst = false, obtainedFrom = "Voidscar Arena (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 273792, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 270173, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Trinket 2", itemID = 270175, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Weapon", itemID = 268213, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
			},
		},
		{
			context = "mythicPlus",
			items = {
				{ slot = "Head", itemID = 251229, useCatalyst = true, obtainedFrom = "Atroxus, Voidscar Arena (dungeon)", notes = "" },
				{ slot = "Neck", itemID = 273781, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Shoulder", itemID = 239037, useCatalyst = true, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Back", itemID = 193763, useCatalyst = false, obtainedFrom = "Ko'kia Blazehoof, Ruby Life Pools (dungeon)", notes = "" },
				{ slot = "Chest", itemID = 251151, useCatalyst = true, obtainedFrom = "Sentinel of Winter, Den of Nalorakk (dungeon)", notes = "" },
				{ slot = "Wrist", itemID = 237834, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Hands", itemID = 251214, useCatalyst = true, obtainedFrom = "Nalorakk, Den of Nalorakk (dungeon)", notes = "" },
				{ slot = "Waist", itemID = 159418, useCatalyst = false, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Legs", itemID = 273776, useCatalyst = true, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Feet", itemID = 237828, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Ring 1", itemID = 251136, useCatalyst = false, obtainedFrom = "Murder Row (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 273792, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 273796, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Trinket 2", itemID = 250229, useCatalyst = false, obtainedFrom = "Den of Nalorakk (dungeon)", notes = "" },
				{ slot = "Weapon", itemID = 273782, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
			},
		},
	},
}
