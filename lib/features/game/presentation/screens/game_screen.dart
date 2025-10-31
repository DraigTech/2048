import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';
import 'package:_2048/features/game/presentation/bloc/game_bloc.dart';
import 'package:_2048/features/game/presentation/widgets/game_board_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2048 Game'),
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state is GameInitial) {
            context.read<GameBloc>().add(GameStarted());
            return const Center(child: CircularProgressIndicator());
          } else if (state is GameLoaded) {
            return Column(
              children: [
                Text('Score: ${state.gameBoard.score}'),
                Text('High Score: ${state.highScore}'),
                Expanded(
                  child: Center(
                    child: GameBoardWidget(gameBoard: state.gameBoard),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: Direction.values.map((direction) {
                    return ElevatedButton(
                      onPressed: () => context.read<GameBloc>().add(GameMoved(direction)),
                      child: Text(direction.name),
                    );
                  }).toList(),
                ),
              ],
            );
          } else if (state is GameOver) {
            return const Center(child: Text('Game Over!'));
          }
          return const Center(child: Text('Unknown State'));
        },
      ),
    );
  }
}
