import 'package:draig_2048/core/database/database.dart' as db;
import 'package:mockito/mockito.dart';

class UnusedGameStateDao extends Mock implements db.GameStateDao {}

class UnusedHighScoreDao extends Mock implements db.HighScoreDao {}
