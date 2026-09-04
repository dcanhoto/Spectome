# Spectome — Addon Development Guidelines

This file is project context for any AI assistant (Claude, etc.) working on this
codebase. Read this in full before writing or editing any code.

## What this addon is

Spectome is a **private, personal-use** World of Warcraft addon for a small
group of friends. It shows class/spec guide information (stat priorities,
talent builds, rotation notes, gearing) in a panel styled to match Blizzard's
native UI, with a source picker so the player can choose which guide site's
recommendation they're viewing (Icy Veins, Wowhead, Archon, Method, etc.).

**Not for public release, not for CurseForge/Wago distribution.** This matters
for two reasons the assistant should keep in mind:
- We don't need to worry about supporting every edge case / every WoW locale.
- The data model can assume a small, trusted set of installs (no telemetry,
  no auto-update-from-internet — see "Data policy" below).

## Reference project

There's a local reference copy of **ClassCodex** (MIT-licensed) in
`/reference/ClassCodex/`. It's a mature, structurally similar addon and a
good source of patterns — folder layout, data-per-source organization, and
hand-rolled UI widgets. Treat it as a structural/pattern reference, not a
copy-paste source: **our own data tables are curated manually by the addon
owner, not scraped or bulk-copied from ClassCodex's Data folder.**

## Data policy — read before touching data files

- **No live scraping, no network calls to guide websites.** All guide content
  (talent strings, stat priorities, rotation text, gear lists) is entered as
  static Lua tables, curated manually by the addon owner.
- When the owner pastes in updated guide info from a website, the assistant's
  job is to reformat it into the addon's existing Lua data schema — not to
  fetch it, not to invent data that wasn't provided.
- Never add a `http`/`C_WebRequest`-style call or any mechanism that reaches
  out to icy-veins.com, wowhead.com, archon.gg, method.gg, etc. from inside
  the addon at runtime.
- Each data entry should carry a `source` field (which site it came from) and
  ideally a `lastUpdated` field (patch version or date), so stale entries are
  easy to spot later.

## Technical target

- **Retail only**, current interface version tracks **WoW 12.1 (Midnight —
  Curse of Ula'tek)**. Update the `.toc` Interface number when the client
  updates; do not try to support Classic/Classic Era.
- **Framework: lightweight, not full Ace3.** Following the ClassCodex
  reference pattern: use **LibStub** plus small standalone libraries as
  needed (e.g. CallbackHandler-1.0 for event-style callbacks, LibDataBroker
  + LibDBIcon if we want a minimap button). Do **not** pull in
  AceGUI-3.0/AceConfig-3.0 for the main panel — their auto-generated widgets
  have a generic look that works against the "feels native" goal. Saved
  variables can use a simple hand-rolled table (`SpectomeDB` /
  `SpectomeCharDB` via `## SavedVariables` in the `.toc`) rather than AceDB,
  matching ClassCodex's approach.
- Combat-automation restrictions ("Addon Disarmament" / Secret Values) are
  active in Midnight. Spectome is a **passive information display** — it does
  not read combat log events, does not react to auras/casts, and does not
  drive any gameplay decisions. Keep it that way; if a feature idea starts
  needing combat-state awareness, flag it and reconsider rather than reaching
  for a workaround.

## Visual style — match native Blizzard UI

Goal: it should look like Blizzard shipped it. Reference the **updated 12.x
UI** (Edit Mode panels, Cooldown Manager, character/spellbook frames) — not
the older, pre-Midnight button style.

Concretely:
- Build UI directly against Blizzard's frame API and shared templates
  (`BackdropTemplate`, current button templates, `PortraitFrameTemplate`,
  etc.) — hand-rolled widgets like ClassCodex's `UI/CollapsibleSection.lua`
  and `UI/SlotIcon.lua`, not AceGUI-generated ones.
- Match: border style, corner rounding, hover/press highlight behavior, font
  (`GameFontNormal`/`GameFontHighlight` family), and color palette of the
  current native panels.
- Screenshots of the current native UI will be provided in
  `/reference-screenshots/` — check there before styling any new panel, and
  ask for a screenshot if a relevant one is missing rather than guessing.
- Tabs/source-picker should feel like Blizzard's own tab widgets, not a
  custom dropdown, unless a dropdown is genuinely the better UX for the
  number of sources. ClassCodex's `Shared/Sources.lua` +
  `Sections/init.lua` show one working pattern for this.

## Folder structure

```
Spectome/
├── Spectome.toc
├── Spectome.lua                    -- init, saved vars, slash commands
├── Settings.lua                    -- options panel (hand-rolled, native style)
├── Data/
│   └── <Class>/
│       ├── guide-<source>.lua      -- e.g. guide-icyveins.lua, guide-wowhead.lua
│       ├── talents-<source>.lua
│       ├── gear-<source>.lua
│       └── stats-<source>.lua
├── Sections/                       -- UI section modules: Rotation.lua, Talents.lua,
│                                       Gear.lua, Stats.lua, init.lua (tab registry)
├── Shared/                         -- Sources.lua (source registry/switcher logic),
│                                       GearingUtils.lua, other cross-cutting helpers
├── UI/                             -- reusable widgets: CollapsibleSection.lua,
│                                       SlotIcon.lua, SectionTitle.lua
├── Textures/                       -- source-site icons (icyveins, wowhead, archon,
│                                       method...)
├── Libs/                           -- LibStub, CallbackHandler-1.0, (LibDataBroker/
│                                       LibDBIcon only if we add a minimap button)
└── reference/
    └── ClassCodex/                 -- read-only structural reference, MIT-licensed
```

## Coding conventions

- Namespace everything under a single addon table (`Spectome = Spectome or {}`)
  — no stray globals except what's declared in `Lua.diagnostics.globals`.
- Comment WHY, not just what, especially in data files (e.g. why a stat
  priority differs between sources).
- Keep UI code and data code separate — a data update should never require
  touching UI files.
- File naming for data: `<datatype>-<source>.lua` (e.g. `talents-archon.lua`,
  `gear-method.lua`) — mirrors the ClassCodex reference pattern, keeps it
  trivial to add a new source without restructuring anything.

## Update workflow (how the owner keeps data current)

1. Owner reads updated guide on a website, copies relevant info.
2. Owner pastes it to the assistant along with which class/spec/source it's
   for.
3. Assistant produces a Lua table diff/patch matching the existing schema in
   `Data/<Class>/<datatype>-<source>.lua`.
4. Owner applies it, `/reload`s in-game, verifies.

## Things to avoid

- Do not reproduce large verbatim blocks of guide text — paraphrase/structure
  it into short data fields (stat order, short rotation bullet points, etc.)
  rather than pasting full prose paragraphs from the source site.
- Do not add any licensing/attribution claims suggesting official partnership
  with Icy Veins, Wowhead, Archon, or Method.
- Do not implement anything that automates gameplay (auto-cast, auto-target,
  combat-log-driven decisions).
- Do not bulk-copy ClassCodex's actual `Data/` content into Spectome's data
  files — use it for structural/schema reference only.
