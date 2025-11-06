import 'package:_2048/core/l10n/app_localizations.dart';
import 'package:_2048/features/game/presentation/widgets/direction_buttons_widget.dart';
import 'package:_2048/features/game/presentation/widgets/score_display_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:_2048/features/game/presentation/bloc/game_bloc.dart';
import 'package:_2048/features/game/presentation/widgets/game_board_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          switch (state) {
            case GameInitial():
              context.read<GameBloc>().add(GameStarted());
              return const Center(child: CircularProgressIndicator());
            case GameLoaded():
              return GameContent(state: state);
            case GameOver():
              return Center(child: Text(l10n.gameOver));
            default:
              return Center(child: Text(l10n.unknownState));
          }
        },
      ),
    );
  }
}

class GameContent extends StatelessWidget {
  const GameContent({super.key, required this.state});

  final GameLoaded state;

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
            children: [
              Expanded(
                child: Center(
                  child: GameBoardWidget(
                    gameBoard: state.gameBoard,
                    gameBoardSize: gameBoardSize,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    ScoreDisplay(),
                    SizedBox(height: 20),
                    DirectionButtons(),
                  ],
                ),
              ),
            ],
          );
        } else {
          // Narrow layout
          return Column(
            children: [
              const ScoreDisplay(),
              Expanded(
                child: Center(
                  child: GameBoardWidget(
                    gameBoard: state.gameBoard,
                    gameBoardSize: gameBoardSize,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: DirectionButtons(),
              ),
            ],
          );
        }
      },
    );
  }
}
