import 'dart:convert';
import 'dart:math';

import 'package:draig_2048/features/game/data/datasources/local/database.dart'
    as db;
import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/entities/high_score.dart';
import 'package:draig_2048/features/game/domain/entities/tile.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

/// Implementation of the [GameRepository] interface.
///
/// This class handles the game logic, including creating new games,
/// moving tiles, checking for game over conditions, and managing high scores.
class GameRepositoryImpl implements GameRepository {
  /// Creates an instance of [GameRepositoryImpl].
  GameRepositoryImpl(this._database, this._gameStateDao);

  /// The size of the game board (e.g., 4 for a 4x4 board).
  static const int _boardSize = 4;

  /// A random number generator for placing new tiles.
  final Random _random = Random();

  /// The local database instance for storing high scores.
  final db.AppDatabase _database;
  final db.GameStateDao _gameStateDao;

  /// A UUID generator for creating unique tile IDs.
  final Uuid _uuid = const Uuid();

  /// Generates a unique ID for a new tile.
  String _generateUniqueId() => _uuid.v4();

  @override
  Future<GameBoard?> loadBoard() async {
    final savedState = await _gameStateDao.getLatestGameState();
    if (savedState == null) {
      return null;
    }

    final decodedList = jsonDecode(savedState.board) as List<dynamic>;
    final intTiles = decodedList
        .map((row) => (row as List<dynamic>).map((e) => e as int).toList())
        .toList();

    final tiles = List<List<Tile?>>.generate(
      _boardSize,
      (_) => List.filled(_boardSize, null),
    );

    for (var r = 0; r < _boardSize; r++) {
      for (var c = 0; c < _boardSize; c++) {
        if (intTiles[r][c] != 0) {
          tiles[r][c] = Tile(
            id: _generateUniqueId(),
            value: intTiles[r][c],
            row: r,
            column: c,
          );
        }
      }
    }

    return GameBoard(tiles: _flattenTiles(tiles), score: savedState.score);
  }

  @override
  Future<void> saveBoard(GameBoard board) async {
    final tiles = _copyTiles(board.tiles);
    final intTiles = List<List<int>>.generate(
      _boardSize,
      (r) => List.generate(
        _boardSize,
        (c) => tiles[r][c]?.value ?? 0,
      ),
    );

    final entry = db.GameStatesCompanion(
      id: const drift.Value(1),
      board: drift.Value(jsonEncode(intTiles)),
      score: drift.Value(board.score),
      createdAt: drift.Value(DateTime.now()),
    );
    await _gameStateDao.saveGameState(entry);
  }

  @override
  Future<void> clearBoard() async {
    await _gameStateDao.clearGameStates();
  }

  @override
  Future<GameBoard> newGame() async {
    final tiles = List<List<Tile?>>.generate(
      _boardSize,
      (_) => List.filled(_boardSize, null),
    );
    _addRandomTile(tiles);
    _addRandomTile(tiles);
    return GameBoard(tiles: _flattenTiles(tiles));
  }

  @override
  Future<(GameBoard, bool)> move(
    GameBoard board,
    MoveDirection direction,
  ) async {
    final newTiles = _copyTiles(board.tiles);
    var currentScore = board.score;
    var moved = false;
    var merged = false;

    switch (direction) {
      case MoveDirection.up:
        (moved, currentScore, merged) = _moveUp(newTiles, currentScore);
      case MoveDirection.down:
        (moved, currentScore, merged) = _moveDown(newTiles, currentScore);
      case MoveDirection.left:
        (moved, currentScore, merged) = _moveLeft(newTiles, currentScore);
      case MoveDirection.right:
        (moved, currentScore, merged) = _moveRight(newTiles, currentScore);
    }

    if (moved) {
      _addRandomTile(newTiles);
    }

    return (
      GameBoard(tiles: _flattenTiles(newTiles), score: currentScore),
      merged,
    );
  }

  @override
  Future<bool> isGameOver(GameBoard board) async {
    final tiles = _copyTiles(board.tiles);

    // Check for empty cells
    for (var r = 0; r < _boardSize; r++) {
      for (var c = 0; c < _boardSize; c++) {
        if (tiles[r][c] == null) {
          return false;
        }
      }
    }

    // Check for possible merges
    for (var r = 0; r < _boardSize; r++) {
      for (var c = 0; c < _boardSize; c++) {
        final tile = tiles[r][c]!;
        // Check right
        if (c + 1 < _boardSize && tile.value == tiles[r][c + 1]?.value) {
          return false;
        }
        // Check down
        if (r + 1 < _boardSize && tile.value == tiles[r + 1][c]?.value) {
          return false;
        }
      }
    }

    return true;
  }

  @override
  Future<HighScore> getHighScore() async {
    final results = await _database.select(_database.highScores).get();
    if (results.isEmpty) {
      return const HighScore(score: 0);
    } else {
      final maxScore = results
          .map((e) => e.score)
          .reduce((a, b) => a > b ? a : b);
      return HighScore(score: maxScore);
    }
  }

  @override
  Future<void> saveHighScore(HighScore highScore) async {
    await _database
        .into(_database.highScores)
        .insert(
          db.HighScoresCompanion.insert(
            id: const drift.Value(1),
            score: highScore.score,
          ),
          mode: drift.InsertMode.insertOrReplace,
        );
  }

  /// Flattens a 2D list of [Tile]s into a 1D list.
  List<List<Tile>> _flattenTiles(List<List<Tile?>> tiles) {
    final flattened = <List<Tile>>[];

    for (var r = 0; r < _boardSize; r++) {
      final row = <Tile>[];

      for (var c = 0; c < _boardSize; c++) {
        if (tiles[r][c] != null) {
          row.add(tiles[r][c]!);
        }
      }

      flattened.add(row);
    }

    return flattened;
  }

  /// Creates a deep copy of a 2D list of [Tile]s.
  ///
  /// This ensures that modifications to the copied list do not
  /// affect the original.
  List<List<Tile?>> _copyTiles(List<List<Tile>> tiles) {
    final newTiles = List<List<Tile?>>.generate(
      _boardSize,
      (_) => List.filled(_boardSize, null),
    );

    for (final tile in tiles.expand((row) => row)) {
      newTiles[tile.row][tile.column] = tile.copyWith();
    }

    return newTiles;
  }

  /// Adds a new random tile (value 2 or 4) to a random empty cell on
  /// the [tiles] board.
  ///
  /// If no empty cells are available, no tile is added.
  void _addRandomTile(List<List<Tile?>> tiles) {
    final emptyCells = <({int row, int col})>[];

    for (var r = 0; r < _boardSize; r++) {
      for (var c = 0; c < _boardSize; c++) {
        if (tiles[r][c] == null) {
          emptyCells.add((row: r, col: c));
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      final index = _random.nextInt(emptyCells.length);
      final cell = emptyCells[index];
      final value = _random.nextDouble() < 0.9 ? 2 : 4;

      tiles[cell.row][cell.col] = Tile(
        id: _generateUniqueId(),
        value: value,
        row: cell.row,
        column: cell.col,
      );
    }
  }

  /// Moves tiles upwards within each column of the [tiles] board.
  ///
  /// Also merges identical tiles and updates the [score].
  /// Returns a tuple containing:
  /// - A boolean indicating if any tile moved.
  /// - The updated score.
  /// - A boolean indicating if any merge occurred.
  (bool, int, bool) _moveUp(List<List<Tile?>> tiles, int score) {
    var moved = false;
    var merged = false;
    var newScore = score;

    for (var col = 0; col < _boardSize; col++) {
      final column = <Tile>[];
      for (var row = 0; row < _boardSize; row++) {
        if (tiles[row][col] != null) {
          column.add(tiles[row][col]!);
        }
      }

      final (mergedColumn, mergedScore, tileMerged) = _mergeTiles(
        column,
        newScore,
      );

      if (tileMerged) merged = true;

      newScore = mergedScore;
      final newColumn = mergedColumn;

      while (newColumn.length < _boardSize) {
        newColumn.add(null);
      }

      for (var row = 0; row < _boardSize; row++) {
        if (tiles[row][col]?.value != newColumn[row]?.value ||
            tiles[row][col]?.id != newColumn[row]?.id) {
          moved = true;
        }
        tiles[row][col] = newColumn[row]?.copyWith(row: row, column: col);
      }
    }

    return (moved, newScore, merged);
  }

  /// Moves tiles downwards within each column of the [tiles] board.
  ///
  /// Also merges identical tiles and updates the [score].
  /// Returns a tuple containing:
  /// - A boolean indicating if any tile moved.
  /// - The updated score.
  /// - A boolean indicating if any merge occurred.
  (bool, int, bool) _moveDown(List<List<Tile?>> tiles, int score) {
    var moved = false;
    var merged = false;
    var newScore = score;

    for (var col = 0; col < _boardSize; col++) {
      final column = <Tile>[];

      for (var row = _boardSize - 1; row >= 0; row--) {
        if (tiles[row][col] != null) {
          column.add(tiles[row][col]!);
        }
      }

      final (mergedColumn, mergedScore, tileMerged) = _mergeTiles(
        column,
        newScore,
      );

      if (tileMerged) merged = true;

      newScore = mergedScore;
      var newColumn = mergedColumn;

      while (newColumn.length < _boardSize) {
        newColumn.add(null);
      }

      newColumn = newColumn.reversed.toList();

      for (var row = 0; row < _boardSize; row++) {
        if (tiles[row][col]?.value != newColumn[row]?.value ||
            tiles[row][col]?.id != newColumn[row]?.id) {
          moved = true;
        }
        tiles[row][col] = newColumn[row]?.copyWith(row: row, column: col);
      }
    }

    return (moved, newScore, merged);
  }

  /// Moves tiles to the left within each row of the [tiles] board.
  ///
  /// Also merges identical tiles and updates the [score].
  /// Returns a tuple containing:
  /// - A boolean indicating if any tile moved.
  /// - The updated score.
  /// - A boolean indicating if any merge occurred.
  (bool, int, bool) _moveLeft(List<List<Tile?>> tiles, int score) {
    var moved = false;
    var merged = false;
    var newScore = score;

    for (var row = 0; row < _boardSize; row++) {
      final currentRow = <Tile>[];

      for (var col = 0; col < _boardSize; col++) {
        if (tiles[row][col] != null) {
          currentRow.add(tiles[row][col]!);
        }
      }

      final (mergedRow, mergedScore, tileMerged) = _mergeTiles(
        currentRow,
        newScore,
      );

      if (tileMerged) merged = true;

      newScore = mergedScore;
      final newRow = mergedRow;

      while (newRow.length < _boardSize) {
        newRow.add(null);
      }

      for (var col = 0; col < _boardSize; col++) {
        if (tiles[row][col]?.value != newRow[col]?.value ||
            tiles[row][col]?.id != newRow[col]?.id) {
          moved = true;
        }
        tiles[row][col] = newRow[col]?.copyWith(row: row, column: col);
      }
    }

    return (moved, newScore, merged);
  }

  /// Moves tiles to the right within each row of the [tiles] board.
  ///
  /// Also merges identical tiles and updates the [score].
  /// Returns a tuple containing:
  /// - A boolean indicating if any tile moved.
  /// - The updated score.
  /// - A boolean indicating if any merge occurred.
  (bool, int, bool) _moveRight(List<List<Tile?>> tiles, int score) {
    var moved = false;
    var merged = false;
    var newScore = score;

    for (var row = 0; row < _boardSize; row++) {
      final currentRow = <Tile>[];
      for (var col = _boardSize - 1; col >= 0; col--) {
        if (tiles[row][col] != null) {
          currentRow.add(tiles[row][col]!);
        }
      }

      final (mergedRow, mergedScore, tileMerged) = _mergeTiles(
        currentRow,
        newScore,
      );

      if (tileMerged) merged = true;

      newScore = mergedScore;
      var newRow = mergedRow;

      while (newRow.length < _boardSize) {
        newRow.add(null);
      }

      newRow = newRow.reversed.toList();

      for (var col = 0; col < _boardSize; col++) {
        if (tiles[row][col]?.value != newRow[col]?.value ||
            tiles[row][col]?.id != newRow[col]?.id) {
          moved = true;
        }

        tiles[row][col] = newRow[col]?.copyWith(row: row, column: col);
      }
    }

    return (moved, newScore, merged);
  }

  /// Merges identical tiles in a single [line] of tiles and
  /// updates the [score].
  ///
  /// Returns a tuple containing:
  /// - The new list of tiles after merging.
  /// - The updated score.
  /// - A boolean indicating if any merge occurred.
  (List<Tile?>, int, bool) _mergeTiles(List<Tile> line, int score) {
    final newLine = <Tile?>[];
    var newScore = score;
    var merged = false;

    for (var i = 0; i < line.length; i++) {
      if (i + 1 < line.length && line[i].value == line[i + 1].value) {
        final mergedValue = line[i].value * 2;

        newLine.add(
          Tile(
            id: _generateUniqueId(),
            value: mergedValue,
            row: line[i].row,
            column: line[i].column,
          ),
        );

        newScore += mergedValue;
        merged = true;
        i++;
      } else {
        newLine.add(line[i]);
      }
    }

    return (newLine, newScore, merged);
  }
}
