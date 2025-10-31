import 'package:_2048/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';
import 'package:_2048/features/game/presentation/bloc/game_bloc.dart';
import 'package:_2048/features/game/presentation/widgets/game_board_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state is GameInitial) {
            context.read<GameBloc>().add(GameStarted());
            return const Center(child: CircularProgressIndicator());
          } else if (state is GameLoaded) {
            return Column(
              children: [
                Text(l10n.scoreLabel(state.gameBoard.score)),
                Text(l10n.highScoreLabel(state.highScore)),
                Expanded(
                  child: Center(
                    child: GameBoardWidget(gameBoard: state.gameBoard),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: Direction.values.map((direction) {
                      return ElevatedButton(
                        onPressed: () =>
                            context.read<GameBloc>().add(GameMoved(direction)),
                        child: Text(direction.name),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          } else if (state is GameOver) {
            return Center(child: Text(l10n.gameOver));
          }
          return Center(child: Text(l10n.unknownState));
        },
      ),
    );
  }
}
