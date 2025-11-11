import 'dart:async';
import 'dart:developer' as developer;

import 'package:draig_2048/core/l10n/app_localizations.dart';
import 'package:draig_2048/features/game/presentation/bloc/game_bloc.dart';
import 'package:draig_2048/features/game/presentation/screens/lce/game_content_widget.dart';
import 'package:draig_2048/features/game/presentation/screens/lce/game_error_widget.dart';
import 'package:draig_2048/features/game/presentation/screens/lce/game_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The main screen for the 2048 game.
///
/// This widget is responsible for building the game UI, handling game events,
/// and displaying game-related information such as score and game over status.
class GameScreen extends StatefulWidget {
  /// Creates a [GameScreen] instance.
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late final FocusNode gameBoardFocus;

  @override
  void initState() {
    super.initState();
    gameBoardFocus = FocusNode();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    gameBoardFocus.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      context.read<GameBloc>().add(SaveGameEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {
        if (state is GameLoaded && state.isGameOver) {
          gameBoardFocus.unfocus();
          unawaited(
            _showGameOverDialog(context, state.gameBoard.score).then(
              (playAgain) {
                if (context.mounted && (playAgain ?? false)) {
                  context.read<GameBloc>().add(NewGameEvent());
                }
              },
            ),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            switch (state) {
              case GameInitial():
                context.read<GameBloc>().add(GameStartEvent());
                return const GameLoadingWidget();
              case GameLoaded():
                return GameContentWidget(
                  state: state,
                  gameBoardFocus: gameBoardFocus,
                );
              case GameError():
                developer.log(state.message);
                return GameErrorWidget(errorMessage: l10n.loadGameFailed);
            }
          },
        ),
      ),
    );
  }
}

Future<bool?> _showGameOverDialog(BuildContext context, int score) async {
  final l10n = AppLocalizations.of(context);

  if (l10n == null) {
    return null;
  }

  return showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          l10n.gameOverTitle,
          textAlign: TextAlign.center,
        ),
        content: Text(
          l10n.gameOverScoreMessage(score),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(l10n.cancel),
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
          ),
          ElevatedButton(
            child: Text(l10n.playAgain),
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
      );
    },
  );
}
