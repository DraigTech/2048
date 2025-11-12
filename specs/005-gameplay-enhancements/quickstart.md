# Quickstart: Gameplay Enhancements

**Feature**: Gameplay Enhancements
**Date**: 2025-11-12

This guide provides a high-level overview of the steps required to implement the Gameplay Enhancements feature.

## 1. Asset Management

1.  **Add Music File**: Source a suitable, royalty-free "relaxing" background music track.
2.  **Save Asset**: Save it as `background_music.mp3` inside the `assets/audio/` directory.
3.  **Verify `pubspec.yaml`**: Ensure the `assets/audio/` directory is listed under `flutter.assets`. It already is, so no changes are needed here.

## 2. Persistence Layer (Drift)

1.  **Create Settings Table**: Define a new table in a drift file (e.g., `lib/core/database/database.dart`) for `AudioSettings` with `isMusicEnabled` and `isSoundEffectsEnabled` boolean columns.
2.  **Generate Code**: Run `dart run build_runner build --delete-conflicting-outputs` to generate the necessary Drift table info and DAO classes.
3.  **Create Repository**: Create `lib/features/settings/data/settings_repository.dart`.
    -   It should take the database as a dependency.
    -   Implement methods like `Future<AudioSettings> getSettings()` and `Future<void> saveSettings(AudioSettings settings)`.

## 3. State Management (BLoC)

1.  **Create Settings BLoC**: Create `lib/features/settings/application/settings_bloc.dart`.
2.  **Define States**: Create states for `SettingsState` (e.g., `SettingsInitial`, `SettingsLoaded`). The `SettingsLoaded` state will hold the `AudioSettings` object.
3.  **Define Events**: Create events like `LoadSettings`, `ToggleMusic`, and `ToggleSoundEffects`.
4.  **Implement BLoC**:
    -   The `SettingsBloc` will take the `SettingsRepository` as a dependency.
    -   On `LoadSettings`, it will call the repository to get the settings and emit `SettingsLoaded`.
    -   On `ToggleMusic` / `ToggleSoundEffects`, it will update its state optimistically, then call the repository to save the new settings.

## 4. UI Layer (Flutter & Flame)

1.  **Add Icons**: In the main game screen widget (likely within the `Game` widget's overlay), add two `IconButton` widgets:
    -   An `IconButton` with `Icons.settings`.
    -   An `IconButton` with `Icons.replay`.
2.  **Implement Replay**:
    -   The `onPressed` for the replay button should show an `AlertDialog` for confirmation.
    -   If confirmed, it should dispatch a `GameReset` event to the `GameBloc`. A new event and handler will need to be added to the `GameBloc`.
3.  **Implement Settings Dialog**:
    -   The `onPressed` for the settings button should show an `AlertDialog`.
    -   The dialog's content should be a `BlocProvider` for the `SettingsBloc`.
    -   Inside, use a `BlocBuilder` to display two `SwitchListTile` widgets, one for "Background Music" and one for "Sound Effects".
    -   The `onChanged` callback of each `SwitchListTile` should add the corresponding event (`ToggleMusic` or `ToggleSoundEffects`) to the `SettingsBloc`.

## 5. Audio Integration (flame_audio)

1.  **Create an Audio Manager**: Consider creating a simple singleton or a class provided by `get_it` to manage audio playback logic. Let's call it `AudioManager`.
2.  **Integrate with Settings**: The `AudioManager` should listen to state changes from the `SettingsBloc`.
3.  **Play Background Music**: When the `SettingsBloc` state has `isMusicEnabled: true`, the `AudioManager` should call `FlameAudio.loop('background_music.mp3')`. When `false`, it should call `FlameAudio.bgm.stop()`.
4.  **Play Sound Effects**: Modify the parts of the code that currently play move/merge sounds. Before calling `FlameAudio.play()`, check the `SettingsBloc`'s state to see if `isSoundEffectsEnabled` is `true`.

## 6. Dependency Injection (get_it)

1.  **Register Dependencies**: In your `get_it` setup file (e.g., `lib/core/di/injection.dart`):
    -   Register the `SettingsRepository` as a singleton.
    -   Register the `SettingsBloc` as a lazy singleton or factory, providing it with the `SettingsRepository`.
    -   Register the `AudioManager` if you created one.
2.  **Initialize**: Ensure that the `LoadSettings` event is added to the `SettingsBloc` when the app starts so that the persisted settings are loaded into the state. This can be done right after the BLoC is registered or when the main app widget is initialized.