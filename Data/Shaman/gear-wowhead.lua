-- Data/Shaman/gear-wowhead.lua
-- Restoration gear data sourced from Wowhead. Curated manually by the
-- addon owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- One build per context (overall/mythicPlus), ending in Main Hand + Off
-- Hand instead of a single Weapon slot -- see Data/Shaman/gear-icyveins.lua
-- for why that's a plain data difference, not something the rendering code
-- needs to special-case. itemID = 0 is the "no data yet" placeholder -- 0
-- is never a valid item id, so the UI can detect and skip/gray it out
-- without querying it. useCatalyst flags an item meant to be catalyzed
-- into a tier set piece.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Shaman = Spectome.Data.Shaman or {}
Spectome.Data.Shaman.Restoration = Spectome.Data.Shaman.Restoration or {}
Spectome.Data.Shaman.Restoration.gear = Spectome.Data.Shaman.Restoration.gear or {}

Spectome.Data.Shaman.Restoration.gear.wowhead = {
	source = "wowhead",
	class = "Shaman",
	spec = "Restoration",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "overall",
			items = {
				{ slot = "Head", itemID = 268230, useCatalyst = true, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Neck", itemID = 268265, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Shoulder", itemID = 268231, useCatalyst = true, obtainedFrom = "The Coiled Altar (raid)", notes = "" },
				{ slot = "Back", itemID = 268248, useCatalyst = false, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Chest", itemID = 158355, useCatalyst = true, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Wrist", itemID = 159380, useCatalyst = false, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Hands", itemID = 251165, useCatalyst = true, obtainedFrom = "The Blinding Vale (dungeon)", notes = "" },
				{ slot = "Waist", itemID = 268216, useCatalyst = false, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Legs", itemID = 159375, useCatalyst = true, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Feet", itemID = 251125, useCatalyst = false, obtainedFrom = "Murder Row (dungeon)", notes = "" },
				{ slot = "Ring 1", itemID = 268252, useCatalyst = false, obtainedFrom = "Sszorak, Venomous Abyss (raid)", notes = "" },
				{ slot = "Ring 2", itemID = 251148, useCatalyst = false, obtainedFrom = "Den of Nalorakk (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 270162, useCatalyst = false, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Trinket 2", itemID = 270167, useCatalyst = false, obtainedFrom = "Nymrissa Wavebinder, Venomous Abyss (raid)", notes = "" },
				{ slot = "Main Hand", itemID = 271092, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Off Hand", itemID = 268196, useCatalyst = false, obtainedFrom = "Lost Explorers, Venomous Abyss (raid)", notes = "" },
			},
		},
		{
			context = "mythicPlus",
			items = {
				{ slot = "Head", itemID = 268230, useCatalyst = true, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Neck", itemID = 268265, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Shoulder", itemID = 268231, useCatalyst = true, obtainedFrom = "The Coiled Altar (raid)", notes = "" },
				{ slot = "Back", itemID = 268248, useCatalyst = false, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Chest", itemID = 158355, useCatalyst = true, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Wrist", itemID = 159380, useCatalyst = false, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Hands", itemID = 251165, useCatalyst = true, obtainedFrom = "The Blinding Vale (dungeon)", notes = "" },
				{ slot = "Waist", itemID = 268216, useCatalyst = false, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Legs", itemID = 159375, useCatalyst = true, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Feet", itemID = 251125, useCatalyst = false, obtainedFrom = "Murder Row (dungeon)", notes = "" },
				{ slot = "Ring 1", itemID = 273792, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 251148, useCatalyst = false, obtainedFrom = "Den of Nalorakk (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 193757, useCatalyst = false, obtainedFrom = "Ruby Life Pools (dungeon)", notes = "When trained" },
				{ slot = "Trinket 2", itemID = 250215, useCatalyst = false, obtainedFrom = "Murder Row (dungeon)", notes = "" },
				{ slot = "Main Hand", itemID = 271092, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Off Hand", itemID = 268196, useCatalyst = false, obtainedFrom = "Lost Explorers, Venomous Abyss (raid)", notes = "" },
			},
		},
	},
}
