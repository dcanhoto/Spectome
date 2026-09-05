-- UI/MainFrame.lua
-- The main addon panel: movable, closable, styled to match Blizzard's native
-- portrait-style panels. Owns the frame chrome only — section modules
-- (loaded after this file) build their actual content into frame.Content.

Spectome = Spectome or {}

local frame = CreateFrame("Frame", "SpectomeMainFrame", UIParent, "PortraitFrameTemplate, BackdropTemplate")
frame:SetSize(600, 500)
frame:SetPoint("CENTER")
frame:SetFrameStrata("HIGH")
frame:SetTitle("Spectome")
frame:SetPortraitToAsset("Interface\\AddOns\\Spectome\\Textures\\icon")
frame:Hide()

-- Movable by dragging the frame (title bar area).
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- Let Escape close it, like other native Blizzard panels.
table.insert(UISpecialFrames, "SpectomeMainFrame")

-- Content area sections build their UI into. Loaded after this file (see
-- Spectome.toc), each section reaches into Spectome.MainFrame.Content
-- rather than the frame's chrome directly.
local content = CreateFrame("Frame", nil, frame)
content:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -60)
content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -14, 14)
frame.Content = content

Spectome.MainFrame = frame

function Spectome.ToggleMainFrame()
	if frame:IsShown() then
		frame:Hide()
	else
		frame:Show()
	end
end
