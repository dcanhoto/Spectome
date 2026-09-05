-- Data/Warrior/gear-wowhead.lua
-- Arms gear data sourced from Wowhead. Curated manually by the addon owner
-- (see SPECTOME_GUIDELINES.md "Data policy").
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

Spectome.Data.Warrior.Arms.gear.wowhead = {
	source = "wowhead",
	class = "Warrior",
	spec = "Arms",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "overall",
			items = {
				{ slot = "Head", itemID = 271456, useCatalyst = false, obtainedFrom = "The Twin Fangs, Venomous Abyss (raid)", notes = "" },
				{ slot = "Neck", itemID = 268265, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Shoulder", itemID = 271444, useCatalyst = true, obtainedFrom = "BoE trash drop, Venomous Abyss (raid)", notes = "" },
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
				{ slot = "Head", itemID = 271456, useCatalyst = false, obtainedFrom = "The Twin Fangs, Venomous Abyss (raid)", notes = "" },
				{ slot = "Neck", itemID = 268265, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Shoulder", itemID = 271444, useCatalyst = true, obtainedFrom = "BoE trash drop, Venomous Abyss (raid)", notes = "" },
				{ slot = "Back", itemID = 268253, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Chest", itemID = 268222, useCatalyst = true, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Wrist", itemID = 237834, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Hands", itemID = 271457, useCatalyst = false, obtainedFrom = "Entombed Sentinels, Venomous Abyss (raid)", notes = "" },
				{ slot = "Waist", itemID = 268259, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Legs", itemID = 271878, useCatalyst = true, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Feet", itemID = 237828, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Ring 1", itemID = 251136, useCatalyst = false, obtainedFrom = "Murder Row (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 273792, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 270173, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Trinket 2", itemID = 273796, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "Swapped in for Voracious Heart -- good to pair an on-use with a passive trinket" },
				{ slot = "Weapon", itemID = 273782, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
			},
		},
	},
}
