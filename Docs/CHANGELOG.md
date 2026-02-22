# Changelog

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
