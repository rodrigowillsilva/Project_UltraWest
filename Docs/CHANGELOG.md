# Changelog

## 24/03/2026

- feat(weapons): Completed DEV-006 core weapons implementation with concrete Revolver and Shotgun firing behavior (Scripts/Weapons/Revolver.gd, Scripts/Weapons/Shotgun.gd)
- feat(weapons): Added FirePoint-driven shot origin support in WeaponBase so weapon muzzle origin is editor-configurable (Scripts/Weapons/WeaponBase.gd)
- feat(weapons): Added shooting debug logging for pellet/shot hit feedback to support tuning iteration (Scripts/Weapons/WeaponBase.gd, Scripts/Weapons/Shotgun.gd)
- docs(backlog): Marked DEV-006 as Done and promoted DEV-007 to Active (Docs/backlog.md)

## 22/03/2026

- feat(weapons): Completed DEV-002 WeaponBase core with ammo management, overridable fire hook, fire cooldown timer, and generic reload timer used by manual/holster reload (Scripts/Weapons/WeaponBase.gd)
- feat(weapons): Expanded WeaponManager lifecycle with equip/unequip flow, active weapon routing (fire/release/reload), and safe next/slot switching (Scripts/Weapons/WeaponManager.gd)
- feat(player): Wired combat input flow through PlayerSystems to weapon core (primary fire press/release and reload) and fixed input handling edge cases (Scripts/Player/Player.gd, Scripts/Player/PlayerSystems.gd)
- docs(backlog): Marked DEV-002 as Done (Docs/backlog.md)

## 08/02/2026

- feat(player): Added FPS CharacterBody3D controller with raw mouse-look, WASD, jump + gravity (Scripts/Player/Player.gd)
- feat(player): Added PlayerSystems coordinator wiring WeaponManager + AbilityManager; routes weapon/ability inputs (Scripts/Player/PlayerSystems.gd)
- feat(abilities): Added MovementLayer + AbilityBase/AbilityManager + SprintAbility (Revolver->Sprint) (Scripts/Abilities/*)
- feat(weapons): Added WeaponBase + WeaponManager stub with slot switching (Scripts/Weapons/*)

## 24/01/2026

- docs(gdd): Added Proto P1 ability system architecture notes + class diagram; aligned EventBus wording and Player node type (Docs/GDD/GDD.md)

## 13/01/2026

- docs(gdd): Added movement+ability layering sequence diagram and Player scene tree sketch; aligned EventBus diagrams to typed signals (Docs/GDD/GDD.md)

## 11/01/2026

- docs(gdd): Refined movement mechanics (grapple projectile + pull-to-point, release-to-cancel, enemy pull by type) (Docs/GDD/GDD.md)
- docs(gdd): Added Technical architecture overview + minimal mermaid diagrams (event bus, PlayerSystems coordinator, resource-driven data) (Docs/GDD/GDD.md)

## 05/01/2026

- docs(gdd): Completed Art, Audio, and Level Design sections (Docs/GDD/GDD.md)
- docs(gdd): Added Factions, Enemy Roles, and Characters section (Docs/GDD/GDD.md)
- docs(backlog): Updated backlog with new tasks and priorities (Docs/backlog.md)

## 04/01/2026

- docs(backlog): Reorganized backlog with area-based IDs (DESIGN-, DEV-, AV-, DOC-) and distilled solo-dev priorities (Docs/backlog.md)
- docs(changelog): Added initial changelog section (Docs/CHANGELOG.md)
