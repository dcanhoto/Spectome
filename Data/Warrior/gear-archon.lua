-- Data/Warrior/gear-archon.lua
-- Arms gear data sourced from Archon. Curated manually by the addon owner
-- (see SPECTOME_GUIDELINES.md "Data policy").
--
-- One build per context (overall/mythicPlus), each a fixed 15-slot list.
-- itemID = 0 is the "no data yet" placeholder -- 0 is never a valid item
-- id, so the UI can detect and skip/gray it out without querying it.
-- useCatalyst flags an item meant to be catalyzed into a tier set piece --
-- unlike Icy Veins/Wowhead, Archon shows equipped tier pieces directly
-- rather than the catalyst-from base item, so no slot here is flagged
-- useCatalyst = true even though several are the same tier-set items.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Warrior = Spectome.Data.Warrior or {}
Spectome.Data.Warrior.Arms = Spectome.Data.Warrior.Arms or {}
Spectome.Data.Warrior.Arms.gear = Spectome.Data.Warrior.Arms.gear or {}

Spectome.Data.Warrior.Arms.gear.archon = {
	source = "archon",
	class = "Warrior",
	spec = "Arms",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "overall",
			items = {
				{ slot = "Head", itemID = 271456, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Neck", itemID = 268265, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Shoulder", itemID = 271454, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Back", itemID = 193763, useCatalyst = false, obtainedFrom = "Ko'kia Blazehoof, Ruby Life Pools (dungeon)", notes = "" },
				{ slot = "Chest", itemID = 271459, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Wrist", itemID = 237834, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Hands", itemID = 271457, useCatalyst = false, obtainedFrom = "Entombed Sentinels, Venomous Abyss (raid)", notes = "" },
				{ slot = "Waist", itemID = 268259, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Legs", itemID = 271455, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Feet", itemID = 237828, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Ring 1", itemID = 273792, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 252258, useCatalyst = false, obtainedFrom = "Voidscar Arena (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 270173, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Trinket 2", itemID = 270175, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Weapon", itemID = 268213, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
			},
		},
		{
			context = "mythicPlus",
			items = {
				{ slot = "Head", itemID = 271456, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Neck", itemID = 273781, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Shoulder", itemID = 271454, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Back", itemID = 193763, useCatalyst = false, obtainedFrom = "Ko'kia Blazehoof, Ruby Life Pools (dungeon)", notes = "" },
				{ slot = "Chest", itemID = 271459, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Wrist", itemID = 237834, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Hands", itemID = 271457, useCatalyst = false, obtainedFrom = "Entombed Sentinels, Venomous Abyss (raid)", notes = "" },
				{ slot = "Waist", itemID = 159418, useCatalyst = false, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Legs", itemID = 271455, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Feet", itemID = 237828, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Ring 1", itemID = 273792, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 252258, useCatalyst = false, obtainedFrom = "Voidscar Arena (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 249342, useCatalyst = false, obtainedFrom = "Vorasius, The Voidspire (raid)", notes = "Low popularity pick (4.9%), per Archon" },
				{ slot = "Trinket 2", itemID = 249343, useCatalyst = false, obtainedFrom = "", notes = "Low popularity pick (4.9%), per Archon" },
				{ slot = "Weapon", itemID = 237846, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
			},
		},
	},
}
