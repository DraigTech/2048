part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameStarted extends GameEvent {}

class GameMoved extends GameEvent {
  final Direction direction;

  const GameMoved(this.direction);

  @override
  List<Object> get props => [direction];
}
