import 'dart:convert';
import 'dart:math';

import 'package:draig_2048/core/database/database.dart' as db;
import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/entities/high_score.dart';
import 'package:draig_2048/features/game/domain/entities/tile.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';
import 'package:draig_2048/features/settings/domain/entities/game_mode.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

/// Implementation of the [GameRepository] interface.
///
/// This class handles the game logic, including creating new games,
/// moving tiles, checking for game over conditions,
/// and managing high scores.
class GameRepositoryImpl implements GameRepository {
  /// Creates an instance of [GameRepositoryImpl].
  GameRepositoryImpl(this._gameStateDao, this._highScoreDao);

  /// A random number generator for placing new tiles.
  final Random _random = Random();

  final db.GameStateDao _gameStateDao;
  final db.HighScoreDao _highScoreDao;

  /// A UUID generator for creating unique tile IDs.
  final Uuid _uuid = const Uuid();

  /// Generates a unique ID for a new tile.
  String _generateUniqueId() => _uuid.v4();

  @override
  Future<GameBoard?> loadBoard(int boardSize) async {
    final savedState = await _gameStateDao.getLatestGameState(boardSize);
    if (savedState == null) {
      return null;
    }

    final decodedList = jsonDecode(savedState.board) as List<dynamic>;
    final intTiles = decodedList
        .map((row) => (row as List<dynamic>).map((e) => e as int).toList())
        .toList();

    final tiles = List<List<Tile?>>.generate(
      boardSize,
      (_) => List.filled(boardSize, null),
    );

    for (var r = 0; r < boardSize; r++) {
      for (var c = 0; c < boardSize; c++) {
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

    return GameBoard(
      tiles: _flattenTiles(tiles, boardSize),
      score: savedState.score,
    );
  }

  @override
  Future<void> saveBoard(GameBoard board, int boardSize) async {
    final tiles = _copyTiles(board.tiles, boardSize);
    final intTiles = List<List<int>>.generate(
      boardSize,
      (r) => List.generate(
        boardSize,
        (c) => tiles[r][c]?.value ?? 0,
      ),
    );

    final entry = db.GameStatesCompanion(
      id: const drift.Value(1),
      board: drift.Value(jsonEncode(intTiles)),
      score: drift.Value(board.score),
      boardSize: drift.Value(boardSize),
      createdAt: drift.Value(DateTime.now()),
    );
    await _gameStateDao.saveGameState(entry);
  }

  @override
  Future<void> clearBoard() async {
    await _gameStateDao.clearGameStates();
  }

  @override
  Future<GameBoard> newGame(int boardSize) async {
    final tiles = List<List<Tile?>>.generate(
      boardSize,
      (_) => List.filled(boardSize, null),
    );
    _addRandomTile(tiles, boardSize);
    _addRandomTile(tiles, boardSize);
    return GameBoard(tiles: _flattenTiles(tiles, boardSize));
  }

  @override
  Future<(GameBoard, bool)> move(
    GameBoard board,
    MoveDirection direction,
  ) async {
    final boardSize = board.tiles.length;
    final newTiles = _copyTiles(board.tiles, boardSize);
    var currentScore = board.score;
    var moved = false;
    var merged = false;

    switch (direction) {
      case MoveDirection.up:
        (moved, currentScore, merged) = _moveUp(
          newTiles,
          currentScore,
          boardSize,
        );
      case MoveDirection.down:
        (moved, currentScore, merged) = _moveDown(
          newTiles,
          currentScore,
          boardSize,
        );
      case MoveDirection.left:
        (moved, currentScore, merged) = _moveLeft(
          newTiles,
          currentScore,
          boardSize,
        );
      case MoveDirection.right:
        (moved, currentScore, merged) = _moveRight(
          newTiles,
          currentScore,
          boardSize,
        );
    }

    if (moved) {
      final tilesToSpawn = GameMode.allModes
          .firstWhere(
            (mode) => mode.boardSize == boardSize,
          )
          .tilesToSpawn;

      for (var i = 0; i < tilesToSpawn; i++) {
        _addRandomTile(newTiles, boardSize);
      }
    }

    return (
      GameBoard(tiles: _flattenTiles(newTiles, boardSize), score: currentScore),
      merged,
    );
  }

  @override
  Future<bool> isGameOver(GameBoard board) async {
    final boardSize = board.tiles.length;
    final tiles = _copyTiles(board.tiles, boardSize);

    // Check for empty cells
    for (var r = 0; r < boardSize; r++) {
      for (var c = 0; c < boardSize; c++) {
        if (tiles[r][c] == null) {
          return false;
        }
      }
    }

    // Check for possible merges
    for (var r = 0; r < boardSize; r++) {
      for (var c = 0; c < boardSize; c++) {
        final tile = tiles[r][c]!;
        // Check right
        if (c + 1 < boardSize && tile.value == tiles[r][c + 1]?.value) {
          return false;
        }
        // Check down
        if (r + 1 < boardSize && tile.value == tiles[r + 1][c]?.value) {
          return false;
        }
      }
    }

    return true;
  }

  @override
  Future<HighScore> getHighScore(int boardSize) async {
    final results = await _highScoreDao.getHighScore(boardSize);
    if (results == null) {
      return const HighScore(score: 0);
    } else {
      return HighScore(score: results.score);
    }
  }

  @override
  Future<void> saveHighScore(HighScore highScore, int boardSize) async {
    await _highScoreDao.saveHighScore(
      db.HighScoresCompanion(
        score: drift.Value(highScore.score),
        boardSize: drift.Value(boardSize),
      ),
    );
  }

  /// Flattens a 2D list of [Tile]s into a 1D list.
  List<List<Tile>> _flattenTiles(List<List<Tile?>> tiles, int boardSize) {
    final flattened = <List<Tile>>[];

    for (var r = 0; r < boardSize; r++) {
      final row = <Tile>[];

      for (var c = 0; c < boardSize; c++) {
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
  List<List<Tile?>> _copyTiles(List<List<Tile>> tiles, int boardSize) {
    final newTiles = List<List<Tile?>>.generate(
      boardSize,
      (_) => List.filled(boardSize, null),
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
  void _addRandomTile(List<List<Tile?>> tiles, int boardSize) {
    final emptyCells = <({int row, int col})>[];

    for (var r = 0; r < boardSize; r++) {
      for (var c = 0; c < boardSize; c++) {
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
  (bool, int, bool) _moveUp(List<List<Tile?>> tiles, int score, int boardSize) {
    var moved = false;
    var merged = false;
    var newScore = score;

    for (var col = 0; col < boardSize; col++) {
      final column = <Tile>[];
      for (var row = 0; row < boardSize; row++) {
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

      while (newColumn.length < boardSize) {
        newColumn.add(null);
      }

      for (var row = 0; row < boardSize; row++) {
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
  (bool, int, bool) _moveDown(
    List<List<Tile?>> tiles,
    int score,
    int boardSize,
  ) {
    var moved = false;
    var merged = false;
    var newScore = score;

    for (var col = 0; col < boardSize; col++) {
      final column = <Tile>[];

      for (var row = boardSize - 1; row >= 0; row--) {
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

      while (newColumn.length < boardSize) {
        newColumn.add(null);
      }

      newColumn = newColumn.reversed.toList();

      for (var row = 0; row < boardSize; row++) {
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
  (bool, int, bool) _moveLeft(
    List<List<Tile?>> tiles,
    int score,
    int boardSize,
  ) {
    var moved = false;
    var merged = false;
    var newScore = score;

    for (var row = 0; row < boardSize; row++) {
      final currentRow = <Tile>[];

      for (var col = 0; col < boardSize; col++) {
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

      while (newRow.length < boardSize) {
        newRow.add(null);
      }

      for (var col = 0; col < boardSize; col++) {
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
  (bool, int, bool) _moveRight(
    List<List<Tile?>> tiles,
    int score,
    int boardSize,
  ) {
    var moved = false;
    var merged = false;
    var newScore = score;

    for (var row = 0; row < boardSize; row++) {
      final currentRow = <Tile>[];
      for (var col = boardSize - 1; col >= 0; col--) {
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

      while (newRow.length < boardSize) {
        newRow.add(null);
      }

      newRow = newRow.reversed.toList();

      for (var col = 0; col < boardSize; col++) {
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
