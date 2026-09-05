-- Data/DeathKnight/gear-icyveins.lua
-- Blood gear data sourced from Icy Veins. Curated manually by the addon
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

Spectome.Data.DeathKnight.Blood.gear.icyveins = {
	source = "icyveins",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "overall",
			items = {
				{ slot = "Head", itemID = 239050, useCatalyst = true, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Neck", itemID = 268265, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Shoulder", itemID = 239037, useCatalyst = true, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Back", itemID = 268253, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Chest", itemID = 268222, useCatalyst = true, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Wrist", itemID = 237834, useCatalyst = false, obtainedFrom = "Crafted", notes = "Versatility and Haste, Arcanoweave Lining" },
				{ slot = "Hands", itemID = 271475, useCatalyst = false, obtainedFrom = "Entombed Sentinels, Venomous Abyss (raid)", notes = "" },
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
				{ slot = "Head", itemID = 239050, useCatalyst = true, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Neck", itemID = 251173, useCatalyst = false, obtainedFrom = "Den of Nalorakk (dungeon)", notes = "" },
				{ slot = "Shoulder", itemID = 239037, useCatalyst = true, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Back", itemID = 251190, useCatalyst = false, obtainedFrom = "Blinding Vale (dungeon)", notes = "" },
				{ slot = "Chest", itemID = 239036, useCatalyst = true, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Wrist", itemID = 159409, useCatalyst = false, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Hands", itemID = 251197, useCatalyst = false, obtainedFrom = "Blinding Vale (dungeon)", notes = "" },
				{ slot = "Waist", itemID = 159442, useCatalyst = false, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Legs", itemID = 273776, useCatalyst = true, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Feet", itemID = 273777, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Ring 1", itemID = 158366, useCatalyst = false, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 159459, useCatalyst = false, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 158367, useCatalyst = false, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Trinket 2", itemID = 250259, useCatalyst = false, obtainedFrom = "Blinding Vale (dungeon)", notes = "" },
				{ slot = "Weapon", itemID = 251181, useCatalyst = false, obtainedFrom = "Blinding Vale (dungeon)", notes = "" },
			},
		},
	},
}
