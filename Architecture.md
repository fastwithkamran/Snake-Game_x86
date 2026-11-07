# Snake-Game_x86: Architecture

Console Snake in x86 assembly (MASM, Irvine32) for the Windows console.
Playfield is 40x20. Speed rises with score. Game ends on self-collision, or on a win at maximum length.

## Modules

| File | Responsibility |
|---|---|
| `main.asm` | Entry point and game loop |
| `data.inc` | Constants and shared state |
| `input.inc` | Input, pause, quit, restart, speed, menu handling |
| `snake.inc` | Movement, edge handling, collision, growth |
| `display.inc` | Rendering, food, menu and status screens, game over |

## Module diagram

```mermaid
flowchart TD
    main["main.asm<br/>entry point, game loop"]
    input["input.inc<br/>keys, menu, pause, speed"]
    snake["snake.inc<br/>move, collide, grow"]
    display["display.inc<br/>render, food, screens"]
    data[("data.inc<br/>constants + shared state")]

    main --> input
    main --> snake
    main --> display
    input <--> data
    snake <--> data
    display <--> data
    main <--> data
```

## Key rule: shared state, not registers

Modules do not pass values through registers. They read and write shared variables defined in `data.inc`.
Because of this, **every procedure must save and restore any register it uses** (`pushad` / `popad`).

## Frame order (fixed)

```mermaid
flowchart LR
    A["1. Input<br/>input.inc"] --> B["2. Move<br/>snake.inc"]
    B --> C["3. Edge handling<br/>snake.inc"]
    C --> D["4. Self-collision<br/>snake.inc"]
    D --> E["5. Food<br/>display.inc + snake.inc"]
    E --> F["6. Render<br/>display.inc"]
    F --> G["7. Delay<br/>main.asm"]
    G -.next frame.-> A
```

Do not reorder these stages. For example, edge handling must run before the collision check.

## Game modes

| Mode | Behavior |
|---|---|
| Walls enabled | Touching the border ends the game |
| Walls disabled | Snake wraps to the opposite side |

Self-collision ends the game in both modes.

## Suggested shared state in `data.inc`

Final names are decided on day 1 by all three. Starting list:

| Group | Variables |
|---|---|
| Constants | `FIELD_W = 40`, `FIELD_H = 20`, `MAX_LEN`, `BASE_DELAY`, `MIN_DELAY` |
| Snake | `snakeX[]`, `snakeY[]`, `snakeLen`, `direction`, `nextDirection` |
| Food | `foodX`, `foodY`, `foodEaten` flag |
| Game | `score`, `delayMs`, `wallsEnabled`, `gameState` (menu / running / paused / over / won) |
| Flags | `quitRequested`, `restartRequested`, `collisionFlag` |

## Controls

| Key | Action |
|---|---|
| W / A / S / D or arrow keys | Steer |
| P | Pause / resume |
| Q | Quit |
