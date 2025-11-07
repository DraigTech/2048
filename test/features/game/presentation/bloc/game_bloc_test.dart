import 'package:bloc_test/bloc_test.dart';
import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/entities/high_score.dart';
import 'package:draig_2048/features/game/domain/entities/tile.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';
import 'package:draig_2048/features/game/domain/usecases/check_game_over.dart';
import 'package:draig_2048/features/game/domain/usecases/get_high_score.dart';
import 'package:draig_2048/features/game/domain/usecases/move_tiles.dart';
import 'package:draig_2048/features/game/domain/usecases/save_high_score.dart';
import 'package:draig_2048/features/game/presentation/bloc/game_bloc.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'game_bloc_test.mocks.dart';

@GenerateMocks([
  GameRepository,
  MoveTilesUseCase,
  GetHighScoreUseCase,
  SaveHighScoreUseCase,
  CheckGameOverUseCase,
])
void main() {
  late GameBloc gameBloc;
  late MockGameRepository mockGameRepository;
  late MockMoveTilesUseCase mockMoveTilesUseCase;
  late MockGetHighScoreUseCase mockGetHighScoreUseCase;
  late MockSaveHighScoreUseCase mockSaveHighScoreUseCase;
  late MockCheckGameOverUseCase mockCheckGameOverUseCase;

  // Mock the audioplayers and path_provider channels
  const audioPlayerChannel = MethodChannel(
    'xyz.luan/audioplayers',
  );
  const audioPlayerGlobalChannel = MethodChannel(
    'xyz.luan/audioplayers.global',
  );
  const pathProviderChannel = MethodChannel(
    'plugins.flutter.io/path_provider',
  );

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    FlameAudio.audioCache.prefix = '';

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(audioPlayerChannel, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'play') {
            return 1;
          } else if (methodCall.method == 'setSourceUrl') {
            return 1;
          } else if (methodCall.method == 'getDuration') {
            return 1000;
          } else if (methodCall.method == 'getPosition') {
            return 0;
          }
          return null;
        });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(audioPlayerGlobalChannel, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'init') {
            return 1;
          }
          return null;
        });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'getTemporaryDirectory') {
            return 'test/cache';
          }
          return null;
        });

    mockGameRepository = MockGameRepository();
    mockMoveTilesUseCase = MockMoveTilesUseCase();
    mockGetHighScoreUseCase = MockGetHighScoreUseCase();
    mockSaveHighScoreUseCase = MockSaveHighScoreUseCase();
    mockCheckGameOverUseCase = MockCheckGameOverUseCase();

    gameBloc = GameBloc(
      repository: mockGameRepository,
      moveTiles: mockMoveTilesUseCase,
      getHighScore: mockGetHighScoreUseCase,
      saveHighScore: mockSaveHighScoreUseCase,
      checkGameOver: mockCheckGameOverUseCase,
    );
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(audioPlayerChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(audioPlayerGlobalChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
    await gameBloc.close();
  });

  group('GameBloc', () {
    const tInitialGameBoard = GameBoard(
      tiles: [
        [?null, ?null, ?null, ?null],
        [?null, ?null, ?null, ?null],
        [?null, ?null, ?null, ?null],
        [?null, ?null, ?null, ?null],
      ],
    );
    const tMovedGameBoard = GameBoard(
      tiles: [
        [Tile(id: '1', value: 2, row: 0, column: 0), ?null, ?null, ?null],
        [?null, ?null, ?null, ?null],
        [?null, ?null, ?null, ?null],
        [?null, ?null, ?null, ?null],
      ],
    );

    test('initial state is GameInitial', () {
      expect(gameBloc.state, GameInitial());
    });

    blocTest<GameBloc, GameState>(
      'emits [GameLoaded] with initial game board and high score 0 when '
      'GameStarted and no high score',
      build: () {
        when(
          mockGameRepository.newGame(),
        ).thenAnswer((_) async => tInitialGameBoard);
        when(
          mockGetHighScoreUseCase.call(),
        ).thenAnswer((_) async => const HighScore(score: 0));
        return gameBloc;
      },
      act: (bloc) => bloc.add(GameStartEvent()),
      expect: () => [const GameLoaded(tInitialGameBoard, highScore: 0)],
    );

    blocTest<GameBloc, GameState>(
      'emits [GameLoaded] with initial game board and '
      'existing high score when GameStarted',
      build: () {
        when(
          mockGameRepository.newGame(),
        ).thenAnswer((_) async => tInitialGameBoard);
        when(
          mockGetHighScoreUseCase.call(),
        ).thenAnswer((_) async => const HighScore(score: 100));
        return gameBloc;
      },
      act: (bloc) => bloc.add(GameStartEvent()),
      expect: () => [const GameLoaded(tInitialGameBoard, highScore: 100)],
    );

    blocTest<GameBloc, GameState>(
      'emits [GameLoaded] with updated game board when GameMoved and no merge',
      build: () {
        when(
          mockMoveTilesUseCase.call(any, any),
        ).thenAnswer((_) async => (tMovedGameBoard, false));
        when(mockCheckGameOverUseCase.call(any)).thenAnswer((_) async => false);
        gameBloc.emit(const GameLoaded(tInitialGameBoard, highScore: 0));
        return gameBloc;
      },
      act: (bloc) => bloc.add(const GameMoveEvent(MoveDirection.up)),
      expect: () => [const GameLoaded(tMovedGameBoard, highScore: 0)],
    );

    blocTest<GameBloc, GameState>(
      'emits [GameLoaded] with updated game board when GameMoved '
      'and merge occurs',
      build: () {
        when(
          mockMoveTilesUseCase.call(any, any),
        ).thenAnswer((_) async => (tMovedGameBoard, true));
        when(mockCheckGameOverUseCase.call(any)).thenAnswer((_) async => false);
        gameBloc.emit(const GameLoaded(tInitialGameBoard, highScore: 0));
        return gameBloc;
      },
      act: (bloc) => bloc.add(const GameMoveEvent(MoveDirection.up)),
      expect: () => [const GameLoaded(tMovedGameBoard, highScore: 0)],
    );

    blocTest<GameBloc, GameState>(
      'emits [GameLoaded] with updated high score when '
      'current score exceeds high score',
      build: () {
        final gameBoardWithHighScore = tMovedGameBoard.copyWith(score: 200);
        when(
          mockMoveTilesUseCase.call(any, any),
        ).thenAnswer((_) async => (gameBoardWithHighScore, false));
        when(mockSaveHighScoreUseCase.call(any)).thenAnswer((_) async => {});
        when(mockCheckGameOverUseCase.call(any)).thenAnswer((_) async => false);
        gameBloc.emit(const GameLoaded(tInitialGameBoard, highScore: 100));
        return gameBloc;
      },
      act: (bloc) => bloc.add(const GameMoveEvent(MoveDirection.up)),
      expect: () => [
        GameLoaded(tMovedGameBoard.copyWith(score: 200), highScore: 200),
      ],
      verify: (_) {
        verify(
          mockSaveHighScoreUseCase.call(const HighScore(score: 200)),
        ).called(1);
      },
    );
  });
}
