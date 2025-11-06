import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:_2048/core/l10n/app_localizations.dart';
import 'package:_2048/features/game/presentation/bloc/game_bloc.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<GameBloc>().state;

    if (state is GameLoaded) {
      return Column(
        children: [
          Text(
            l10n.appTitle,
            style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
          ),
          Text(l10n.scoreLabel(state.gameBoard.score)),
          Text(l10n.highScoreLabel(state.highScore)),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
