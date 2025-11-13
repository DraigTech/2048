import 'package:draig_2048/core/database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase testDatabase;
  late HighScoreDao highScoreDao;

  setUp(() {
    testDatabase = AppDatabase.forTesting(NativeDatabase.memory());
    highScoreDao = testDatabase.highScoreDao;
  });

  tearDown(() async {
    await testDatabase.close();
  });

  group('HighScoreDao', () {
    test('should return null if no high score is saved', () async {
      final result = await highScoreDao.getHighScore();
      expect(result, isNull);
    });

    test('should save and retrieve a high score', () async {
      const entry = HighScoresCompanion(
        id: drift.Value(1),
        score: drift.Value(1000),
      );

      await highScoreDao.saveHighScore(entry);

      final result = await highScoreDao.getHighScore();

      expect(result, isNotNull);
      expect(result!.id, 1);
      expect(result.score, 1000);
    });

    test('should update an existing high score', () async {
      const entry1 = HighScoresCompanion(
        id: drift.Value(1),
        score: drift.Value(1000),
      );

      await highScoreDao.saveHighScore(entry1);

      const entry2 = HighScoresCompanion(
        id: drift.Value(1),
        score: drift.Value(2000),
      );

      await highScoreDao.saveHighScore(entry2);

      final result = await highScoreDao.getHighScore();

      expect(result, isNotNull);
      expect(result!.id, 1);
      expect(result.score, 2000);
    });

    test('should return the highest score if multiple are saved (though only '
        'one should exist with ID 1)', () async {
      // This test case is mostly for demonstrating the behavior if multiple
      // entries were possible. With id: 1 and InsertMode.replace, only one
      // entry will ever exist.
      const entry1 = HighScoresCompanion(
        id: drift.Value(1),
        score: drift.Value(500),
      );
      await highScoreDao.saveHighScore(entry1);

      const entry2 = HighScoresCompanion(
        id: drift.Value(1),
        score: drift.Value(1500),
      );
      await highScoreDao.saveHighScore(entry2);

      final result = await highScoreDao.getHighScore();

      expect(result, isNotNull);
      expect(result!.id, 1);
      expect(result.score, 1500);
    });
  });
}
