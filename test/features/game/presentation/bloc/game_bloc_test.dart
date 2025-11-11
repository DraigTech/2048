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
  MoveTilesUseCase,
  GameRepository,
  GetHighScoreUseCase,
  SaveHighScoreUseCase,
  CheckGameOverUseCase,
])
void main() {
  late GameBloc gameBloc;
  late MockMoveTilesUseCase mockMoveTilesUseCase;
  late MockGameRepository mockGameRepository;
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

    mockMoveTilesUseCase = MockMoveTilesUseCase();
    mockGameRepository = MockGameRepository();
    mockGetHighScoreUseCase = MockGetHighScoreUseCase();
    mockSaveHighScoreUseCase = MockSaveHighScoreUseCase();
    mockCheckGameOverUseCase = MockCheckGameOverUseCase();

    gameBloc = GameBloc(
      moveTiles: mockMoveTilesUseCase,
      repository: mockGameRepository,
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
    const tInitialBoard = GameBoard(
      tiles: [
        [Tile(id: '1', value: 2, row: 0, column: 0)],
      ],
    );
    const tMovedBoard = GameBoard(
      score: 2,
      tiles: [
        [Tile(id: '1', value: 2, row: 1, column: 0)],
      ],
    );
    const tHighScore = HighScore(score: 0);

    blocTest<GameBloc, GameState>(
      'should emit GameLoaded with initial game board and high score 0 '
      'when GameStartEvent and no saved board',
      build: () {
        when(mockGameRepository.loadBoard()).thenAnswer((_) async => null);
        when(
          mockGameRepository.newGame(),
        ).thenAnswer((_) async => tInitialBoard);
        when(
          mockGetHighScoreUseCase.call(),
        ).thenAnswer((_) async => tHighScore);
        return gameBloc;
      },
      act: (bloc) => bloc.add(GameStartEvent()),
      expect: () => [
        GameLoaded(tInitialBoard, highScore: tHighScore.score),
      ],
      verify: (_) {
        verify(mockGameRepository.loadBoard()).called(1);
        verify(mockGameRepository.newGame()).called(1);
        verify(mockGetHighScoreUseCase.call()).called(1);
      },
    );

    blocTest<GameBloc, GameState>(
      'should emit GameLoaded with loaded board and high score when '
      'GameStartEvent and saved board exists',
      build: () {
        when(
          mockGameRepository.loadBoard(),
        ).thenAnswer((_) async => tInitialBoard);
        when(
          mockGetHighScoreUseCase.call(),
        ).thenAnswer((_) async => tHighScore);
        return gameBloc;
      },
      act: (bloc) => bloc.add(GameStartEvent()),
      expect: () => [
        GameLoaded(tInitialBoard, highScore: tHighScore.score),
      ],
      verify: (_) {
        verify(mockGameRepository.loadBoard()).called(1);
        verify(mockGetHighScoreUseCase.call()).called(1);
        verifyNever(mockGameRepository.newGame());
      },
    );

    blocTest<GameBloc, GameState>(
      'should emit GameLoaded with updated board and score on GameMoveEvent',
      build: () {
        when(
          mockMoveTilesUseCase.call(any, any),
        ).thenAnswer((_) async => (tMovedBoard, false));
        when(mockCheckGameOverUseCase.call(any)).thenAnswer((_) async => false);
        return gameBloc;
      },
      seed: () => GameLoaded(tInitialBoard, highScore: tHighScore.score),
      act: (bloc) => bloc.add(const GameMoveEvent(MoveDirection.up)),
      expect: () => [
        GameLoaded(tMovedBoard, highScore: tMovedBoard.score),
      ],
      verify: (_) {
        verify(mockMoveTilesUseCase.call(any, any)).called(1);
        verify(mockCheckGameOverUseCase.call(any)).called(1);
        verifyNever(mockGameRepository.saveBoard(any));
      },
    );

    blocTest<GameBloc, GameState>(
      'should emit GameLoaded with isGameOver true if game is over after move',
      build: () {
        when(
          mockMoveTilesUseCase.call(any, any),
        ).thenAnswer((_) async => (tMovedBoard, false));
        when(mockCheckGameOverUseCase.call(any)).thenAnswer((_) async => true);
        return gameBloc;
      },
      seed: () => GameLoaded(tInitialBoard, highScore: tHighScore.score),
      act: (bloc) => bloc.add(const GameMoveEvent(MoveDirection.up)),
      expect: () => [
        GameLoaded(tMovedBoard, highScore: tMovedBoard.score),
        GameLoaded(
          tMovedBoard,
          highScore:  tMovedBoard.score,
          isGameOver: true,
        ),
      ],
      verify: (_) {
        verify(mockMoveTilesUseCase.call(any, any)).called(1);
        verify(mockCheckGameOverUseCase.call(any)).called(1);
        verifyNever(mockGameRepository.saveBoard(any));
      },
    );

    blocTest<GameBloc, GameState>(
      'should save new high score if current score is greater',
      build: () {
        when(
          mockMoveTilesUseCase.call(any, any),
        ).thenAnswer((_) async => (tInitialBoard.copyWith(score: 200), true));
        when(mockCheckGameOverUseCase.call(any)).thenAnswer((_) async => false);
        when(mockSaveHighScoreUseCase.call(any)).thenAnswer((_) async => {});
        return gameBloc;
      },
      seed: () => const GameLoaded(tInitialBoard, highScore: 100),
      act: (bloc) => bloc.add(const GameMoveEvent(MoveDirection.up)),
      expect: () => [
        GameLoaded(tInitialBoard.copyWith(score: 200), highScore: 200),
      ],
      verify: (_) {
        verify(mockMoveTilesUseCase.call(any, any)).called(1);
        verify(mockCheckGameOverUseCase.call(any)).called(1);
        verifyNever(mockGameRepository.saveBoard(any));
        verify(
          mockSaveHighScoreUseCase.call(const HighScore(score: 200)),
        ).called(1);
      },
    );

    blocTest<GameBloc, GameState>(
      'should not save new high score if current score is not greater',
      build: () {
        when(
          mockMoveTilesUseCase.call(any, any),
        ).thenAnswer((_) async => (tInitialBoard.copyWith(score: 50), true));
        when(mockCheckGameOverUseCase.call(any)).thenAnswer((_) async => false);
        when(mockSaveHighScoreUseCase.call(any)).thenAnswer((_) async => {});
        return gameBloc;
      },
      seed: () => const GameLoaded(tInitialBoard, highScore: 100),
      act: (bloc) => bloc.add(const GameMoveEvent(MoveDirection.up)),
      expect: () => [
        GameLoaded(tInitialBoard.copyWith(score: 50), highScore: 100),
      ],
      verify: (_) {
        verify(mockMoveTilesUseCase.call(any, any)).called(1);
        verify(mockCheckGameOverUseCase.call(any)).called(1);
        verifyNever(mockGameRepository.saveBoard(any));
        verifyNever(mockSaveHighScoreUseCase.call(any));
      },
    );

    blocTest<GameBloc, GameState>(
      'should emit GameLoaded with new board and score on NewGameEvent',
      build: () {
        when(
          mockGameRepository.newGame(),
        ).thenAnswer((_) async => tInitialBoard);
        when(
          mockGetHighScoreUseCase.call(),
        ).thenAnswer((_) async => tHighScore);
        when(mockGameRepository.clearBoard()).thenAnswer((_) async => {});
        return gameBloc;
      },
      seed: () => GameLoaded(
        tInitialBoard,
        highScore: tHighScore.score,
        isGameOver: true,
      ),
      act: (bloc) => bloc.add(NewGameEvent()),
      expect: () => [
        GameLoaded(tInitialBoard, highScore: tHighScore.score),
      ],
      verify: (_) {
        verify(mockGameRepository.newGame()).called(1);
        verify(mockGameRepository.clearBoard()).called(1);
        verifyNever(mockGameRepository.saveBoard(any));
        verify(mockGetHighScoreUseCase.call()).called(1);
      },
    );

    blocTest<GameBloc, GameState>(
      'should save the current game board on SaveGameEvent',
      build: () {
        when(mockGameRepository.saveBoard(any)).thenAnswer((_) async => {});
        return gameBloc;
      },
      seed: () => GameLoaded(tInitialBoard, highScore: tHighScore.score),
      act: (bloc) => bloc.add(SaveGameEvent()),
      expect: () => <GameState>[], // No state change expected for SaveGameEvent
      verify: (_) {
        verify(mockGameRepository.saveBoard(tInitialBoard)).called(1);
      },
    );
  });
}
