-- Data/DeathKnight/gear-wowhead.lua
-- Blood gear data sourced from Wowhead. Curated manually by the addon
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

Spectome.Data.DeathKnight.Blood.gear.wowhead = {
	source = "wowhead",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "overall",
			items = {
				{ slot = "Head", itemID = 268229, useCatalyst = true, obtainedFrom = "Nek'zali the Soulcoiler, Venomous Abyss (raid)", notes = "" },
				{ slot = "Neck", itemID = 268265, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Shoulder", itemID = 239037, useCatalyst = true, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Back", itemID = 268253, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Chest", itemID = 268222, useCatalyst = true, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Wrist", itemID = 237834, useCatalyst = false, obtainedFrom = "Crafted", notes = "Versatility and Haste, Arcanoweave Lining" },
				{ slot = "Hands", itemID = 159413, useCatalyst = true, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Waist", itemID = 268259, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Legs", itemID = 271878, useCatalyst = true, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Feet", itemID = 273777, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Ring 1", itemID = 159459, useCatalyst = false, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 240949, useCatalyst = false, obtainedFrom = "Crafted", notes = "Versatility and Haste, Prismatic Focusing Iris" },
				{ slot = "Trinket 1", itemID = 270175, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Trinket 2", itemID = 270173, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Weapon", itemID = 268213, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
			},
		},
		{
			context = "mythicPlus",
			items = {
				{ slot = "Head", itemID = 268229, useCatalyst = true, obtainedFrom = "Nek'zali the Soulcoiler, Venomous Abyss (raid)", notes = "" },
				{ slot = "Neck", itemID = 268265, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Shoulder", itemID = 239037, useCatalyst = true, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Back", itemID = 268253, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Chest", itemID = 268222, useCatalyst = true, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Wrist", itemID = 237834, useCatalyst = false, obtainedFrom = "Crafted", notes = "Versatility and Haste, Arcanoweave Lining" },
				{ slot = "Hands", itemID = 159413, useCatalyst = true, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Waist", itemID = 159418, useCatalyst = false, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Legs", itemID = 271878, useCatalyst = true, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Feet", itemID = 273777, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Ring 1", itemID = 159459, useCatalyst = false, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 162544, useCatalyst = false, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 270175, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Trinket 2", itemID = 270173, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Weapon", itemID = 251230, useCatalyst = false, obtainedFrom = "Voidscar Arena (dungeon)", notes = "Treat as temporary stand-in per Wowhead -- no standout M+ options this season" },
			},
		},
	},
}
