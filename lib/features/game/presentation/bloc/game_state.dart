part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

class GameInitial extends GameState {}

class GameLoaded extends GameState {
  final GameBoard gameBoard;

  const GameLoaded(this.gameBoard);

  @override
  List<Object> get props => [gameBoard];
}

class GameOver extends GameState {}
