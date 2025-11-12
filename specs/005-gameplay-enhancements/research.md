# Research: Gameplay Enhancements

**Feature**: Gameplay Enhancements
**Date**: 2025-11-12

This document outlines the research conducted to confirm the technical approach for implementing the gameplay enhancements feature.

## 1. Audio Playback in Flame

### Topic
Best practices for managing background music and sound effects in a Flutter game using the Flame engine.

### Findings
-   **Library Choice**: The project already includes the `flame_audio` package. This is the recommended library for audio in Flame games as it is maintained by the Flame team and integrates seamlessly with the game loop. It provides simple APIs for playing, looping, and stopping audio.
-   **Background Music**: For background music, `FlameAudio.loop()` is the ideal method. It's efficient and handles the looping internally.
-   **Sound Effects**: For short, one-off sound effects like tile moves or merges, `FlameAudio.play()` is the correct choice. It's optimized for low-latency playback of short audio clips.
-   **Lifecycle Management**: `flame_audio` automatically handles pausing and resuming audio when the app's lifecycle state changes (e.g., when the app is backgrounded), which satisfies the edge case identified in the specification.

### Decision
-   **Decision**: Use the `flame_audio` package for all audio playback.
-   **Rationale**: It is already a project dependency, is designed specifically for Flame, and provides the necessary functionality for both background music and sound effects while handling OS-level audio lifecycle events automatically.
-   **Alternatives Considered**: Using `audioplayers` directly. This was rejected because `flame_audio` provides a higher-level, more convenient API tailored for game development and is already integrated.

## 2. Settings Persistence with Drift and BLoC

### Topic
Best practices for integrating a `BLoC` with a `Drift`-backed repository for persisting user settings.

### Findings
-   **Pattern**: The standard and recommended pattern is the Repository Pattern, which the user's plan already suggests.
    -   The **UI Layer** (e.g., the Settings `AlertDialog`) dispatches events to the `SettingsBloc`.
    -   The **BLoC Layer** (`SettingsBloc`) processes these events, updates its state, and calls methods on the `SettingsRepository`.
    -   The **Repository Layer** (`SettingsRepository`) is responsible for abstracting the data source. It will contain methods like `getSettings()` and `saveSettings(settings)`.
    -   The **Data Layer** (`Drift` database) is where the repository persists the data. The repository will interact with the Drift-generated DAO classes.
-   **Initialization**: The `SettingsBloc` should be initialized by reading the current settings from the `SettingsRepository` to ensure the UI reflects the persisted state on startup. The repository, in turn, will fetch from the Drift database.
-   **Dependency Injection**: Using `get_it` to provide a singleton instance of the `SettingsRepository` and a lazy singleton or factory for the `SettingsBloc` is the correct approach to ensure a single source of truth and a decoupled architecture.

### Decision
-   **Decision**: Implement the `SettingsBloc` and `SettingsRepository` pattern as described above.
-   **Rationale**: This pattern is already established in the project, aligns with `flutter_bloc` best practices, and creates a clean separation of concerns between UI, business logic, and data persistence.
-   **Alternatives Considered**: Having the BLoC interact directly with the database. This was rejected as it violates the separation of concerns and makes the BLoC harder to test and maintain.