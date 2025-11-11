part of 'game_bloc.dart';

/// Abstract base class for all game-related events.
abstract class GameEvent extends Equatable {
  /// Creates a [GameEvent] instance.
  const GameEvent();

  @override
  List<Object> get props => [];
}

/// Event indicating that the game should start.
class GameStartEvent extends GameEvent {}

/// Event indicating a tile movement in a specific [direction].
class GameMoveEvent extends GameEvent {
  /// Creates a [GameMoveEvent] with the given [direction].
  const GameMoveEvent(this.direction);

  /// The direction of the tile movement.
  final MoveDirection direction;

  @override
  List<Object> get props => [direction];
}

/// Event to trigger a check for game over conditions.
class CheckGameOverEvent extends GameEvent {}

/// Event to start a new game.
class NewGameEvent extends GameEvent {}

/// Event to trigger saving the current game state.
class SaveGameEvent extends GameEvent {}
