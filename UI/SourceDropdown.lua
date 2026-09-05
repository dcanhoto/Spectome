-- UI/SourceDropdown.lua
-- Reusable source-picker dropdown: closed state shows the selected source's
-- icon + display name, opening it lists every source that provides a given
-- data type (see Shared/Sources.lua), each row also showing icon + name.
-- Uses the same WowStyle1Dropdown widget reference/ClassCodex's
-- TalentPaneDropdown.lua and Settings.lua use for their own native-style
-- dropdowns. Extracted from Sections/Talents.lua so every data-backed
-- section (Gear, Stats, ...) can reuse the same picker instead of
-- reimplementing the dropdown wiring.

Spectome = Spectome or {}
Spectome.UI = Spectome.UI or {}

local ICON_SIZE = 16
local DEFAULT_WIDTH = 160
local DEFAULT_HEIGHT = 28

-- Inline texture-escape label used both as a dropdown menu row and as the
-- dropdown's closed-state text (WowStyle1Dropdown's SetDefaultText/menu
-- item labels both just take a string, and FontStrings render |T...|t like
-- any other native text).
local function FormatSourceLabel(source)
	return ("|T%s:%d:%d:0:0|t %s"):format(source.icon, ICON_SIZE, ICON_SIZE, source.displayName)
end

--- Creates a source-picker dropdown parented to `parent`, listing every
--- source whose `provides` includes `dataType` (Spectome.Sources:GetForDataType).
--- Immediately selects the first source (firing onSourceSelected once at
--- creation) and again every time the user picks a different one.
--- onSourceSelected(sourceId) is the only required callback -- callers own
--- whatever state/redraw logic follows a selection change.
--- Returns the dropdown frame.
function Spectome.UI.CreateSourceDropdown(parent, dataType, onSourceSelected)
	local dropdown = CreateFrame("DropdownButton", nil, parent, "WowStyle1DropdownTemplate")
	dropdown:SetSize(DEFAULT_WIDTH, DEFAULT_HEIGHT)

	local sources = Spectome.Sources:GetForDataType(dataType)
	local activeSourceId

	local function Select(sourceId)
		activeSourceId = sourceId
		local source = Spectome.Sources:Get(sourceId)
		if source and dropdown.SetDefaultText then
			dropdown:SetDefaultText(FormatSourceLabel(source))
		end
		onSourceSelected(sourceId)
	end

	dropdown:SetupMenu(function(_, rootDescription)
		for _, source in ipairs(sources) do
			rootDescription:CreateRadio(
				FormatSourceLabel(source),
				function() return activeSourceId == source.id end,
				function() Select(source.id) end
			)
		end
	end)

	if sources[1] then
		Select(sources[1].id)
	end

	return dropdown
end
