# Spectome

A personal, all-in-one class/spec reference addon for World of Warcraft
(retail, currently tracking **Midnight — 12.1**). Spectome pulls together
talent builds, gear recommendations, stat priorities, enchants, and
consumables from multiple community guide sites — **Icy Veins, Wowhead,
Archon, and Method** — into a single in-game panel styled to match
Blizzard's native UI.

Instead of tabbing out to a browser mid-raid to check "what's the BiS ring
again?", open Spectome and pick whichever site's recommendation you trust
for that decision.

> **Note:** Spectome is a private addon built for personal/friend-group
> use. It does not scrape or redistribute guide content automatically —
> every piece of data is manually curated and entered by hand from publicly
> available guides, the same way you'd take your own notes from a website.
> It is not affiliated with, endorsed by, or officially connected to Icy
> Veins, Wowhead, Archon, or Method.

## Features

- **Talents** — Raid and Mythic+ builds (some specs split further by
  single-target vs multi-target, or by hero talent tree), with a one-click
  **Apply Build** button that imports the loadout directly in-game.
- **Gear** — Best-in-Slot lists for Overall and Mythic+ contexts, with real
  item icons, tooltips, drop sources, and Matrix Catalyst call-outs. Also
  includes a separate **Trinket Tier List** view (S–F tier rankings).
- **Stats** — Stat priority broken down by hero talent tree, with the
  reasoning behind each priority (soft caps, diminishing returns,
  mechanic-specific notes).
- **Enchants & Consumables** — Recommended enchants per slot (including
  best-vs-alternative and hero-tree-specific picks), plus flasks, potions,
  food, and augment runes, grouped by category.
- **Multi-source, side by side** — Every section has a source picker, so
  you can compare what each site recommends and decide for yourself, or
  just default to whichever site you trust most.
- **Auto-detects your class/spec** — Log in on any supported character and
  Spectome shows the right data automatically.

## Currently supported

| Class | Spec |
|---|---|
| Death Knight | Blood |
| Warrior | Arms |
| Shaman | Restoration |

More classes/specs get added as time allows — this is a side project
maintained alongside actually playing the game.

## Installation

1. Download the latest release (or clone this repo).
2. Copy the `Spectome` folder into your WoW AddOns directory:
   `World of Warcraft/_retail_/Interface/AddOns/`
3. Make sure the resulting path is `AddOns/Spectome/Spectome.toc` (not
   nested inside an extra folder).
4. Enable AddOns at the character select screen if you haven't already.
5. Launch or `/reload` — Spectome should appear in your AddOns list, with
   a minimap icon and an entry under **Options → AddOns**.

## Usage

- Click the minimap icon, use `/spectome`, or open it from **Options →
  AddOns → Spectome** to toggle the main panel.
- Use the tabs (Talents / Gear / Stats / Enchants) to switch sections.
- Use the source dropdown within each section to switch between Icy Veins,
  Wowhead, Archon, and Method.

## Keeping data up to date

Spectome's data is static — it doesn't phone home or scrape anything at
runtime. When a guide site updates its recommendations, the relevant data
file needs to be updated by hand. If you're maintaining your own fork,
check each source's `lastUpdated` field to see how stale a given entry is.

## Credits

- Talent, gear, stat, enchant, and consumable recommendations are curated
  from [Icy Veins](https://www.icy-veins.com/), [Wowhead](https://www.wowhead.com/),
  [Archon.gg](https://www.archon.gg/), and [Method](https://www.method.gg/) —
  full credit to their respective authors and theorycrafters for the
  underlying recommendations. Go read their full guides for the reasoning
  behind every pick.
- UI/structure loosely inspired by community addons like Class Codex.

## Support

Spectome is a free hobby project, built and maintained in my spare time.
If you'd like to support development, donations are welcome but never
expected:

**PayPal:** 
https://www.paypal.com/donate/?hosted_button_id=633SWHET8Z84E

## License

Personal/non-commercial use. Not affiliated with Blizzard Entertainment,
Icy Veins, Wowhead, Archon.gg, or Method.
