-- Data/Warrior/gear-method.lua
-- Arms gear data sourced from Method. Placeholder scaffold -- not yet
-- filled in (see SPECTOME_GUIDELINES.md "Data policy").
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

Spectome.Data.Warrior.Arms.gear.method = {
	source = "method",
	class = "Warrior",
	spec = "Arms",
	lastUpdated = "",
	builds = {
		{
			context = "overall",
			items = {
				{ slot = "Head", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Neck", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Shoulder", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Back", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Chest", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Wrist", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Hands", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Waist", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Legs", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Feet", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Ring 1", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Ring 2", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Trinket 1", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Trinket 2", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Weapon", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
			},
		},
		{
			context = "mythicPlus",
			items = {
				{ slot = "Head", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Neck", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Shoulder", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Back", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Chest", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Wrist", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Hands", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Waist", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Legs", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Feet", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Ring 1", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Ring 2", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Trinket 1", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Trinket 2", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Weapon", itemID = 0, useCatalyst = false, obtainedFrom = "", notes = "" },
			},
		},
	},
}
