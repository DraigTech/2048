import 'package:bloc_test/bloc_test.dart';
import 'package:draig_2048/core/l10n/app_localizations_en.dart';
import 'package:draig_2048/features/settings/domain/entities/audio_settings.dart';
import 'package:draig_2048/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:draig_2048/features/settings/presentation/widgets/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

void main() {

  group('SettingsDialog', () {
    late MockSettingsBloc mockSettingsBloc;
    late AppLocalizationsEn l10n;

    setUp(() {
      mockSettingsBloc = MockSettingsBloc();
      l10n = AppLocalizationsEn();
    });

    testWidgets('renders correctly with initial settings', (tester) async {
      when(() => mockSettingsBloc.state).thenReturn(
        const SettingsLoaded(
              AudioSettings(isMusicEnabled: true, isSoundEffectsEnabled: false),
            )
            as SettingsState Function(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SettingsBloc>.value(
            value: mockSettingsBloc,
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => const SettingsDialog(),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(l10n.settingsTitle), findsOneWidget);
      expect(find.text(l10n.backgroundMusic), findsOneWidget);
      expect(find.text(l10n.soundEffects), findsOneWidget);
      expect(find.byType(SwitchListTile), findsNWidgets(2));

      // Verify initial switch states
      final musicSwitch = tester.widget<SwitchListTile>(
        find.byKey(const Key('music_switch')),
      );
      expect(musicSwitch.value, isTrue);
      final soundEffectsSwitch = tester.widget<SwitchListTile>(
        find.byKey(const Key('sound_effects_switch')),
      );
      expect(soundEffectsSwitch.value, isFalse);
    });

    testWidgets('dispatches ToggleMusic event when music switch is toggled', (
      tester,
    ) async {
      whenListen(
        mockSettingsBloc,
        Stream.fromIterable([
          const SettingsLoaded(
            AudioSettings(isMusicEnabled: true, isSoundEffectsEnabled: true),
          ),
          const SettingsLoaded(
            AudioSettings(isMusicEnabled: false, isSoundEffectsEnabled: true),
          ),
        ]),
        initialState: const SettingsLoaded(
          AudioSettings(isMusicEnabled: true, isSoundEffectsEnabled: true),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SettingsBloc>.value(
            value: mockSettingsBloc,
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => const SettingsDialog(),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('music_switch')));
      await tester.pumpAndSettle();

      verify(
        () => mockSettingsBloc.add(const ToggleMusic(isMusicEnabled: false)),
      ).called(1);
    });

    testWidgets(
      'dispatches ToggleSoundEffects event when '
      'sound effects switch is toggled',
      (tester) async {
        whenListen(
          mockSettingsBloc,
          Stream.fromIterable([
            const SettingsLoaded(
              AudioSettings(isMusicEnabled: true, isSoundEffectsEnabled: true),
            ),
            const SettingsLoaded(
              AudioSettings(isMusicEnabled: true, isSoundEffectsEnabled: false),
            ),
          ]),
          initialState: const SettingsLoaded(
            AudioSettings(isMusicEnabled: true, isSoundEffectsEnabled: true),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<SettingsBloc>.value(
              value: mockSettingsBloc,
              child: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => const SettingsDialog(),
                  ),
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('sound_effects_switch')));
        await tester.pumpAndSettle();

        verify(
          () => mockSettingsBloc.add(
            const ToggleSoundEffects(isSoundEffectsEnabled: false),
          ),
        ).called(1);
      },
    );
  });
}
