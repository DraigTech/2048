part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

class GameInitial extends GameState {}

class GameLoaded extends GameState {
  final GameBoard gameBoard;
  final int highScore;
  final bool isGameOver;

  const GameLoaded(this.gameBoard, {required this.highScore, this.isGameOver = false});

  @override
  List<Object> get props => [gameBoard, highScore, isGameOver];
}
