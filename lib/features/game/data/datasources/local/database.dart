import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// Table definition for HighScores.
@DataClassName('HighScore')
class HighScores extends Table {
  /// The ID of the high score entry.
  /// Defaults to 1, ensuring a single entry for the high score.
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// The score achieved in the game.
  IntColumn get score => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The main database class for the application, using Drift.
///
/// This class manages the HighScores table and provides database operations.
@DriftDatabase(tables: [HighScores])
class AppDatabase extends _$AppDatabase {
  /// Creates an instance of [AppDatabase].
  ///
  /// It opens a connection to the database file.
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
