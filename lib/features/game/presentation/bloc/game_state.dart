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

  const GameLoaded(this.gameBoard, {required this.highScore});

  @override
  List<Object> get props => [gameBoard, highScore];
}

class GameOver extends GameState {}
