-- UI/MainFrame.lua
-- The main addon panel: movable, closable, styled to match Blizzard's native
-- portrait-style panels. Owns the frame chrome only — section modules
-- (loaded after this file) build their actual content into frame.Content.

Spectome = Spectome or {}

local frame = CreateFrame("Frame", "SpectomeMainFrame", UIParent, "PortraitFrameTemplate, BackdropTemplate")
-- 750 (from an earlier session) turned out to be more than BiS Gear's
-- two-column list actually needs, leaving a large empty gap below shorter
-- sections (Talents, Trinket Tier List). 640 was sized to what BiS Gear's
-- right column (9 rows, ROW_GAP=8 between them) needs -- see the budget
-- math in Sections/Gear.lua's comments -- but still clipped the last row's
-- (Weapon) wrapped second line by a few px, so bumped by 30 to 670 for a
-- bit more bottom margin. Content area below is anchored with relative
-- insets (see frame.Content), not a fixed size, so it grows/shrinks to
-- match whatever height the frame has.
frame:SetSize(600, 670)
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
