# 2048 Development Guidelines

Last updated: 2025-11-07

This document provides a consolidated overview of the technologies, architectural patterns, and commands used in this project, based on all implemented features.

## Active Technologies

- **Primary Stack**: Dart (with Flutter SDK)
- **UI Framework**: Flutter
- **Game Engine**: Flame
- **Audio**: flame_audio
- **State Management**: flutter_bloc (BLoC)
- **Routing**: go_router
- **Local Database**: Drift
- **Dependency Injection**: get_it
- **Code Generation**: flutter_gen (for assets), build_runner (for Drift)
- **Localization**: flutter_localizations

## Project Structure

The project follows the standard Flutter layout:

```text
lib/
  ├── core/         # Core components: DI, routing, database
  ├── features/     # Feature-based modules (e.g., game, settings)
  ├── generated/    # Auto-generated files
  └── main.dart     # App entry point
test/
  └── ...           # Unit and widget tests
```

## Commands

- **Install Dependencies**: `flutter pub get`
- **Run Code Generation**: `dart run build_runner build --delete-conflicting-outputs`
- **Analyze Code**: `flutter analyze`
- **Run Tests**: `flutter test`

## Code Style

- **Primary**: Follow standard Dart and Flutter conventions.
- **Strict Linting**: All code **must** strictly adhere to the rules defined in `analysis_options.yaml`. Pay close attention to `public_member_api_docs`, `directives_ordering`, and `require_trailing_commas`.

## Feature History
- **006-persistent-game-modes**: Added persistent game modes, allowing players to select board sizes (4x4, 5x5, 6x6) and tracking high scores independently for each mode.
- **005-gameplay-enhancements**: Added audio controls, settings persistence, and a replay button.
- **004-save-game-state**: Implemented local persistence for game state using Drift.
- **003-game-over-screen**: Added the game over UI and logic.
- **002-intuitive-input**: Implemented gesture-based controls for the game board.
- **001-2048-puzzle-game**: Established the initial project structure and core 2048 game logic using Flutter, Flame, and BLoC.

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->