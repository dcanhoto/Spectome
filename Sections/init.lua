-- Sections/init.lua
-- Tab registry: each section module (Talents, Gear, ...) calls
-- Spectome.Sections:Register(id, label, buildFn) to get its own pane inside
-- Spectome.MainFrame.Content and a tab button that shows/hides it. Builds a
-- tab bar across the top of the content area and a body frame below it that
-- every section's pane fills.
--
-- Loads before the section modules (see Spectome.toc) so Register already
-- exists by the time they call it.

Spectome = Spectome or {}
Spectome.Sections = Spectome.Sections or {}

local TAB_HEIGHT = 24
local TAB_WIDTH = 90
local TAB_SPACING = 6

local content = Spectome.MainFrame.Content

local tabBar = CreateFrame("Frame", nil, content)
tabBar:SetPoint("TOPLEFT")
tabBar:SetPoint("TOPRIGHT")
tabBar:SetHeight(TAB_HEIGHT)

local body = CreateFrame("Frame", nil, content)
body:SetPoint("TOPLEFT", tabBar, "BOTTOMLEFT", 0, -8)
body:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT")

local panes = {}       -- id -> pane frame
local tabButtons = {}  -- id -> tab button
local order = {}       -- registration order, so tabs lay out left to right
local activeId

local function ShowSection(id)
	if activeId == id then return end
	activeId = id
	for paneId, pane in pairs(panes) do
		pane:SetShown(paneId == id)
	end
	for tabId, button in pairs(tabButtons) do
		local isActive = (tabId == id)
		button:SetButtonState(isActive and "PUSHED" or "NORMAL", isActive)
	end
end

--- Registers a new section tab. `label` is the tab button's text; buildFn
--- is called once, immediately, with a frame already anchored to fill the
--- shared body area below the tab bar -- the section builds its own
--- content into that frame exactly like it used to build directly into
--- Spectome.MainFrame.Content. The first section registered is shown by
--- default.
function Spectome.Sections:Register(id, label, buildFn)
	local pane = CreateFrame("Frame", nil, body)
	pane:SetAllPoints()
	pane:Hide()
	panes[id] = pane

	local previousButton = order[#order] and tabButtons[order[#order]]
	local button = CreateFrame("Button", nil, tabBar, "UIPanelButtonTemplate")
	button:SetSize(TAB_WIDTH, TAB_HEIGHT)
	if previousButton then
		button:SetPoint("LEFT", previousButton, "RIGHT", TAB_SPACING, 0)
	else
		button:SetPoint("LEFT", tabBar, "LEFT", 0, 0)
	end
	button:SetText(label)
	button:SetScript("OnClick", function() ShowSection(id) end)
	tabButtons[id] = button
	table.insert(order, id)

	buildFn(pane)

	if not activeId then
		ShowSection(id)
	end

	return pane
end
