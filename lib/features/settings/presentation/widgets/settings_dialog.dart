import 'package:draig_2048/core/l10n/app_localizations.dart';
import 'package:draig_2048/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A dialog that allows the user to configure audio settings.
class SettingsDialog extends StatelessWidget {
  /// Creates a [SettingsDialog] instance.
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        l10n.settingsTitle,
        textAlign: TextAlign.center,
      ),
      content: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          switch (state) {
            case SettingsInitial():
              context.read<SettingsBloc>().add(const LoadSettings());
              return const Text('loading');
            case SettingsLoaded():
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    key: const Key('music_switch'),
                    title: Text(l10n.backgroundMusic),
                    value: state.settings.isMusicEnabled,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                        ToggleMusic(isMusicEnabled: value),
                      );
                    },
                  ),
                  SwitchListTile(
                    key: const Key('sound_effects_switch'),
                    title: Text(l10n.soundEffects),
                    value: state.settings.isSoundEffectsEnabled,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                        ToggleSoundEffects(isSoundEffectsEnabled: value),
                      );
                    },
                  ),
                ],
              );
            case SettingsError():
              return Text(state.message);
          }
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
