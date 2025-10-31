import 'dart:math';

import 'package:_2048/features/game/data/datasources/local/database.dart';
import 'package:_2048/features/game/domain/entities/game_board.dart';
import 'package:_2048/features/game/domain/entities/high_score.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';
import 'package:drift/drift.dart' as drift;

class GameRepositoryImpl implements GameRepository {
  static const int _boardSize = 4;
  final Random _random = Random();
  final AppDatabase _database;

  GameRepositoryImpl(this._database);

  @override
  Future<GameBoard> newGame() async {
    List<List<int>> tiles = List.generate(_boardSize, (_) => List.filled(_boardSize, 0));
    _addRandomTile(tiles);
    _addRandomTile(tiles);
    return GameBoard(tiles: tiles, score: 0);
  }

  @override
  Future<GameBoard> move(GameBoard board, Direction direction) async {
    List<List<int>> newTiles = _copyTiles(board.tiles);
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

    return GameBoard(tiles: newTiles, score: currentScore);
  }

  @override
  Future<HighScore> getHighScore() async {
    final result = await _database.select(_database.highScores).getSingleOrNull();
    return HighScore(score: result?.score ?? 0);
  }

  @override
  Future<void> saveHighScore(HighScore highScore) async {
    await _database.into(_database.highScores).insert(
          HighScoresCompanion.insert(score: highScore.score),
          mode: drift.InsertMode.insertOrReplace,
        );
  }

  List<List<int>> _copyTiles(List<List<int>> tiles) {
    return tiles.map((row) => List<int>.from(row)).toList();
  }

  void _addRandomTile(List<List<int>> tiles) {
    List<({int row, int col})> emptyCells = [];
    for (int r = 0; r < _boardSize; r++) {
      for (int c = 0; c < _boardSize; c++) {
        if (tiles[r][c] == 0) {
          emptyCells.add((row: r, col: c));
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      final int index = _random.nextInt(emptyCells.length);
      final ({int row, int col}) cell = emptyCells[index];
      tiles[cell.row][cell.col] = _random.nextDouble() < 0.9 ? 2 : 4;
    }
  }

  (bool, int) _moveUp(List<List<int>> tiles, int score) {
    bool moved = false;
    int newScore = score;
    for (int col = 0; col < _boardSize; col++) {
      List<int> column = [];
      for (int row = 0; row < _boardSize; row++) {
        if (tiles[row][col] != 0) {
          column.add(tiles[row][col]);
        }
      }

      final (mergedColumn, mergedScore) = _mergeTiles(column, newScore);
      newScore = mergedScore;
      List<int> newColumn = mergedColumn;
      while (newColumn.length < _boardSize) {
        newColumn.add(0);
      }

      for (int row = 0; row < _boardSize; row++) {
        if (tiles[row][col] != newColumn[row]) {
          moved = true;
        }
        tiles[row][col] = newColumn[row];
      }
    }
    return (moved, newScore);
  }

  (bool, int) _moveDown(List<List<int>> tiles, int score) {
    bool moved = false;
    int newScore = score;
    for (int col = 0; col < _boardSize; col++) {
      List<int> column = [];
      for (int row = _boardSize - 1; row >= 0; row--) {
        if (tiles[row][col] != 0) {
          column.add(tiles[row][col]);
        }
      }

      final (mergedColumn, mergedScore) = _mergeTiles(column, newScore);
      newScore = mergedScore;
      List<int> newColumn = mergedColumn;
      while (newColumn.length < _boardSize) {
        newColumn.add(0);
      }
      newColumn = newColumn.reversed.toList();

      for (int row = 0; row < _boardSize; row++) {
        if (tiles[row][col] != newColumn[row]) {
          moved = true;
        }
        tiles[row][col] = newColumn[row];
      }
    }
    return (moved, newScore);
  }

  (bool, int) _moveLeft(List<List<int>> tiles, int score) {
    bool moved = false;
    int newScore = score;
    for (int row = 0; row < _boardSize; row++) {
      List<int> currentRow = [];
      for (int col = 0; col < _boardSize; col++) {
        if (tiles[row][col] != 0) {
          currentRow.add(tiles[row][col]);
        }
      }

      final (mergedRow, mergedScore) = _mergeTiles(currentRow, newScore);
      newScore = mergedScore;
      List<int> newRow = mergedRow;
      while (newRow.length < _boardSize) {
        newRow.add(0);
      }

      for (int col = 0; col < _boardSize; col++) {
        if (tiles[row][col] != newRow[col]) {
          moved = true;
        }
        tiles[row][col] = newRow[col];
      }
    }
    return (moved, newScore);
  }

  (bool, int) _moveRight(List<List<int>> tiles, int score) {
    bool moved = false;
    int newScore = score;
    for (int row = 0; row < _boardSize; row++) {
      List<int> currentRow = [];
      for (int col = _boardSize - 1; col >= 0; col--) {
        if (tiles[row][col] != 0) {
          currentRow.add(tiles[row][col]);
        }
      }

      final (mergedRow, mergedScore) = _mergeTiles(currentRow, newScore);
      newScore = mergedScore;
      List<int> newRow = mergedRow;
      while (newRow.length < _boardSize) {
        newRow.add(0);
      }
      newRow = newRow.reversed.toList();

      for (int col = 0; col < _boardSize; col++) {
        if (tiles[row][col] != newRow[col]) {
          moved = true;
        }
        tiles[row][col] = newRow[col];
      }
    }
    return (moved, newScore);
  }

  (List<int>, int) _mergeTiles(List<int> line, int score) {
    List<int> newLine = [];
    int newScore = score;
    for (int i = 0; i < line.length; i++) {
      if (i + 1 < line.length && line[i] == line[i + 1]) {
        int mergedValue = line[i] * 2;
        newLine.add(mergedValue);
        newScore += mergedValue;
        i++;
      } else {
        newLine.add(line[i]);
      }
    }
    return (newLine, newScore);
  }
}
