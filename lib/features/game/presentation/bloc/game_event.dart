part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameStartEvent extends GameEvent {}

class GameMoveEvent extends GameEvent {
  final MoveDirection direction;

  const GameMoveEvent(this.direction);

  @override
  List<Object> get props => [direction];
}

class CheckGameOverEvent extends GameEvent {}

class NewGameEvent extends GameEvent {}
