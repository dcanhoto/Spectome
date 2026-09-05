-- Data/DeathKnight/gear-archon.lua
-- Blood gear data sourced from Archon. Curated manually by the addon
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

Spectome.Data.DeathKnight.Blood.gear.archon = {
	source = "archon",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "overall",
			items = {
				{ slot = "Head", itemID = 239050, useCatalyst = true, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Neck", itemID = 273781, useCatalyst = false, obtainedFrom = "The Writhing Coil", notes = "" },
				{ slot = "Shoulder", itemID = 239037, useCatalyst = true, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Back", itemID = 193763, useCatalyst = false, obtainedFrom = "Ko'kia Blazehoof, Ruby Life Pools (dungeon)", notes = "" },
				{ slot = "Chest", itemID = 268222, useCatalyst = true, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Wrist", itemID = 237834, useCatalyst = false, obtainedFrom = "Crafted", notes = "Versatility and Haste, Arcanoweave Lining" },
				{ slot = "Hands", itemID = 271475, useCatalyst = false, obtainedFrom = "Entombed Sentinels, Venomous Abyss (raid)", notes = "" },
				{ slot = "Waist", itemID = 159418, useCatalyst = false, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Legs", itemID = 271878, useCatalyst = true, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Feet", itemID = 273777, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Ring 1", itemID = 273792, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 252258, useCatalyst = false, obtainedFrom = "Voidscar Arena (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 270173, useCatalyst = false, obtainedFrom = "Coiled Altar, Venomous Abyss (raid)", notes = "" },
				{ slot = "Trinket 2", itemID = 270175, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Weapon", itemID = 237846, useCatalyst = false, obtainedFrom = "Crafted", notes = "Popularity-based pick, not necessarily strongest option -- Archon shows split adoption across weapon choices" },
			},
		},
		{
			context = "mythicPlus",
			items = {
				{ slot = "Head", itemID = 239050, useCatalyst = true, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Neck", itemID = 251173, useCatalyst = false, obtainedFrom = "Den of Nalorakk (dungeon)", notes = "" },
				{ slot = "Shoulder", itemID = 239037, useCatalyst = true, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Back", itemID = 193763, useCatalyst = false, obtainedFrom = "Ko'kia Blazehoof, Ruby Life Pools (dungeon)", notes = "" },
				{ slot = "Chest", itemID = 239036, useCatalyst = true, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Wrist", itemID = 237834, useCatalyst = false, obtainedFrom = "Crafted", notes = "Versatility and Haste, Arcanoweave Lining" },
				{ slot = "Hands", itemID = 271475, useCatalyst = false, obtainedFrom = "Entombed Sentinels, Venomous Abyss (raid)", notes = "" },
				{ slot = "Waist", itemID = 251144, useCatalyst = false, obtainedFrom = "", notes = "" },
				{ slot = "Legs", itemID = 273776, useCatalyst = true, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Feet", itemID = 273777, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Ring 1", itemID = 273792, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 252258, useCatalyst = false, obtainedFrom = "Voidscar Arena (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 249343, useCatalyst = false, obtainedFrom = "", notes = "Low popularity pick (4.8%), per Archon" },
				{ slot = "Trinket 2", itemID = 249344, useCatalyst = false, obtainedFrom = "", notes = "Low popularity pick (4.8%), per Archon" },
				{ slot = "Weapon", itemID = 237846, useCatalyst = false, obtainedFrom = "Crafted", notes = "Thalassian Missive of the Aurora" },
			},
		},
	},
}
