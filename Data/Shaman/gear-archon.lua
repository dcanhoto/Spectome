-- Data/Shaman/gear-archon.lua
-- Restoration gear data sourced from Archon. Curated manually by the addon
-- owner (see SPECTOME_GUIDELINES.md "Data policy").
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

Spectome.Data.Shaman.Restoration.gear.archon = {
	source = "archon",
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
				{ slot = "Back", itemID = 251132, useCatalyst = false, obtainedFrom = "Murder Row (dungeon)", notes = "" },
				{ slot = "Chest", itemID = 158355, useCatalyst = true, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Wrist", itemID = 244584, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Hands", itemID = 251165, useCatalyst = true, obtainedFrom = "The Blinding Vale (dungeon)", notes = "" },
				{ slot = "Waist", itemID = 268216, useCatalyst = false, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Legs", itemID = 159375, useCatalyst = true, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Feet", itemID = 251125, useCatalyst = false, obtainedFrom = "Murder Row (dungeon)", notes = "" },
				{ slot = "Ring 1", itemID = 273792, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 251148, useCatalyst = false, obtainedFrom = "Den of Nalorakk (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 270162, useCatalyst = false, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Trinket 2", itemID = 270164, useCatalyst = false, obtainedFrom = "Lost Explorers", notes = "" },
				{ slot = "Main Hand", itemID = 271092, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Off Hand", itemID = 237831, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
			},
		},
		{
			context = "mythicPlus",
			items = {
				{ slot = "Head", itemID = 268230, useCatalyst = true, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Neck", itemID = 273781, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Shoulder", itemID = 268231, useCatalyst = true, obtainedFrom = "The Coiled Altar (raid)", notes = "" },
				{ slot = "Back", itemID = 193763, useCatalyst = false, obtainedFrom = "Ko'kia Blazehoof, Ruby Life Pools (dungeon)", notes = "" },
				{ slot = "Chest", itemID = 158355, useCatalyst = true, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Wrist", itemID = 244584, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Hands", itemID = 251165, useCatalyst = true, obtainedFrom = "The Blinding Vale (dungeon)", notes = "" },
				{ slot = "Waist", itemID = 159369, useCatalyst = false, obtainedFrom = "The Golden Serpent, King's Rest (dungeon)", notes = "" },
				{ slot = "Legs", itemID = 159375, useCatalyst = true, obtainedFrom = "Temple of Sethraliss (dungeon)", notes = "" },
				{ slot = "Feet", itemID = 251125, useCatalyst = false, obtainedFrom = "Murder Row (dungeon)", notes = "" },
				{ slot = "Ring 1", itemID = 273792, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 251148, useCatalyst = false, obtainedFrom = "Den of Nalorakk (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 250215, useCatalyst = false, obtainedFrom = "Murder Row (dungeon)", notes = "" },
				{ slot = "Trinket 2", itemID = 270162, useCatalyst = false, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Main Hand", itemID = 273778, useCatalyst = false, obtainedFrom = "Zul'jan, Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Off Hand", itemID = 237831, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
			},
		},
	},
}
