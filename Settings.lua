-- Settings.lua
-- Options -> AddOns entry: a minimal panel with an "Open Spectome" button
-- and a "Show minimap icon" checkbox. Registered via the current retail
-- Settings API (Settings.RegisterCanvasLayoutCategory +
-- Settings.RegisterAddOnCategory) -- see reference/ClassCodex/Settings.lua
-- for the sibling RegisterVerticalLayoutCategory pattern (auto-generated
-- checkbox/dropdown rows). Canvas is used here instead since we want a
-- real button widget, and ClassCodex's own comments note
-- CreateSettingsButtonInitializer has tripped a Blizzard assertion on some
-- client versions -- a hand-built native Button avoids that entirely.
--
-- Both widgets here only read/write SpectomeDB inside their click
-- handlers, never at file-load time, so it doesn't matter whether this
-- file loads before or after Spectome.lua's ADDON_LOADED handler applies
-- SpectomeDB's defaults -- by the time a player actually opens this panel,
-- that's long since happened.

Spectome = Spectome or {}

local panel = CreateFrame("Frame")

local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("Spectome")

local openButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
openButton:SetSize(140, 22)
openButton:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
openButton:SetText("Open Spectome")
openButton:SetScript("OnClick", function()
	if Spectome.ToggleMainFrame then
		Spectome.ToggleMainFrame()
	end
end)

local minimapCheckbox = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
minimapCheckbox:SetPoint("TOPLEFT", openButton, "BOTTOMLEFT", 0, -20)

-- Own label FontString rather than relying on an assumed built-in text
-- region name on UICheckButtonTemplate (varies across template versions).
local minimapLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
minimapLabel:SetPoint("LEFT", minimapCheckbox, "RIGHT", 4, 0)
minimapLabel:SetText("Show minimap icon")

minimapCheckbox:SetScript("OnClick", function(self)
	local shown = self:GetChecked() and true or false
	SpectomeDB.minimap = SpectomeDB.minimap or {}
	SpectomeDB.minimap.hide = not shown
	if Spectome.LDBIcon then
		if shown then
			Spectome.LDBIcon:Show("Spectome")
		else
			Spectome.LDBIcon:Hide("Spectome")
		end
	end
end)

-- Reflect the current saved state every time the panel is opened, rather
-- than only once at load time.
panel:SetScript("OnShow", function()
	local hidden = SpectomeDB.minimap and SpectomeDB.minimap.hide
	minimapCheckbox:SetChecked(not hidden)
end)

local category = Settings.RegisterCanvasLayoutCategory(panel, "Spectome")
Settings.RegisterAddOnCategory(category)
