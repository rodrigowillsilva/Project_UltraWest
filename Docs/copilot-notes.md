# Copilot Notes (Ultra West)

Free-flow scratchpad for inter-session context. Keep this practical and current.

---

Current shape of the codebase:

- Keep the architecture Godot-native and boring in a good way: Nodes/Scenes/Signals/Resources over custom frameworks.
- `Player` owns physics truth (`move_and_slide` and final velocity composition).
- `PlayerSystems` is the coordinator layer so player logic does not collapse into one script.
- Weapon and ability systems are split and should stay independently testable.

Weapon-side reality right now:

- Weapon base now supports a real lifecycle (equip/unequip, trigger press/release, fire cooldown, timed reload behavior).
- Time logic is timer-driven (fire cadence + one generic reload timer reused by normal reload and holster reload).
- Concrete weapon scripts should define identity/config (including weapon id), while base class keeps generic behavior.
- `WeaponManager` handles switching lifecycle and active routing; avoid pushing switching policy down into concrete weapons.

Input and coordination stance:

- `Player` samples input events and forwards discrete actions to systems.
- `PlayerSystems` routes weapon commands (switch/fire/release/reload) and ability commands.
- Keep this split: input collection in `Player`, game-feature orchestration in `PlayerSystems`.

Ability direction (still valid):

- Abilities are weapon-linked and may or may not modify movement.
- Movement ability output should remain layered/modifier-based, not a second movement controller.
- On weapon switch, active ability cancel remains the safest default for prototype consistency.

Things to keep an eye on:

- Keep logs/noise low in base scripts; avoid persistent debug prints in core loops.
- Avoid enum ordering dependencies for weapon slots where possible; prefer explicit mapping in manager or definitions.
- EventBus should stay for cross-scene observer events only, never per-frame spam.
- If a system starts needing many booleans for state, it probably wants a small explicit state machine.

Potentially outdated assumptions to revisit soon:

- Some notes previously assumed weapon IDs were configured directly in scene nodes; current direction is to set those in concrete weapon scripts.
- Previous “next immediate step” notes about implementing base weapon flow are outdated and should not drive planning now.

What future Copilot sessions should prioritize:

- Concrete Revolver and Shotgun scripts should be the next place for behavior specialization (fire pattern, ammo profile, feel tuning).
- Greybox combat iteration should validate whether cooldown/reload values feel right before more architecture changes.
- Keep docs aligned, but this file should remain design-memory first, not a changelog duplicate.

Guardrails:

- Don’t let EventBus become per-frame or “everything is an event”.
- Keep base movement single-sourced; grapple injects constraints/forces, it does not replace movement ownership.
- Prefer explicit contracts and typed signals over implicit node-path coupling.
- Keep this note file pruned; remove stale guidance quickly.

---
