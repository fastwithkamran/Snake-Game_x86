# Snake-Game_x86

A console Snake game written in x86 assembly (MASM, Irvine32 library) for the Windows console.

## Gameplay

Guide the snake around a 40×20 playfield, collect food, and avoid collisions. Eating food grows the snake and increases the score. The game is won after eating 20 food items.

## Game Modes

- **Border:** hitting the playfield border or the snake's body ends the game.
- **Borderless:** the snake wraps from each edge to the opposite side. Hitting the snake's body ends the game.

## Controls

| Key | Action |
|---|---|
| Arrow keys | Move the snake |
| `1` | Select Border mode |
| `2` | Select Borderless mode |
| `3` | Exit the game |

The snake cannot immediately reverse direction.

## Architecture

| File | Responsibility |
|---|---|
| `main.asm` | Menu, game loop, rendering setup, movement, collision, and input |

The game uses a 40×20 playfield, a maximum length of 21 segments, randomized food, and a fixed movement delay.

## Build and Run

1. Install Visual Studio with C++ and MASM build support.
2. Install the Irvine32 library at `C:\Irvine`.
3. Open `Snake-Game.sln`.
4. Select the **Debug | Win32** configuration.
5. Build and run the project.

The Visual Studio project links `Irvine32.lib` and adds `C:\Irvine` as an include and library path.
