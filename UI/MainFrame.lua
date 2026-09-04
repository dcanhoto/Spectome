-- UI/MainFrame.lua
-- The main addon panel. Movable, closable, styled to match Blizzard's native
-- portrait-style panels. Sections/tabs get built into the content area here
-- in later sessions — for now this is just an empty shell.

Spectome = Spectome or {}

local frame = CreateFrame("Frame", "SpectomeMainFrame", UIParent, "PortraitFrameTemplate, BackdropTemplate")
frame:SetSize(600, 500)
frame:SetPoint("CENTER")
frame:SetFrameStrata("HIGH")
frame:SetTitle("Spectome")
frame:Hide()

-- Movable by dragging the frame (title bar area).
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- Let Escape close it, like other native Blizzard panels.
table.insert(UISpecialFrames, "SpectomeMainFrame")

Spectome.MainFrame = frame

function Spectome.ToggleMainFrame()
	if frame:IsShown() then
		frame:Hide()
	else
		frame:Show()
	end
end
