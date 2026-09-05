-- Shared/Sources.lua
-- Source registry: the single place that knows which guide sites exist, what
-- data each one provides, and how to look them up. UI code (source pickers,
-- section tabs) reads this instead of hardcoding source names anywhere else.
--
-- Schema per source:
--   id          (string)  registry key, e.g. "icyveins"
--   displayName (string)  shown in the UI, e.g. "Icy Veins"
--   icon        (string)  texture path, e.g. "Interface\AddOns\Spectome\Textures\icyveins"
--   provides    (array)   data types this source has content for — one or
--                         more of: "guide", "talents", "gear", "stats",
--                         "crafting"
--
-- PvE-focused only for now -- no pvpTalents data type and no Murlok entry
-- (Murlok only ever provided PvP talent data). Revisit if PvP support
-- returns.

Spectome = Spectome or {}

-- Spectome.Sources is both the registry (keyed by source id) and the object
-- the lookup methods below are called on, e.g. Spectome.Sources:Get("wowhead").
Spectome.Sources = {
	icyveins = {
		id = "icyveins",
		displayName = "Icy Veins",
		icon = "Interface\\AddOns\\Spectome\\Textures\\icyveins",
		provides = { "guide", "talents", "gear", "stats", "crafting" },
	},
	wowhead = {
		id = "wowhead",
		displayName = "Wowhead",
		icon = "Interface\\AddOns\\Spectome\\Textures\\wowhead",
		provides = { "guide", "talents", "gear", "stats", "crafting" },
	},
	archon = {
		id = "archon",
		displayName = "Archon",
		icon = "Interface\\AddOns\\Spectome\\Textures\\archon",
		provides = { "talents", "gear", "stats" },
	},
	method = {
		id = "method",
		displayName = "Method",
		icon = "Interface\\AddOns\\Spectome\\Textures\\method",
		provides = { "guide", "talents", "gear" },
	},
}

-- Fixed display order for the ids above. pairs() iteration order over the
-- registry isn't guaranteed to stay stable, and a source-picker's tab order
-- shouldn't shuffle from one login to the next, so lookups below walk this
-- list rather than the registry table directly.
local SOURCE_ORDER = { "icyveins", "wowhead", "archon", "method" }

--- Returns the source table for a single id, or nil if it isn't registered.
function Spectome.Sources:Get(id)
	return self[id]
end

--- Returns an array of source tables whose `provides` list includes
--- dataType, in the fixed SOURCE_ORDER above. Used by section UI to decide
--- which sources to offer as tabs/options for a given data type, e.g.
--- Spectome.Sources:GetForDataType("crafting") -> { Icy Veins, Wowhead }.
function Spectome.Sources:GetForDataType(dataType)
	local matches = {}
	for _, id in ipairs(SOURCE_ORDER) do
		local source = self[id]
		if source then
			for _, provided in ipairs(source.provides) do
				if provided == dataType then
					table.insert(matches, source)
					break
				end
			end
		end
	end
	return matches
end
