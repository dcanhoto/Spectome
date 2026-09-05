-- Data/Shaman/gear-method.lua
-- Restoration gear data sourced from Method. Curated manually by the addon
-- owner (see SPECTOME_GUIDELINES.md "Data policy").
--
-- One build per context (overall/mythicPlus), ending in Main Hand + Off
-- Hand instead of a single Weapon slot -- see Data/Shaman/gear-icyveins.lua
-- for why that's a plain data difference, not something the rendering code
-- needs to special-case. itemID = 0 is the "no data yet" placeholder -- 0
-- is never a valid item id, so the UI can detect and skip/gray it out
-- without querying it. useCatalyst flags an item meant to be catalyzed
-- into a tier set piece -- Method's Mythic+ build catalyzes nearly the
-- whole tier set (Head/Chest/Hands/Legs/Feet), each noted "Catalyst" in
-- obtainedFrom to match how Method itself labeled the acquisition path.

Spectome = Spectome or {}
Spectome.Data = Spectome.Data or {}
Spectome.Data.Shaman = Spectome.Data.Shaman or {}
Spectome.Data.Shaman.Restoration = Spectome.Data.Shaman.Restoration or {}
Spectome.Data.Shaman.Restoration.gear = Spectome.Data.Shaman.Restoration.gear or {}

Spectome.Data.Shaman.Restoration.gear.method = {
	source = "method",
	class = "Shaman",
	spec = "Restoration",
	lastUpdated = "2026-09-05",
	builds = {
		{
			context = "overall",
			items = {
				{ slot = "Head", itemID = 271483, useCatalyst = false, obtainedFrom = "The Twin Fangs, Venomous Abyss (raid)", notes = "" },
				{ slot = "Neck", itemID = 268265, useCatalyst = false, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Shoulder", itemID = 251131, useCatalyst = true, obtainedFrom = "Zaen Bladesorrow, Murder Row (dungeon)", notes = "" },
				{ slot = "Back", itemID = 239656, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Chest", itemID = 271876, useCatalyst = true, obtainedFrom = "Ula'tek, Venomous Abyss (raid)", notes = "" },
				{ slot = "Wrist", itemID = 244584, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Hands", itemID = 271484, useCatalyst = false, obtainedFrom = "Entombed Sentinels, Venomous Abyss (raid)", notes = "" },
				{ slot = "Waist", itemID = 268216, useCatalyst = false, obtainedFrom = "Nek'zali the Soulcoiler (raid)", notes = "" },
				{ slot = "Legs", itemID = 271482, useCatalyst = false, obtainedFrom = "Sszorak, Venomous Abyss (raid)", notes = "" },
				{ slot = "Feet", itemID = 271485, useCatalyst = false, obtainedFrom = "Crafted (Catalyst)", notes = "" },
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
				{ slot = "Head", itemID = 271483, useCatalyst = true, obtainedFrom = "Catalyst", notes = "" },
				{ slot = "Neck", itemID = 273781, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Shoulder", itemID = 251131, useCatalyst = true, obtainedFrom = "Zaen Bladesorrow, Murder Row (dungeon)", notes = "" },
				{ slot = "Back", itemID = 239656, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Chest", itemID = 271486, useCatalyst = true, obtainedFrom = "Catalyst", notes = "" },
				{ slot = "Wrist", itemID = 244584, useCatalyst = false, obtainedFrom = "Crafted", notes = "" },
				{ slot = "Hands", itemID = 271484, useCatalyst = true, obtainedFrom = "Catalyst", notes = "" },
				{ slot = "Waist", itemID = 159369, useCatalyst = false, obtainedFrom = "The Golden Serpent, King's Rest (dungeon)", notes = "" },
				{ slot = "Legs", itemID = 271482, useCatalyst = true, obtainedFrom = "Catalyst", notes = "" },
				{ slot = "Feet", itemID = 271485, useCatalyst = true, obtainedFrom = "Catalyst", notes = "" },
				{ slot = "Ring 1", itemID = 251148, useCatalyst = false, obtainedFrom = "Den of Nalorakk (dungeon)", notes = "" },
				{ slot = "Ring 2", itemID = 273792, useCatalyst = false, obtainedFrom = "Altar of Fangs (dungeon)", notes = "" },
				{ slot = "Trinket 1", itemID = 250215, useCatalyst = false, obtainedFrom = "Murder Row (dungeon)", notes = "" },
				{ slot = "Trinket 2", itemID = 193757, useCatalyst = false, obtainedFrom = "Ruby Life Pools (dungeon)", notes = "When trained" },
				{ slot = "Main Hand", itemID = 159137, useCatalyst = false, obtainedFrom = "King's Rest (dungeon)", notes = "" },
				{ slot = "Off Hand", itemID = 251196, useCatalyst = false, obtainedFrom = "The Blinding Vale (dungeon)", notes = "" },
			},
		},
	},
}
