# Implementation Plan: Intuitive Input Methods

**Branch**: `002-intuitive-input` | **Date**: 2025-11-06 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/Users/hiep.nguyen/StudioProjects/2048/specs/002-intuitive-input/spec.md`

## Summary

This feature will replace the current on-screen button controls with more intuitive and platform-appropriate input methods. On mobile devices, users will be able to swipe on the game board to move the tiles. On desktop and web platforms, users will be able to use the arrow and WASD keys. These new input methods will be implemented using Flutter's `GestureDetector` and `RawKeyboardListener` widgets. Both input methods will dispatch `GameMoveEvent` events to the existing `GameBloc` to trigger the game logic.

## Technical Context

**Language/Version**: Dart (with Flutter SDK)
**Primary Dependencies**: flutter_bloc
**Storage**: N/A
**Testing**: flutter_test
**Target Platform**: iOS, Android, Web, Desktop
**Project Type**: Single project (Flutter)
**Performance Goals**: 60 fps during animations and interactions.
**Constraints**: N/A
**Scale/Scope**: This feature is scoped to the 2048 game and does not introduce new data models or APIs.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

N/A - The constitution is a template.

## Project Structure

### Documentation (this feature)

```text
specs/002-intuitive-input/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── features/
│   └── game/
│       ├── presentation/
│       │   ├── bloc/
│       │   │   ├── game_bloc.dart
│       │   │   └── game_event.dart
│       │   └── widgets/
│       │       ├── game_board.dart
│       │       └── input_handler.dart # New widget
└── main.dart

test/
└── features/
    └── game/
        └── presentation/
            └── bloc/
                └── game_bloc_test.dart
```

**Structure Decision**: The existing project structure will be used. A new `input_handler.dart` widget will be created to encapsulate the swipe and keyboard input logic. This widget will wrap the `game_board.dart` and dispatch events to the `GameBloc`.

## Complexity Tracking

N/A