# Snake-Game_x86

A console Snake game written in x86 assembly (MASM, Irvine32 library) for the Windows console, built by a team of three.

## Gameplay

The player steers a snake around a 40×20 playfield, eats food to grow, and avoids collisions. Speed increases with score. The game ends on self-collision, or in a win when the snake reaches maximum length.

## Game Modes

Selected from the start menu:

| Mode | Behavior |
|---|---|
| **Walls enabled** | Touching the border ends the game. |
| **Walls disabled** | The snake wraps to the opposite side. |

Self-collision ends the game in both modes.

## Controls

| Key | Action |
|---|---|
| W / A / S / D or arrow keys | Steer |
| P | Pause / resume |
| Q | Quit |

## Architecture

| File | Responsibility |
|---|---|
| `main.asm` | Entry point and game loop |
| `data.inc` | Constants and shared state |
| `input.inc` | Input, pause, quit, restart, speed, menu handling |
| `snake.inc` | Movement, edge handling, collision, growth |
| `display.inc` | Rendering, food, menu and status screens, game over |

Modules share state through `data.inc` and communicate through shared variables, not registers.

**Frame order (fixed):** input → move → edge handling → self-collision → food → render → delay.

##
