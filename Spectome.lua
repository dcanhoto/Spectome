-- Spectome.lua
-- Core addon init: namespace, saved variables, slash command.
-- Loads last (see Spectome.toc) so it can wire up the UI/Sections created by
-- the earlier files.

local ADDON_NAME = ...

Spectome = Spectome or {}

local function CopyDefaults(defaults, target)
	target = target or {}
	for key, value in pairs(defaults) do
		if type(value) == "table" then
			target[key] = CopyDefaults(value, target[key])
		elseif target[key] == nil then
			target[key] = value
		end
	end
	return target
end

-- Empty for now — sections will add their own default keys as they're built.
local DB_DEFAULTS = {}
local CHAR_DB_DEFAULTS = {}

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(self, event, loadedAddonName)
	if loadedAddonName ~= ADDON_NAME then return end

	SpectomeDB = CopyDefaults(DB_DEFAULTS, SpectomeDB)
	SpectomeCharDB = CopyDefaults(CHAR_DB_DEFAULTS, SpectomeCharDB)

	Spectome.db = SpectomeDB
	Spectome.charDB = SpectomeCharDB

	self:UnregisterEvent("ADDON_LOADED")
end)

SLASH_SPECTOME1 = "/spectome"
SlashCmdList["SPECTOME"] = function()
	if Spectome.ToggleMainFrame then
		Spectome.ToggleMainFrame()
	else
		print("Spectome loaded.")
	end
end
