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

-- minimap.hide/minimapPos are read and written by LibDBIcon-1.0 itself
-- (see the minimap button setup below) -- sections add their own default
-- keys here as they're built.
local DB_DEFAULTS = {
	minimap = { hide = false },
}
local CHAR_DB_DEFAULTS = {}

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(self, event, loadedAddonName)
	if loadedAddonName ~= ADDON_NAME then return end

	SpectomeDB = CopyDefaults(DB_DEFAULTS, SpectomeDB)
	SpectomeCharDB = CopyDefaults(CHAR_DB_DEFAULTS, SpectomeCharDB)

	Spectome.db = SpectomeDB
	Spectome.charDB = SpectomeCharDB

	-- Minimap button (LibDataBroker + LibDBIcon). Registered here, after
	-- SpectomeDB.minimap has its defaults, since LDBIcon reads db.hide the
	-- moment it's registered. `true` (silent) on both LibStub lookups so a
	-- missing/broken lib degrades to "no minimap button" instead of an
	-- addon-load error.
	local LDB = LibStub("LibDataBroker-1.1", true)
	local LDBIcon = LibStub("LibDBIcon-1.0", true)
	if LDB and LDBIcon then
		local dataObj = LDB:NewDataObject("Spectome", {
			type = "launcher",
			text = "Spectome",
			icon = "Interface\\AddOns\\Spectome\\Textures\\icon",
			OnClick = function()
				if Spectome.ToggleMainFrame then
					Spectome.ToggleMainFrame()
				end
			end,
			OnTooltipShow = function(tooltip)
				tooltip:AddLine("Spectome")
				tooltip:AddLine("Click to open", 0.8, 0.8, 0.8)
			end,
		})
		LDBIcon:Register("Spectome", dataObj, SpectomeDB.minimap)
		Spectome.LDBIcon = LDBIcon
	end

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
