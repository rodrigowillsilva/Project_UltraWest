# Copilot Notes (Ultra West)

Free-form scratchpad for inter-session memory. I’ll add/rewrite/delete as needed.

---

Core direction:

- Professional-ish structure early, but stay Godot-native (Nodes/Scenes + Signals + Resources + Autoloads). Avoid custom frameworks.
- Prefer clear ownership boundaries so refactors stay local.

Architecture stance (current):

- Use a PlayerSystems-style coordinator node to wire player subsystems so Player.gd doesn’t become a god script.
- Keep Player (CharacterBody3D) as the owner of the physics loop and move_and_slide().
- Communication pattern:
  - Parent/owner coordinates owned children via direct calls.
  - Children report upward via signals.
  - Cross-scene / observer concerns via an EventBus Autoload with typed signals.
  - EventBus preference: typed signals for observer-style events; keep it small and avoid per-frame events.

Movement abilities model:

- Sprint (Revolver): always-on modifier while Revolver equipped.
- Abilities are movement layers:
  - Most are modifiers (speed multiplier, caps, etc.).
  - Some are “override-ish” by injecting constraints/forces (NOT duplicating the whole movement controller).

Ability model update:

- Abilities are weapon-linked behaviors; movement modification is optional (non-movement abilities return an identity movement layer).
- Abilities are Nodes (Proto) so they can own state and spawn helper nodes (e.g., grapple projectile, holy water area).

Grapple (Shotgun) notes (feel + robustness):

- Fast projectile hook travel (not hitscan).
- Attach to world or enemies.
- Primary behavior: pull-to-point via winch/reel-in, but player keeps steering influence (swing feel).
- Gravity stays active; grapple force stronger than gravity. No full floaty suspension by default (still open if feel demands it).
- Release-to-cancel.
- Enemy pull is data-driven by enemy type (light pulled to player; heavy may pull player more; some resist/ignore).
- To keep it robust: treat grapple as a small state machine + clear exit rules.

Open points to resolve soon:

- EventBus contract (minimum set of events + payload keys) for Proto.
- Where input routing lives (Player vs PlayerSystems) and the exact call chain for: input → weapon switch → ability select → movement.
- For grapple feel: decide if we ever apply mild gravity reduction or strictly keep gravity unchanged.

Decisions locked (Proto):

- Input routing: Player (CharacterBody3D) samples continuous input. PlayerSystems receives discrete commands (weapon switch, ability press/release).
- Ability rule: all abilities cancel on weapon switch.
- Grapple input: hold-to-grapple; release cancels.
- Ability integration: abilities provide movement modifiers/forces/constraints; Player still composes final velocity and calls move_and_slide().
- EventBus: prefer typed signals (cross-scene observers like HUD/Audio/Run flow), avoid per-frame events.

Guardrails / don’t-forget:

- Don’t let EventBus become per-frame or “everything is an event”.
- Keep base movement single-sourced; grapple injects forces/constraints, it doesn’t replace the entire mover.
- Prefer stable IDs (StringName) in definitions/events; include Resource refs only when truly helpful.

---

Session state (Proto):

- Player scene wiring works; raw mouse motion look is applied in `_unhandled_input`.
- MovementLayer is integrated; Sprint works as a simple speed multiplier for Revolver.
- Weapon switching (slots 1/2) + ability press/release routing is in place via PlayerSystems.
- Next: implement Revolver firing and Grapple ability; bind weapon_1/weapon_2 keys if needed.
