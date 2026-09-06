-- Shared/ContextLabels.lua
-- Display-label lookup for `context` keys used by any section with a
-- dynamic context switcher (Sections/Talents.lua, Sections/Stats.lua, and
-- future sections built the same way) -- e.g. "raid" -> "Raid",
-- "deathbringer" -> "Deathbringer". Kept here rather than duplicated as a
-- local table in each section so adding a context key once covers every
-- section that might need it, and so two sections reusing the same
-- switcher pattern stay consistent about how a given key reads.
--
-- Lookups follow the pattern `Spectome.ContextLabels[context] or context`
-- -- an unmapped key falls back to itself, so a future context type never
-- silently breaks; it just displays its raw key until a label is added
-- here.

Spectome = Spectome or {}

Spectome.ContextLabels = {
	-- Talents/Gear: split by content type.
	raid = "Raid",
	mythicPlus = "Mythic+",
	singleTargetRaid = "Single-Target Raid",
	multiTargetRaid = "Multi-Target Raid",
	-- Stats: split by hero talent tree -- stat priority is a build-mechanics
	-- question tied to hero tree choice, not content type, so it doesn't
	-- reuse the raid/mythicPlus keys above.
	deathbringer = "Deathbringer",
	sanlayn = "San'layn",
}
