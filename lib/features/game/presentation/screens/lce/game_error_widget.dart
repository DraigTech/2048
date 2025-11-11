import 'package:draig_2048/core/l10n/app_localizations.dart';
import 'package:draig_2048/features/game/presentation/bloc/game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that displays an error message and a retry button.
class GameErrorWidget extends StatelessWidget {
  /// Creates a [GameErrorWidget] instance.
  const GameErrorWidget({
    required this.errorMessage,
    super.key,
  });

  /// The error message to display.
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Dispatch event to retry loading the game
              context.read<GameBloc>().add(GameStartEvent());
            },
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}
