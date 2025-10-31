import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:_2048/features/game/domain/entities/game_board.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';
import 'package:_2048/features/game/domain/usecases/move_tiles.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final MoveTilesUseCase moveTiles;
  final GameRepository repository;

  GameBloc({required this.moveTiles, required this.repository}) : super(GameInitial()) {
    on<GameStarted>(_onGameStarted);
    on<GameMoved>(_onGameMoved);
  }

  Future<void> _onGameStarted(GameStarted event, Emitter<GameState> emit) async {
    final newBoard = await repository.newGame();
    emit(GameLoaded(newBoard));
  }

  Future<void> _onGameMoved(GameMoved event, Emitter<GameState> emit) async {
    if (state is GameLoaded) {
      final currentBoard = (state as GameLoaded).gameBoard;
      final newBoard = await moveTiles(currentBoard, event.direction);
      emit(GameLoaded(newBoard));
    }
  }
}
