# Project Backlog

Solo-dev distilled backlog focused on essentials. IDs use area prefixes:
DESIGN-, DEV-, AV-, DOC-. Columns: Priority (P1 highest), Milestone (Proto = Prototype, Slice = Vertical Slice, Alpha = Alpha).

## Backlog

- DESIGN-005 - Upgrade System refinement (P2, Slice)
  - Define specific rarity tiers, reroll costs/math, and detailed card list.
- DESIGN-003 - Enemy roster outline (3–5) (P1, Proto)
  - Core behaviors, weapon/movement counters, spawn role tags.
- DESIGN-004 - Run & Night flow refinement (P2, Proto)
  - Clarify pacing, reward cadence, difficulty ramp knobs.
- DEV-006 - Implement Core Weapons (Revolver & Shotgun) (P1, Proto)
  - Inherit from `WeaponBase`. Specific firing logic (Hitscan vs Raycast).
- DEV-007 - Implement Core Abilities (Sprint & Grapple) (P1, Proto)
  - Inherit from `AbilityBase`. Physics logic for Grapple and Speed Boost.
- DEV-008 - Player Controller State Machine scaffold (P2, Proto)
 	- Movement states scaffold (ground/air), clean transitions, hooks for abilities.
- DEV-004 - Arena greybox test scene (P1, Proto)
  - Traversal lanes, verticality check, sight lines, spawn points.
- AV-001 - Art direction brief (P2, Slice)
  - Stylized 2.5D, readability palette, mood refs.
- AV-002 - Audio direction brief (P2, Slice)
  - Western x industrial/metal motifs, layering approach, SFX taxonomy.
- DOC-001 - Glossary expansion pass (P3, Proto)
  - Add missing mechanics, enemy role tags, upgrade terminology.

## Active

- DESIGN/DOC-000 - Docs maintenance (P1, Ongoing)
  - Keep GDD, backlog, changelog updated with progress and decisions.

- DOC-004 - Initial techinical architecturing in GDD (P1, Proto)
  - Architecture the mais systems and designs of the techincal side of the game in the GDD.

- DEV-005 - Base Player Controller (Kinematic) (P1, Proto)
  - Basic FPS movement (Walk, Jump, Gravity), Camera controller.
- DEV-002 - Weapon System Architecture (Base Classes) (P1, Proto)
  - `WeaponBase` class (shoot, reload, ammo), `WeaponManager` (inventory, switching logic, "reload-on-holster").

## Done

- DESIGN-001 - Core GDD revision (P1, Proto)
  - Fill placeholders, finalize weapon + movement coupling, tighten vision & loop descriptions.
- DESIGN-002 - Upgrade System spec v1 (P1, Proto)
  - End-of-night choices, categories, rarity tiers, reroll rules, synergy hooks.
- DOC-002 - README refinement (P2, Proto)
  - Conventional structure, concise feature list, setup, links.
- DOC-003 - Documentation scaffold (P3, Proto)
  - Initial README, backlog, roadmap, glossary baseline.

- DEV-001 - Project Initialization & Core Input (P1, Proto)
  - Folder structure, Input Map (Godot Input Actions), Physics Layers, Global Constants, etc.

- DEV-005 - Base Player Controller (Kinematic) (P1, Proto)
  - Basic FPS movement (Walk, Jump, Gravity), Camera controller.
- DEV-003 - Ability System Architecture (P1, Proto)
  - `AbilityBase` class, Hooking abilities into the Player Controller (velocity overrides).
