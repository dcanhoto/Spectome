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

local function EmptySlots()
	return {
		{ slot = "Head", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Neck", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Shoulder", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Back", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Chest", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Wrist", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Hands", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Waist", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Legs", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Feet", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Ring 1", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Ring 2", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Trinket 1", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Trinket 2", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
		{ slot = "Weapon", itemID = 0, obtainedFrom = "", notes = "", useCatalyst = false },
	}
end

Spectome.Data.DeathKnight.Blood.gear.method = {
	source = "method",
	class = "DeathKnight",
	spec = "Blood",
	lastUpdated = "",
	builds = {
		{ context = "overall", items = EmptySlots() },
		{ context = "mythicPlus", items = EmptySlots() },
	},
}
