import 'dart:math';
import 'package:uuid/uuid.dart';

import 'package:_2048/features/game/data/datasources/local/database.dart' hide HighScore;
import 'package:_2048/features/game/domain/entities/game_board.dart';
import 'package:_2048/features/game/domain/entities/high_score.dart';
import 'package:_2048/features/game/domain/entities/tile.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';
import 'package:drift/drift.dart' as drift;

class GameRepositoryImpl implements GameRepository {
  static const int _boardSize = 4;
  final Random _random = Random();
  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  GameRepositoryImpl(this._database);

  String _generateUniqueId() => _uuid.v4();

  @override
  Future<GameBoard> newGame() async {
    List<List<Tile?>> tiles = List.generate(_boardSize, (_) => List.filled(_boardSize, null));
    _addRandomTile(tiles);
    _addRandomTile(tiles);
    return GameBoard(tiles: _flattenTiles(tiles), score: 0);
  }

  @override
  Future<GameBoard> move(GameBoard board, Direction direction) async {
    List<List<Tile?>> newTiles = _copyTiles(board.tiles);
    int currentScore = board.score;
    bool moved = false;

    switch (direction) {
      case Direction.up:
        (moved, currentScore) = _moveUp(newTiles, currentScore);
        break;
      case Direction.down:
        (moved, currentScore) = _moveDown(newTiles, currentScore);
        break;
      case Direction.left:
        (moved, currentScore) = _moveLeft(newTiles, currentScore);
        break;
      case Direction.right:
        (moved, currentScore) = _moveRight(newTiles, currentScore);
        break;
    }

    if (moved) {
      _addRandomTile(newTiles);
    }

    return GameBoard(tiles: _flattenTiles(newTiles), score: currentScore);
  }

  @override
  Future<HighScore> getHighScore() async {
    final results = await _database.select(_database.highScores).get();
    if (results.isEmpty) {
      return const HighScore(score: 0);
    } else {
      final maxScore = results.map((e) => e.score).reduce((a, b) => a > b ? a : b);
      return HighScore(score: maxScore);
    }
  }

  @override
  Future<void> saveHighScore(HighScore highScore) async {
    await _database.into(_database.highScores).insert(
          HighScoresCompanion.insert(id: const drift.Value(1), score: highScore.score),
          mode: drift.InsertMode.insertOrReplace,
        );
  }

  List<List<Tile>> _flattenTiles(List<List<Tile?>> tiles) {
    List<List<Tile>> flattened = [];
    for (int r = 0; r < _boardSize; r++) {
      List<Tile> row = [];
      for (int c = 0; c < _boardSize; c++) {
        if (tiles[r][c] != null) {
          row.add(tiles[r][c]!);
        }
      }
      flattened.add(row);
    }
    return flattened;
  }

  List<List<Tile?>> _copyTiles(List<List<Tile>> tiles) {
    List<List<Tile?>> newTiles = List.generate(_boardSize, (_) => List.filled(_boardSize, null));
    for (final tile in tiles.expand((row) => row)) {
      newTiles[tile.row][tile.column] = tile.copyWith();
    }
    return newTiles;
  }

  void _addRandomTile(List<List<Tile?>> tiles) {
    List<({int row, int col})> emptyCells = [];
    for (int r = 0; r < _boardSize; r++) {
      for (int c = 0; c < _boardSize; c++) {
        if (tiles[r][c] == null) {
          emptyCells.add((row: r, col: c));
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      final int index = _random.nextInt(emptyCells.length);
      final ({int row, int col}) cell = emptyCells[index];
      final int value = _random.nextDouble() < 0.9 ? 2 : 4;
      tiles[cell.row][cell.col] = Tile(id: _generateUniqueId(), value: value, row: cell.row, column: cell.col);
    }
  }

  (bool, int) _moveUp(List<List<Tile?>> tiles, int score) {
    bool moved = false;
    int newScore = score;
    for (int col = 0; col < _boardSize; col++) {
      List<Tile> column = [];
      for (int row = 0; row < _boardSize; row++) {
        if (tiles[row][col] != null) {
          column.add(tiles[row][col]!);
        }
      }

      final (mergedColumn, mergedScore) = _mergeTiles(column, newScore);
      newScore = mergedScore;
      List<Tile?> newColumn = mergedColumn;
      while (newColumn.length < _boardSize) {
        newColumn.add(null);
      }

      for (int row = 0; row < _boardSize; row++) {
        if (tiles[row][col]?.value != newColumn[row]?.value || tiles[row][col]?.id != newColumn[row]?.id) {
          moved = true;
        }
        tiles[row][col] = newColumn[row]?.copyWith(row: row, column: col);
      }
    }
    return (moved, newScore);
  }

  (bool, int) _moveDown(List<List<Tile?>> tiles, int score) {
    bool moved = false;
    int newScore = score;
    for (int col = 0; col < _boardSize; col++) {
      List<Tile> column = [];
      for (int row = _boardSize - 1; row >= 0; row--) {
        if (tiles[row][col] != null) {
          column.add(tiles[row][col]!);
        }
      }

      final (mergedColumn, mergedScore) = _mergeTiles(column, newScore);
      newScore = mergedScore;
      List<Tile?> newColumn = mergedColumn;
      while (newColumn.length < _boardSize) {
        newColumn.add(null);
      }
      newColumn = newColumn.reversed.toList();

      for (int row = 0; row < _boardSize; row++) {
        if (tiles[row][col]?.value != newColumn[row]?.value || tiles[row][col]?.id != newColumn[row]?.id) {
          moved = true;
        }
        tiles[row][col] = newColumn[row]?.copyWith(row: row, column: col);
      }
    }
    return (moved, newScore);
  }

  (bool, int) _moveLeft(List<List<Tile?>> tiles, int score) {
    bool moved = false;
    int newScore = score;
    for (int row = 0; row < _boardSize; row++) {
      List<Tile> currentRow = [];
      for (int col = 0; col < _boardSize; col++) {
        if (tiles[row][col] != null) {
          currentRow.add(tiles[row][col]!);
        }
      }

      final (mergedRow, mergedScore) = _mergeTiles(currentRow, newScore);
      newScore = mergedScore;
      List<Tile?> newRow = mergedRow;
      while (newRow.length < _boardSize) {
        newRow.add(null);
      }

      for (int col = 0; col < _boardSize; col++) {
        if (tiles[row][col]?.value != newRow[col]?.value || tiles[row][col]?.id != newRow[col]?.id) {
          moved = true;
        }
        tiles[row][col] = newRow[col]?.copyWith(row: row, column: col);
      }
    }
    return (moved, newScore);
  }

  (bool, int) _moveRight(List<List<Tile?>> tiles, int score) {
    bool moved = false;
    int newScore = score;
    for (int row = 0; row < _boardSize; row++) {
      List<Tile> currentRow = [];
      for (int col = _boardSize - 1; col >= 0; col--) {
        if (tiles[row][col] != null) {
          currentRow.add(tiles[row][col]!);
        }
      }

      final (mergedRow, mergedScore) = _mergeTiles(currentRow, newScore);
      newScore = mergedScore;
      List<Tile?> newRow = mergedRow;
      while (newRow.length < _boardSize) {
        newRow.add(null);
      }
      newRow = newRow.reversed.toList();

      for (int col = 0; col < _boardSize; col++) {
        if (tiles[row][col]?.value != newRow[col]?.value || tiles[row][col]?.id != newRow[col]?.id) {
          moved = true;
        }
        tiles[row][col] = newRow[col]?.copyWith(row: row, column: col);
      }
    }
    return (moved, newScore);
  }

  (List<Tile?>, int) _mergeTiles(List<Tile> line, int score) {
    List<Tile?> newLine = [];
    int newScore = score;
    for (int i = 0; i < line.length; i++) {
      if (i + 1 < line.length && line[i].value == line[i + 1].value) {
        int mergedValue = line[i].value * 2;
        newLine.add(Tile(id: _generateUniqueId(), value: mergedValue, row: line[i].row, column: line[i].column));
        newScore += mergedValue;
        i++;
      } else {
        newLine.add(line[i]);
      }
    }
    return (newLine, newScore);
  }
}
