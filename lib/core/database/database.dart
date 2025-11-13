import 'package:draig_2048/core/database/tables/audio_settings.dart';
import 'package:draig_2048/core/database/tables/game_states.dart';
import 'package:draig_2048/core/database/tables/high_scores.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'daos/audio_settings_dao.dart';
part 'daos/game_state_dao.dart';
part 'daos/high_score_dao.dart';
part 'database.g.dart';

/// The main database class.
@DriftDatabase(
  tables: [HighScores, GameStates, AudioSettings],
  daos: [GameStateDao, HighScoreDao, AudioSettingsDao],
)
class AppDatabase extends _$AppDatabase {
  /// Creates an instance of [AppDatabase].
  ///
  /// It opens a connection to the database file.
  AppDatabase() : super(_openConnection());

  /// Creates an instance of [AppDatabase] for testing purposes.
  ///
  /// It accepts a [QueryExecutor] for an in-memory database.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_app_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
