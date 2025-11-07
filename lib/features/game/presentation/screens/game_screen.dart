import 'package:_2048/core/l10n/app_localizations.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:_2048/features/game/presentation/bloc/game_bloc.dart';
import 'package:_2048/features/game/presentation/widgets/game_board_widget.dart';
import 'package:_2048/features/game/presentation/widgets/input_handler.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gameBoardFocus = FocusNode();

    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {
        if (state is GameLoaded && state.isGameOver) {
          gameBoardFocus.unfocus();

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

class GameContent extends StatelessWidget {
  const GameContent({
    super.key,
    required this.state,
    required this.gameBoardFocus,
    required this.appTitle,
    required this.scoreLabel,
    required this.highScoreLabel,
  });

  final GameLoaded state;
  final FocusNode gameBoardFocus;
  final String appTitle;
  final String scoreLabel;
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
            children: [gameBoard(context, gameBoardSize), scoreDisplay()],
          );
        } else {
          // Narrow layout
          return Column(
            children: [scoreDisplay(), gameBoard(context, gameBoardSize)],
          );
        }
      },
    );
  }

  Widget gameBoard(BuildContext context, double gameBoardSize) => Expanded(
    child: Center(
      child: InputHandler(
        focusNode: gameBoardFocus,
        moveUp: () =>
            context.read<GameBloc>().add(GameMoveEvent(MoveDirection.up)),
        moveDown: () =>
            context.read<GameBloc>().add(GameMoveEvent(MoveDirection.down)),
        moveLeft: () =>
            context.read<GameBloc>().add(GameMoveEvent(MoveDirection.left)),
        moveRight: () =>
            context.read<GameBloc>().add(GameMoveEvent(MoveDirection.right)),
        child: GameBoardWidget(
          gameBoard: state.gameBoard,
          gameBoardSize: gameBoardSize,
        ),
      ),
    ),
  );

  Widget scoreDisplay() => Column(
    children: [
      Text(
        appTitle,
        style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
      ),
      Text(scoreLabel),
      Text(highScoreLabel),
    ],
  );
}
