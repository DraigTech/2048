import 'dart:math';

import 'package:draig_2048/core/assets/assets.gen.dart';
import 'package:draig_2048/core/l10n/app_localizations.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';
import 'package:draig_2048/features/game/presentation/bloc/game_bloc.dart';
import 'package:draig_2048/features/game/presentation/widgets/game_board_widget.dart';
import 'package:draig_2048/features/game/presentation/widgets/game_button_widget.dart';
import 'package:draig_2048/features/game/presentation/widgets/game_score_widget.dart';
import 'package:draig_2048/features/game/presentation/widgets/image_border_widget.dart';
import 'package:draig_2048/features/game/presentation/widgets/input_handler_widget.dart';
import 'package:draig_2048/features/settings/presentation/widgets/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that displays the game content, including the game board and score.
class GameContentWidget extends StatelessWidget {
  /// Creates a [GameContentWidget] instance.
  const GameContentWidget({
    required this.state,
    required this.gameBoardFocus,
    super.key,
  });

  /// The current game state.
  final GameLoaded state;

  /// The focus node for the game board, used for handling keyboard input.
  final FocusNode gameBoardFocus;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final gameBoardSize = isWide
            ? min(constraints.maxWidth * 0.4, constraints.maxHeight * 0.9)
            : min(constraints.maxHeight * 0.4, constraints.maxWidth * 0.9);
        final logoSize = Size(
          gameBoardSize * 0.4 + 10,
          gameBoardSize * 0.4 + 10,
        );
        final scoreSize = Size(gameBoardSize * 0.25, gameBoardSize * 0.25);
        final buttonSize = Size(gameBoardSize * 0.25, gameBoardSize * 0.15);

        final l10n = AppLocalizations.of(context)!;

        Widget gameBoard() => InputHandlerWidget(
          focusNode: gameBoardFocus,
          moveUp: () => context.read<GameBloc>().add(
            const GameMoveEvent(MoveDirection.up),
          ),
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
            gridSize: state.boardSize,
          ),
        );

        Widget appIcon() => ImageBorderWidget(
          image: Assets.images.appIcon.provider(),
          size: logoSize,
        );

        GameScoreWidget gameScore() => GameScoreWidget(
          size: scoreSize,
          scoreLabel: l10n.scoreLabel,
          score: state.gameBoard.score.toString(),
        );

        GameScoreWidget gameHighScore() => GameScoreWidget(
          size: scoreSize,
          scoreLabel: l10n.highScoreLabel,
          score: state.highScore.toString(),
        );

        GameButtonWidget replayButton() => GameButtonWidget(
          size: buttonSize,
          icon: Icons.replay,
          onPressed: () {
            context.read<GameBloc>().add(GameResetEvent());
          },
        );

        GameButtonWidget settingsButton() => GameButtonWidget(
          size: buttonSize,
          icon: Icons.settings,
          onPressed: () async {
            await showDialog<void>(
              context: context,
              builder: (dialogContext) => const SettingsDialog(),
            );
          },
        );

        Widget scoreWideLayout() => Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            appIcon(),
            Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                gameScore(),
                gameHighScore(),
              ],
            ),
            Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                replayButton(),
                settingsButton(),
              ],
            ),
          ],
        );

        Widget scoreNarrowLayout() => Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                gameScore(),
                replayButton(),
              ],
            ),
            appIcon(),
            Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                gameHighScore(),
                settingsButton(),
              ],
            ),
          ],
        );

        if (isWide) {
          // Wide layout
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 10),
                  child: gameBoard(),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: scoreWideLayout(),
                ),
              ),
            ],
          );
        } else {
          // Narrow layout
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: scoreNarrowLayout(),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 10),
                  child: gameBoard(),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
