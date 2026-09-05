-- Shared/PlayerContext.lua
-- Resolves the logged-in player's class/spec into the folder-naming
-- convention Data/<Class>/ uses (e.g. "DeathKnight", "Shaman", "Warrior")
-- and the spec display name Data files already key on (e.g. "Blood",
-- "Restoration", "Arms") -- so Sections/Talents.lua and Sections/Gear.lua
-- can look up Spectome.Data[class][spec] for whichever character is
-- actually logged in, instead of a hardcoded class/spec.

Spectome = Spectome or {}
Spectome.PlayerContext = Spectome.PlayerContext or {}

-- UnitClass("player")'s second return value ("englishClass") is the
-- ALLCAPS token Blizzard uses internally (e.g. "DEATHKNIGHT") -- map it to
-- our Data/<Class>/ folder name. Every current class is listed so the
-- helper degrades gracefully (via the "no data yet" fallback in the
-- sections) for any class we haven't scaffolded a Data/ folder for yet,
-- rather than erroring.
local CLASS_FOLDER_NAMES = {
	DEATHKNIGHT = "DeathKnight",
	DEMONHUNTER = "DemonHunter",
	DRUID = "Druid",
	EVOKER = "Evoker",
	HUNTER = "Hunter",
	MAGE = "Mage",
	MONK = "Monk",
	PALADIN = "Paladin",
	PRIEST = "Priest",
	ROGUE = "Rogue",
	SHAMAN = "Shaman",
	WARLOCK = "Warlock",
	WARRIOR = "Warrior",
}

--- Returns (classFolder, specName, displayClassName):
---   classFolder      -- e.g. "DeathKnight", or nil if the class isn't in
---                        CLASS_FOLDER_NAMES (shouldn't happen for a
---                        current retail class, but handled defensively).
---   specName         -- e.g. "Blood" (GetSpecializationInfo's own name,
---                        which is already the plain display form our Data
---                        files key on), or nil if no spec is chosen yet.
---   displayClassName -- localized class name (e.g. "Death Knight"), for
---                        building a human-readable message; independent
---                        of whether classFolder resolved.
function Spectome.PlayerContext.Get()
	local displayClassName, englishClass = UnitClass("player")
	local classFolder = englishClass and CLASS_FOLDER_NAMES[englishClass]

	local specName
	local specIndex = GetSpecialization()
	if specIndex then
		local _, name = GetSpecializationInfo(specIndex)
		specName = name
	end

	return classFolder, specName, displayClassName
end

-- Callbacks fired whenever the player's talent loadout changes, which
-- covers switching specs (a full respec swaps in a different loadout) as
-- well as in-spec talent edits. Sections register here instead of each
-- creating their own event frame.
local callbacks = {}

--- Registers `callback` to run whenever PLAYER_TALENT_UPDATE fires.
--- Callers are still responsible for re-checking on their own pane's
--- OnShow too, in case the player switched specs while the panel/tab was
--- closed and this event never reached them.
function Spectome.PlayerContext.OnChange(callback)
	table.insert(callbacks, callback)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
eventFrame:SetScript("OnEvent", function()
	for _, callback in ipairs(callbacks) do
		callback()
	end
end)
