import 'dart:convert';

import 'package:draig_2048/features/game/data/datasources/local/database.dart'
    as db;
import 'package:draig_2048/features/game/data/repositories/game_repository_impl.dart';
import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/entities/tile.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late db.AppDatabase testDatabase;
  late db.GameStateDao gameStateDao;
  late GameRepositoryImpl repository;

  setUp(() {
    // Use an in-memory database for testing
    testDatabase = db.AppDatabase.forTesting(NativeDatabase.memory());
    // The DAO is obtained from the database instance
    gameStateDao = testDatabase.gameStateDao;
    repository = GameRepositoryImpl(testDatabase, gameStateDao);
  });

  // Close the database after each test
  tearDown(() async {
    await testDatabase.close();
  });

  group('GameRepositoryImpl with In-Memory Database', () {
    group('loadBoard', () {
      test('should return null if no game state is saved', () async {
        final result = await repository.loadBoard();
        expect(result, isNull);
      });

      test('should return GameBoard if a game state is saved', () async {
        // Arrange: Save a state first
        const initialBoard = GameBoard(
          tiles: [
            [Tile(id: '1', value: 2, row: 0, column: 1)]
          ],
          score: 10,
        );
        await repository.saveBoard(initialBoard);

        // Act
        final result = await repository.loadBoard();

        // Assert
        expect(result, isA<GameBoard>());
        expect(result!.score, 10);
        expect(result.tiles[0][0].value, 2);
      });
    });

    group('saveBoard', () {
      test('should correctly save the game board to the database', () async {
        // Arrange
        const boardToSave = GameBoard(
          tiles: [
            [Tile(id: '1', value: 4, row: 0, column: 0)]
          ],
          score: 4,
        );

        // Act
        await repository.saveBoard(boardToSave);

        // Assert: Retrieve the state directly from the DAO to verify
        final savedState = await gameStateDao.getLatestGameState();
        expect(savedState, isNotNull);
        expect(savedState!.score, 4);

        final decodedBoard = jsonDecode(savedState.board) as List<dynamic>;

        /// The decoded board is a list of lists, 
        /// and each inner list contains a map representing a Tile.
        // ignore: avoid_dynamic_calls
        expect(decodedBoard[0][0], 4);
      });
    });

    group('clearBoard', () {
      test('should clear all game states from the database', () async {
        // Arrange: Save a state first
        const boardToSave = GameBoard(
          tiles: [
            [Tile(id: '1', value: 8, row: 0, column: 0)]
          ],
          score: 8,
        );
        await repository.saveBoard(boardToSave);
        var savedState = await gameStateDao.getLatestGameState();
        expect(savedState, isNotNull); // Verify it was saved

        // Act
        await repository.clearBoard();

        // Assert: Verify it's gone
        savedState = await gameStateDao.getLatestGameState();
        expect(savedState, isNull);
      });
    });
  });
}
