-- Data/DeathKnight/gear-method.lua
-- Blood gear data sourced from Method. Curated manually by the addon
-- owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- One build per context (overall/mythicPlus), each a fixed 15-slot list.
-- itemID = 0 is the "no data yet" placeholder -- 0 is never a valid item
-- id, so the UI can detect and skip/gray it out without querying it.
-- useCatalyst flags an item meant to be catalyzed into a tier set piece.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.DeathKnight = Spectome.Data.DeathKnight or {}
Spectome.Data.DeathKnight.Blood = Spectome.Data.DeathKnight.Blood or {}
Spectome.Data.DeathKnight.Blood.gear = Spectome.Data.DeathKnight.Blood.gear or {}

Spectome.Data.DeathKnight.Blood.gear.method = {
	source = "method",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "overall",
			items = {
				{ slot = "Head", itemID = 251229, useCatalyst = true, obtainedFrom = "Atroxus, Voidscar Arena (dungeon)", notes = "" },
				{ slot = "Neck", itemID = 268265, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Shoulder", itemID = 239051, useCatalyst = false, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Back", itemID = 251190, useCatalyst = false, obtainedFrom = "The Blinding Vale (dungeon)", notes = "" },
				{ slot = "Chest", itemID = 268222, useCatalyst = true, obtainedFrom = "The Coiled Altar (raid)", notes = "" },
				{ slot = "Wrist", itemID = 237834, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Hands", itemID = 251221, useCatalyst = true, obtainedFrom = "Voidscar Arena (dungeon)", notes = "" },
				{ slot = "Waist", itemID = 268259, useCatalyst = false, obtainedFrom = "The Coiled Altar (raid)", notes = "" },
				{ slot = "Legs", itemID = 271878, useCatalyst = true, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Feet", itemID = 159412, useCatalyst = false, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Ring 1", itemID = 268249, useCatalyst = false, obtainedFrom = "Vashnik the Malignant, Venomous Abyss (raid)", notes = "" },
				{ slot = "Ring 2", itemID = 240949, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Trinket 1", itemID = 270175, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Trinket 2", itemID = 270173, useCatalyst = false, obtainedFrom = "The Coiled Altar (raid)", notes = "" },
				{ slot = "Weapon", itemID = 268213, useCatalyst = false, obtainedFrom = "The Coiled Altar (raid)", notes = "" },
			},
		},
		{
			context = "mythicPlus",
			items = {
				{ slot = "Head", itemID = 268229, useCatalyst = true, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Neck", itemID = 268265, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Shoulder", itemID = 239037, useCatalyst = false, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Back", itemID = 251190, useCatalyst = false, obtainedFrom = "The Blinding Vale (dungeon)", notes = "" },
				{ slot = "Chest", itemID = 268222, useCatalyst = true, obtainedFrom = "The Coiled Altar (raid)", notes = "" },
				{ slot = "Wrist", itemID = 251133, useCatalyst = false, obtainedFrom = "Zaen Bladesorrow, Murder Row (dungeon)", notes = "" },
				{ slot = "Hands", itemID = 251214, useCatalyst = true, obtainedFrom = "Nalorakk, Den of Nalorakk (dungeon)", notes = "" },
				{ slot = "Waist", itemID = 268259, useCatalyst = false, obtainedFrom = "The Coiled Altar (raid)", notes = "" },
				{ slot = "Legs", itemID = 271878, useCatalyst = true, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Feet", itemID = 237828, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Ring 1", itemID = 268252, useCatalyst = false, obtainedFrom = "Sszorak, Venomous Abyss (raid)", notes = "" },
				{ slot = "Ring 2", itemID = 240949, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Trinket 1", itemID = 270175, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Trinket 2", itemID = 270173, useCatalyst = false, obtainedFrom = "The Coiled Altar (raid)", notes = "" },
				{ slot = "Weapon", itemID = 268213, useCatalyst = false, obtainedFrom = "The Coiled Altar (raid)", notes = "" },
			},
		},
	},
}
