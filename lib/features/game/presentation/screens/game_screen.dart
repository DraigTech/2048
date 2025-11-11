import 'dart:async';

import 'package:draig_2048/core/l10n/app_localizations.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';
import 'package:draig_2048/features/game/presentation/bloc/game_bloc.dart';
import 'package:draig_2048/features/game/presentation/widgets/game_board_widget.dart';
import 'package:draig_2048/features/game/presentation/widgets/input_handler.dart';
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
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(l10n.gameOver),
                  content: Text(l10n.scoreLabel(state.gameBoard.score)),
                  actions: <Widget>[
                    TextButton(
                      child: Text(l10n.playAgain),
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.read<GameBloc>().add(NewGameEvent());
                        gameBoardFocus.requestFocus();
                      },
                    ),
                  ],
                );
              },
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            switch (state) {
              case GameInitial():
                context.read<GameBloc>().add(GameStartEvent());
                return const Center(child: CircularProgressIndicator());
              case GameLoaded():
                return GameContent(
                  state: state,
                  gameBoardFocus: gameBoardFocus,
                  appTitle: l10n.appTitle,
                  scoreLabel: l10n.scoreLabel(state.gameBoard.score),
                  highScoreLabel: l10n.highScoreLabel(state.highScore),
                );
              default:
                return Center(child: Text(l10n.unknownState));
            }
          },
        ),
      ),
    );
  }
}

/// A widget that displays the game content, including the game board and score.
class GameContent extends StatelessWidget {
  /// Creates a [GameContent] instance.
  const GameContent({
    required this.state,
    required this.gameBoardFocus,
    required this.appTitle,
    required this.scoreLabel,
    required this.highScoreLabel,
    super.key,
  });

  /// The current game state.
  final GameLoaded state;

  /// The focus node for the game board, used for handling keyboard input.
  final FocusNode gameBoardFocus;

  /// The title of the application.
  final String appTitle;

  /// The label displaying the current score.
  final String scoreLabel;

  /// The label displaying the high score.
  final String highScoreLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final gameBoardSize = isWide
            ? constraints.maxHeight * 0.8
            : constraints.maxWidth * 0.9;

        if (isWide) {
          // Wide layout
          return Row(
            children: [_gameBoard(context, gameBoardSize), _scoreDisplay()],
          );
        } else {
          // Narrow layout
          return Column(
            children: [_scoreDisplay(), _gameBoard(context, gameBoardSize)],
          );
        }
      },
    );
  }

  /// Builds the game board widget.
  Widget _gameBoard(BuildContext context, double gameBoardSize) => Expanded(
    child: Center(
      child: InputHandler(
        focusNode: gameBoardFocus,
        moveUp: () =>
            context.read<GameBloc>().add(const GameMoveEvent(MoveDirection.up)),
        moveDown: () => context.read<GameBloc>().add(
          const GameMoveEvent(MoveDirection.down),
        ),
        moveLeft: () => context.read<GameBloc>().add(
          const GameMoveEvent(MoveDirection.left),
        ),
        moveRight: () => context.read<GameBloc>().add(
          const GameMoveEvent(MoveDirection.right),
        ),
        child: GameBoardWidget(
          gameBoard: state.gameBoard,
          gameBoardSize: gameBoardSize,
        ),
      ),
    ),
  );

  /// Builds the score display widget.
  Widget _scoreDisplay() => Column(
    children: [
      Text(
        appTitle,
        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      ),
      Text(scoreLabel),
      Text(highScoreLabel),
    ],
  );
}
