import 'dart:convert';

import 'package:draig_2048/core/database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase testDatabase;
  late GameStateDao gameStateDao;

  setUp(() {
    testDatabase = AppDatabase.forTesting(NativeDatabase.memory());
    gameStateDao = testDatabase.gameStateDao;
  });

  tearDown(() async {
    await testDatabase.close();
  });

  group('GameStateDao', () {
    test('should return null if no game state is saved', () async {
      final result = await gameStateDao.getLatestGameState();
      expect(result, isNull);
    });

    test('should save and retrieve a game state', () async {
      final fixedNow = DateTime(2023, 1, 1, 10, 30);
      final entry = GameStatesCompanion(
        id: const drift.Value(1),
        board: drift.Value(jsonEncode(['board_data'])),
        score: const drift.Value(100),
        createdAt: drift.Value(fixedNow),
      );

      await gameStateDao.saveGameState(entry);

      final result = await gameStateDao.getLatestGameState();

      expect(result, isNotNull);
      expect(result!.id, 1);
      expect(result.board, jsonEncode(['board_data']));
      expect(result.score, 100);
      expect(
        result.createdAt.millisecondsSinceEpoch,
        fixedNow.millisecondsSinceEpoch,
      );
    });

    test('should update an existing game state', () async {
      final fixedNow = DateTime(2023, 1, 1, 10, 30);
      final entry1 = GameStatesCompanion(
        id: const drift.Value(1),
        board: drift.Value(jsonEncode(['board_data_1'])),
        score: const drift.Value(100),
        createdAt: drift.Value(fixedNow),
      );

      await gameStateDao.saveGameState(entry1);

      final fixedLater = DateTime(2023, 1, 1, 10, 31);
      final entry2 = GameStatesCompanion(
        id: const drift.Value(1),
        board: drift.Value(jsonEncode(['board_data_2'])),
        score: const drift.Value(200),
        createdAt: drift.Value(fixedLater),
      );

      await gameStateDao.saveGameState(entry2);

      final result = await gameStateDao.getLatestGameState();

      expect(result, isNotNull);
      expect(result!.id, 1);
      expect(result.board, jsonEncode(['board_data_2']));
      expect(result.score, 200);
      expect(
        result.createdAt.millisecondsSinceEpoch,
        fixedLater.millisecondsSinceEpoch,
      );
    });

    test('should clear all game states', () async {
      final fixedNow = DateTime(2023, 1, 1, 10, 30);
      final entry = GameStatesCompanion(
        id: const drift.Value(1),
        board: drift.Value(jsonEncode(['board_data'])),
        score: const drift.Value(100),
        createdAt: drift.Value(fixedNow),
      );

      await gameStateDao.saveGameState(entry);
      var result = await gameStateDao.getLatestGameState();
      expect(result, isNotNull);

      await gameStateDao.clearGameStates();
      result = await gameStateDao.getLatestGameState();
      expect(result, isNull);
    });
  });
}
