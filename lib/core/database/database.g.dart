// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $HighScoresTable extends HighScores
    with TableInfo<$HighScoresTable, HighScore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HighScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boardSizeMeta = const VerificationMeta(
    'boardSize',
  );
  @override
  late final GeneratedColumn<int> boardSize = GeneratedColumn<int>(
    'board_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [score, boardSize];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'high_scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<HighScore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('board_size')) {
      context.handle(
        _boardSizeMeta,
        boardSize.isAcceptableOrUnknown(data['board_size']!, _boardSizeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {boardSize};
  @override
  HighScore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HighScore(
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      boardSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}board_size'],
      )!,
    );
  }

  @override
  $HighScoresTable createAlias(String alias) {
    return $HighScoresTable(attachedDatabase, alias);
  }
}

class HighScore extends DataClass implements Insertable<HighScore> {
  /// The score achieved in the game.
  final int score;

  /// The board size associated with the high score.
  final int boardSize;
  const HighScore({required this.score, required this.boardSize});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['score'] = Variable<int>(score);
    map['board_size'] = Variable<int>(boardSize);
    return map;
  }

  HighScoresCompanion toCompanion(bool nullToAbsent) {
    return HighScoresCompanion(
      score: Value(score),
      boardSize: Value(boardSize),
    );
  }

  factory HighScore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HighScore(
      score: serializer.fromJson<int>(json['score']),
      boardSize: serializer.fromJson<int>(json['boardSize']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'score': serializer.toJson<int>(score),
      'boardSize': serializer.toJson<int>(boardSize),
    };
  }

  HighScore copyWith({int? score, int? boardSize}) => HighScore(
    score: score ?? this.score,
    boardSize: boardSize ?? this.boardSize,
  );
  HighScore copyWithCompanion(HighScoresCompanion data) {
    return HighScore(
      score: data.score.present ? data.score.value : this.score,
      boardSize: data.boardSize.present ? data.boardSize.value : this.boardSize,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HighScore(')
          ..write('score: $score, ')
          ..write('boardSize: $boardSize')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(score, boardSize);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HighScore &&
          other.score == this.score &&
          other.boardSize == this.boardSize);
}

class HighScoresCompanion extends UpdateCompanion<HighScore> {
  final Value<int> score;
  final Value<int> boardSize;
  const HighScoresCompanion({
    this.score = const Value.absent(),
    this.boardSize = const Value.absent(),
  });
  HighScoresCompanion.insert({
    required int score,
    this.boardSize = const Value.absent(),
  }) : score = Value(score);
  static Insertable<HighScore> custom({
    Expression<int>? score,
    Expression<int>? boardSize,
  }) {
    return RawValuesInsertable({
      if (score != null) 'score': score,
      if (boardSize != null) 'board_size': boardSize,
    });
  }

  HighScoresCompanion copyWith({Value<int>? score, Value<int>? boardSize}) {
    return HighScoresCompanion(
      score: score ?? this.score,
      boardSize: boardSize ?? this.boardSize,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (boardSize.present) {
      map['board_size'] = Variable<int>(boardSize.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HighScoresCompanion(')
          ..write('score: $score, ')
          ..write('boardSize: $boardSize')
          ..write(')'))
        .toString();
  }
}

class $GameStatesTable extends GameStates
    with TableInfo<$GameStatesTable, GameState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _boardMeta = const VerificationMeta('board');
  @override
  late final GeneratedColumn<String> board = GeneratedColumn<String>(
    'board',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boardSizeMeta = const VerificationMeta(
    'boardSize',
  );
  @override
  late final GeneratedColumn<int> boardSize = GeneratedColumn<int>(
    'board_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    board,
    score,
    createdAt,
    boardSize,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('board')) {
      context.handle(
        _boardMeta,
        board.isAcceptableOrUnknown(data['board']!, _boardMeta),
      );
    } else if (isInserting) {
      context.missing(_boardMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('board_size')) {
      context.handle(
        _boardSizeMeta,
        boardSize.isAcceptableOrUnknown(data['board_size']!, _boardSizeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      board: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}board'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      boardSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}board_size'],
      )!,
    );
  }

  @override
  $GameStatesTable createAlias(String alias) {
    return $GameStatesTable(attachedDatabase, alias);
  }
}

class GameState extends DataClass implements Insertable<GameState> {
  /// The ID of the game state entry.
  /// Defaults to 1, ensuring a single entry for the game state.
  final int id;

  /// A JSON string representation of the game board.
  final String board;

  /// The score of the game.
  final int score;

  /// The timestamp when the state was saved.
  final DateTime createdAt;

  /// The grid size of the board when this game state was saved.
  final int boardSize;
  const GameState({
    required this.id,
    required this.board,
    required this.score,
    required this.createdAt,
    required this.boardSize,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['board'] = Variable<String>(board);
    map['score'] = Variable<int>(score);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['board_size'] = Variable<int>(boardSize);
    return map;
  }

  GameStatesCompanion toCompanion(bool nullToAbsent) {
    return GameStatesCompanion(
      id: Value(id),
      board: Value(board),
      score: Value(score),
      createdAt: Value(createdAt),
      boardSize: Value(boardSize),
    );
  }

  factory GameState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameState(
      id: serializer.fromJson<int>(json['id']),
      board: serializer.fromJson<String>(json['board']),
      score: serializer.fromJson<int>(json['score']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      boardSize: serializer.fromJson<int>(json['boardSize']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'board': serializer.toJson<String>(board),
      'score': serializer.toJson<int>(score),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'boardSize': serializer.toJson<int>(boardSize),
    };
  }

  GameState copyWith({
    int? id,
    String? board,
    int? score,
    DateTime? createdAt,
    int? boardSize,
  }) => GameState(
    id: id ?? this.id,
    board: board ?? this.board,
    score: score ?? this.score,
    createdAt: createdAt ?? this.createdAt,
    boardSize: boardSize ?? this.boardSize,
  );
  GameState copyWithCompanion(GameStatesCompanion data) {
    return GameState(
      id: data.id.present ? data.id.value : this.id,
      board: data.board.present ? data.board.value : this.board,
      score: data.score.present ? data.score.value : this.score,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      boardSize: data.boardSize.present ? data.boardSize.value : this.boardSize,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameState(')
          ..write('id: $id, ')
          ..write('board: $board, ')
          ..write('score: $score, ')
          ..write('createdAt: $createdAt, ')
          ..write('boardSize: $boardSize')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, board, score, createdAt, boardSize);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameState &&
          other.id == this.id &&
          other.board == this.board &&
          other.score == this.score &&
          other.createdAt == this.createdAt &&
          other.boardSize == this.boardSize);
}

class GameStatesCompanion extends UpdateCompanion<GameState> {
  final Value<int> id;
  final Value<String> board;
  final Value<int> score;
  final Value<DateTime> createdAt;
  final Value<int> boardSize;
  const GameStatesCompanion({
    this.id = const Value.absent(),
    this.board = const Value.absent(),
    this.score = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.boardSize = const Value.absent(),
  });
  GameStatesCompanion.insert({
    this.id = const Value.absent(),
    required String board,
    required int score,
    required DateTime createdAt,
    this.boardSize = const Value.absent(),
  }) : board = Value(board),
       score = Value(score),
       createdAt = Value(createdAt);
  static Insertable<GameState> custom({
    Expression<int>? id,
    Expression<String>? board,
    Expression<int>? score,
    Expression<DateTime>? createdAt,
    Expression<int>? boardSize,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (board != null) 'board': board,
      if (score != null) 'score': score,
      if (createdAt != null) 'created_at': createdAt,
      if (boardSize != null) 'board_size': boardSize,
    });
  }

  GameStatesCompanion copyWith({
    Value<int>? id,
    Value<String>? board,
    Value<int>? score,
    Value<DateTime>? createdAt,
    Value<int>? boardSize,
  }) {
    return GameStatesCompanion(
      id: id ?? this.id,
      board: board ?? this.board,
      score: score ?? this.score,
      createdAt: createdAt ?? this.createdAt,
      boardSize: boardSize ?? this.boardSize,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (board.present) {
      map['board'] = Variable<String>(board.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (boardSize.present) {
      map['board_size'] = Variable<int>(boardSize.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameStatesCompanion(')
          ..write('id: $id, ')
          ..write('board: $board, ')
          ..write('score: $score, ')
          ..write('createdAt: $createdAt, ')
          ..write('boardSize: $boardSize')
          ..write(')'))
        .toString();
  }
}

class $AudioSettingsTable extends AudioSettings
    with TableInfo<$AudioSettingsTable, AudioSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudioSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _isMusicEnabledMeta = const VerificationMeta(
    'isMusicEnabled',
  );
  @override
  late final GeneratedColumn<bool> isMusicEnabled = GeneratedColumn<bool>(
    'is_music_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_music_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isSoundEffectsEnabledMeta =
      const VerificationMeta('isSoundEffectsEnabled');
  @override
  late final GeneratedColumn<bool> isSoundEffectsEnabled =
      GeneratedColumn<bool>(
        'is_sound_effects_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_sound_effects_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    isMusicEnabled,
    isSoundEffectsEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audio_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AudioSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('is_music_enabled')) {
      context.handle(
        _isMusicEnabledMeta,
        isMusicEnabled.isAcceptableOrUnknown(
          data['is_music_enabled']!,
          _isMusicEnabledMeta,
        ),
      );
    }
    if (data.containsKey('is_sound_effects_enabled')) {
      context.handle(
        _isSoundEffectsEnabledMeta,
        isSoundEffectsEnabled.isAcceptableOrUnknown(
          data['is_sound_effects_enabled']!,
          _isSoundEffectsEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AudioSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudioSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      isMusicEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_music_enabled'],
      )!,
      isSoundEffectsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_sound_effects_enabled'],
      )!,
    );
  }

  @override
  $AudioSettingsTable createAlias(String alias) {
    return $AudioSettingsTable(attachedDatabase, alias);
  }
}

class AudioSetting extends DataClass implements Insertable<AudioSetting> {
  /// The ID of the audio setting entry.
  final int id;

  /// Whether in-game music is enabled.
  final bool isMusicEnabled;

  /// Whether in-game sound effects are enabled.
  final bool isSoundEffectsEnabled;
  const AudioSetting({
    required this.id,
    required this.isMusicEnabled,
    required this.isSoundEffectsEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['is_music_enabled'] = Variable<bool>(isMusicEnabled);
    map['is_sound_effects_enabled'] = Variable<bool>(isSoundEffectsEnabled);
    return map;
  }

  AudioSettingsCompanion toCompanion(bool nullToAbsent) {
    return AudioSettingsCompanion(
      id: Value(id),
      isMusicEnabled: Value(isMusicEnabled),
      isSoundEffectsEnabled: Value(isSoundEffectsEnabled),
    );
  }

  factory AudioSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudioSetting(
      id: serializer.fromJson<int>(json['id']),
      isMusicEnabled: serializer.fromJson<bool>(json['isMusicEnabled']),
      isSoundEffectsEnabled: serializer.fromJson<bool>(
        json['isSoundEffectsEnabled'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isMusicEnabled': serializer.toJson<bool>(isMusicEnabled),
      'isSoundEffectsEnabled': serializer.toJson<bool>(isSoundEffectsEnabled),
    };
  }

  AudioSetting copyWith({
    int? id,
    bool? isMusicEnabled,
    bool? isSoundEffectsEnabled,
  }) => AudioSetting(
    id: id ?? this.id,
    isMusicEnabled: isMusicEnabled ?? this.isMusicEnabled,
    isSoundEffectsEnabled: isSoundEffectsEnabled ?? this.isSoundEffectsEnabled,
  );
  AudioSetting copyWithCompanion(AudioSettingsCompanion data) {
    return AudioSetting(
      id: data.id.present ? data.id.value : this.id,
      isMusicEnabled: data.isMusicEnabled.present
          ? data.isMusicEnabled.value
          : this.isMusicEnabled,
      isSoundEffectsEnabled: data.isSoundEffectsEnabled.present
          ? data.isSoundEffectsEnabled.value
          : this.isSoundEffectsEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudioSetting(')
          ..write('id: $id, ')
          ..write('isMusicEnabled: $isMusicEnabled, ')
          ..write('isSoundEffectsEnabled: $isSoundEffectsEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, isMusicEnabled, isSoundEffectsEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioSetting &&
          other.id == this.id &&
          other.isMusicEnabled == this.isMusicEnabled &&
          other.isSoundEffectsEnabled == this.isSoundEffectsEnabled);
}

class AudioSettingsCompanion extends UpdateCompanion<AudioSetting> {
  final Value<int> id;
  final Value<bool> isMusicEnabled;
  final Value<bool> isSoundEffectsEnabled;
  const AudioSettingsCompanion({
    this.id = const Value.absent(),
    this.isMusicEnabled = const Value.absent(),
    this.isSoundEffectsEnabled = const Value.absent(),
  });
  AudioSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.isMusicEnabled = const Value.absent(),
    this.isSoundEffectsEnabled = const Value.absent(),
  });
  static Insertable<AudioSetting> custom({
    Expression<int>? id,
    Expression<bool>? isMusicEnabled,
    Expression<bool>? isSoundEffectsEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isMusicEnabled != null) 'is_music_enabled': isMusicEnabled,
      if (isSoundEffectsEnabled != null)
        'is_sound_effects_enabled': isSoundEffectsEnabled,
    });
  }

  AudioSettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? isMusicEnabled,
    Value<bool>? isSoundEffectsEnabled,
  }) {
    return AudioSettingsCompanion(
      id: id ?? this.id,
      isMusicEnabled: isMusicEnabled ?? this.isMusicEnabled,
      isSoundEffectsEnabled:
          isSoundEffectsEnabled ?? this.isSoundEffectsEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isMusicEnabled.present) {
      map['is_music_enabled'] = Variable<bool>(isMusicEnabled.value);
    }
    if (isSoundEffectsEnabled.present) {
      map['is_sound_effects_enabled'] = Variable<bool>(
        isSoundEffectsEnabled.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudioSettingsCompanion(')
          ..write('id: $id, ')
          ..write('isMusicEnabled: $isMusicEnabled, ')
          ..write('isSoundEffectsEnabled: $isSoundEffectsEnabled')
          ..write(')'))
        .toString();
  }
}

class $GameModeSettingsTable extends GameModeSettings
    with TableInfo<$GameModeSettingsTable, GameModeSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameModeSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _boardSizeMeta = const VerificationMeta(
    'boardSize',
  );
  @override
  late final GeneratedColumn<int> boardSize = GeneratedColumn<int>(
    'board_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _tilesToSpawnMeta = const VerificationMeta(
    'tilesToSpawn',
  );
  @override
  late final GeneratedColumn<int> tilesToSpawn = GeneratedColumn<int>(
    'tiles_to_spawn',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [id, boardSize, tilesToSpawn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_mode_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameModeSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('board_size')) {
      context.handle(
        _boardSizeMeta,
        boardSize.isAcceptableOrUnknown(data['board_size']!, _boardSizeMeta),
      );
    }
    if (data.containsKey('tiles_to_spawn')) {
      context.handle(
        _tilesToSpawnMeta,
        tilesToSpawn.isAcceptableOrUnknown(
          data['tiles_to_spawn']!,
          _tilesToSpawnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameModeSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameModeSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      boardSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}board_size'],
      )!,
      tilesToSpawn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tiles_to_spawn'],
      )!,
    );
  }

  @override
  $GameModeSettingsTable createAlias(String alias) {
    return $GameModeSettingsTable(attachedDatabase, alias);
  }
}

class GameModeSetting extends DataClass implements Insertable<GameModeSetting> {
  /// The ID of the game mode setting entry.
  final int id;

  /// The grid size for the game board (e.g., 4, 5, or 6).
  final int boardSize;

  /// The number of new tiles to add per move.
  final int tilesToSpawn;
  const GameModeSetting({
    required this.id,
    required this.boardSize,
    required this.tilesToSpawn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['board_size'] = Variable<int>(boardSize);
    map['tiles_to_spawn'] = Variable<int>(tilesToSpawn);
    return map;
  }

  GameModeSettingsCompanion toCompanion(bool nullToAbsent) {
    return GameModeSettingsCompanion(
      id: Value(id),
      boardSize: Value(boardSize),
      tilesToSpawn: Value(tilesToSpawn),
    );
  }

  factory GameModeSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameModeSetting(
      id: serializer.fromJson<int>(json['id']),
      boardSize: serializer.fromJson<int>(json['boardSize']),
      tilesToSpawn: serializer.fromJson<int>(json['tilesToSpawn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'boardSize': serializer.toJson<int>(boardSize),
      'tilesToSpawn': serializer.toJson<int>(tilesToSpawn),
    };
  }

  GameModeSetting copyWith({int? id, int? boardSize, int? tilesToSpawn}) =>
      GameModeSetting(
        id: id ?? this.id,
        boardSize: boardSize ?? this.boardSize,
        tilesToSpawn: tilesToSpawn ?? this.tilesToSpawn,
      );
  GameModeSetting copyWithCompanion(GameModeSettingsCompanion data) {
    return GameModeSetting(
      id: data.id.present ? data.id.value : this.id,
      boardSize: data.boardSize.present ? data.boardSize.value : this.boardSize,
      tilesToSpawn: data.tilesToSpawn.present
          ? data.tilesToSpawn.value
          : this.tilesToSpawn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameModeSetting(')
          ..write('id: $id, ')
          ..write('boardSize: $boardSize, ')
          ..write('tilesToSpawn: $tilesToSpawn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, boardSize, tilesToSpawn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameModeSetting &&
          other.id == this.id &&
          other.boardSize == this.boardSize &&
          other.tilesToSpawn == this.tilesToSpawn);
}

class GameModeSettingsCompanion extends UpdateCompanion<GameModeSetting> {
  final Value<int> id;
  final Value<int> boardSize;
  final Value<int> tilesToSpawn;
  const GameModeSettingsCompanion({
    this.id = const Value.absent(),
    this.boardSize = const Value.absent(),
    this.tilesToSpawn = const Value.absent(),
  });
  GameModeSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.boardSize = const Value.absent(),
    this.tilesToSpawn = const Value.absent(),
  });
  static Insertable<GameModeSetting> custom({
    Expression<int>? id,
    Expression<int>? boardSize,
    Expression<int>? tilesToSpawn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (boardSize != null) 'board_size': boardSize,
      if (tilesToSpawn != null) 'tiles_to_spawn': tilesToSpawn,
    });
  }

  GameModeSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? boardSize,
    Value<int>? tilesToSpawn,
  }) {
    return GameModeSettingsCompanion(
      id: id ?? this.id,
      boardSize: boardSize ?? this.boardSize,
      tilesToSpawn: tilesToSpawn ?? this.tilesToSpawn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (boardSize.present) {
      map['board_size'] = Variable<int>(boardSize.value);
    }
    if (tilesToSpawn.present) {
      map['tiles_to_spawn'] = Variable<int>(tilesToSpawn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameModeSettingsCompanion(')
          ..write('id: $id, ')
          ..write('boardSize: $boardSize, ')
          ..write('tilesToSpawn: $tilesToSpawn')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HighScoresTable highScores = $HighScoresTable(this);
  late final $GameStatesTable gameStates = $GameStatesTable(this);
  late final $AudioSettingsTable audioSettings = $AudioSettingsTable(this);
  late final $GameModeSettingsTable gameModeSettings = $GameModeSettingsTable(
    this,
  );
  late final GameStateDao gameStateDao = GameStateDao(this as AppDatabase);
  late final HighScoreDao highScoreDao = HighScoreDao(this as AppDatabase);
  late final AudioSettingsDao audioSettingsDao = AudioSettingsDao(
    this as AppDatabase,
  );
  late final GameModeSettingsDao gameModeSettingsDao = GameModeSettingsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    highScores,
    gameStates,
    audioSettings,
    gameModeSettings,
  ];
}

typedef $$HighScoresTableCreateCompanionBuilder =
    HighScoresCompanion Function({required int score, Value<int> boardSize});
typedef $$HighScoresTableUpdateCompanionBuilder =
    HighScoresCompanion Function({Value<int> score, Value<int> boardSize});

class $$HighScoresTableFilterComposer
    extends Composer<_$AppDatabase, $HighScoresTable> {
  $$HighScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get boardSize => $composableBuilder(
    column: $table.boardSize,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HighScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $HighScoresTable> {
  $$HighScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get boardSize => $composableBuilder(
    column: $table.boardSize,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HighScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $HighScoresTable> {
  $$HighScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get boardSize =>
      $composableBuilder(column: $table.boardSize, builder: (column) => column);
}

class $$HighScoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HighScoresTable,
          HighScore,
          $$HighScoresTableFilterComposer,
          $$HighScoresTableOrderingComposer,
          $$HighScoresTableAnnotationComposer,
          $$HighScoresTableCreateCompanionBuilder,
          $$HighScoresTableUpdateCompanionBuilder,
          (
            HighScore,
            BaseReferences<_$AppDatabase, $HighScoresTable, HighScore>,
          ),
          HighScore,
          PrefetchHooks Function()
        > {
  $$HighScoresTableTableManager(_$AppDatabase db, $HighScoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HighScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HighScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HighScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> score = const Value.absent(),
                Value<int> boardSize = const Value.absent(),
              }) => HighScoresCompanion(score: score, boardSize: boardSize),
          createCompanionCallback:
              ({
                required int score,
                Value<int> boardSize = const Value.absent(),
              }) => HighScoresCompanion.insert(
                score: score,
                boardSize: boardSize,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HighScoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HighScoresTable,
      HighScore,
      $$HighScoresTableFilterComposer,
      $$HighScoresTableOrderingComposer,
      $$HighScoresTableAnnotationComposer,
      $$HighScoresTableCreateCompanionBuilder,
      $$HighScoresTableUpdateCompanionBuilder,
      (HighScore, BaseReferences<_$AppDatabase, $HighScoresTable, HighScore>),
      HighScore,
      PrefetchHooks Function()
    >;
typedef $$GameStatesTableCreateCompanionBuilder =
    GameStatesCompanion Function({
      Value<int> id,
      required String board,
      required int score,
      required DateTime createdAt,
      Value<int> boardSize,
    });
typedef $$GameStatesTableUpdateCompanionBuilder =
    GameStatesCompanion Function({
      Value<int> id,
      Value<String> board,
      Value<int> score,
      Value<DateTime> createdAt,
      Value<int> boardSize,
    });

class $$GameStatesTableFilterComposer
    extends Composer<_$AppDatabase, $GameStatesTable> {
  $$GameStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get board => $composableBuilder(
    column: $table.board,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get boardSize => $composableBuilder(
    column: $table.boardSize,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GameStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $GameStatesTable> {
  $$GameStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get board => $composableBuilder(
    column: $table.board,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get boardSize => $composableBuilder(
    column: $table.boardSize,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameStatesTable> {
  $$GameStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get board =>
      $composableBuilder(column: $table.board, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get boardSize =>
      $composableBuilder(column: $table.boardSize, builder: (column) => column);
}

class $$GameStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameStatesTable,
          GameState,
          $$GameStatesTableFilterComposer,
          $$GameStatesTableOrderingComposer,
          $$GameStatesTableAnnotationComposer,
          $$GameStatesTableCreateCompanionBuilder,
          $$GameStatesTableUpdateCompanionBuilder,
          (
            GameState,
            BaseReferences<_$AppDatabase, $GameStatesTable, GameState>,
          ),
          GameState,
          PrefetchHooks Function()
        > {
  $$GameStatesTableTableManager(_$AppDatabase db, $GameStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> board = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> boardSize = const Value.absent(),
              }) => GameStatesCompanion(
                id: id,
                board: board,
                score: score,
                createdAt: createdAt,
                boardSize: boardSize,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String board,
                required int score,
                required DateTime createdAt,
                Value<int> boardSize = const Value.absent(),
              }) => GameStatesCompanion.insert(
                id: id,
                board: board,
                score: score,
                createdAt: createdAt,
                boardSize: boardSize,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GameStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameStatesTable,
      GameState,
      $$GameStatesTableFilterComposer,
      $$GameStatesTableOrderingComposer,
      $$GameStatesTableAnnotationComposer,
      $$GameStatesTableCreateCompanionBuilder,
      $$GameStatesTableUpdateCompanionBuilder,
      (GameState, BaseReferences<_$AppDatabase, $GameStatesTable, GameState>),
      GameState,
      PrefetchHooks Function()
    >;
typedef $$AudioSettingsTableCreateCompanionBuilder =
    AudioSettingsCompanion Function({
      Value<int> id,
      Value<bool> isMusicEnabled,
      Value<bool> isSoundEffectsEnabled,
    });
typedef $$AudioSettingsTableUpdateCompanionBuilder =
    AudioSettingsCompanion Function({
      Value<int> id,
      Value<bool> isMusicEnabled,
      Value<bool> isSoundEffectsEnabled,
    });

class $$AudioSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AudioSettingsTable> {
  $$AudioSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMusicEnabled => $composableBuilder(
    column: $table.isMusicEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSoundEffectsEnabled => $composableBuilder(
    column: $table.isSoundEffectsEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AudioSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AudioSettingsTable> {
  $$AudioSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMusicEnabled => $composableBuilder(
    column: $table.isMusicEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSoundEffectsEnabled => $composableBuilder(
    column: $table.isSoundEffectsEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AudioSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AudioSettingsTable> {
  $$AudioSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isMusicEnabled => $composableBuilder(
    column: $table.isMusicEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSoundEffectsEnabled => $composableBuilder(
    column: $table.isSoundEffectsEnabled,
    builder: (column) => column,
  );
}

class $$AudioSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AudioSettingsTable,
          AudioSetting,
          $$AudioSettingsTableFilterComposer,
          $$AudioSettingsTableOrderingComposer,
          $$AudioSettingsTableAnnotationComposer,
          $$AudioSettingsTableCreateCompanionBuilder,
          $$AudioSettingsTableUpdateCompanionBuilder,
          (
            AudioSetting,
            BaseReferences<_$AppDatabase, $AudioSettingsTable, AudioSetting>,
          ),
          AudioSetting,
          PrefetchHooks Function()
        > {
  $$AudioSettingsTableTableManager(_$AppDatabase db, $AudioSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudioSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AudioSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AudioSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> isMusicEnabled = const Value.absent(),
                Value<bool> isSoundEffectsEnabled = const Value.absent(),
              }) => AudioSettingsCompanion(
                id: id,
                isMusicEnabled: isMusicEnabled,
                isSoundEffectsEnabled: isSoundEffectsEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> isMusicEnabled = const Value.absent(),
                Value<bool> isSoundEffectsEnabled = const Value.absent(),
              }) => AudioSettingsCompanion.insert(
                id: id,
                isMusicEnabled: isMusicEnabled,
                isSoundEffectsEnabled: isSoundEffectsEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AudioSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AudioSettingsTable,
      AudioSetting,
      $$AudioSettingsTableFilterComposer,
      $$AudioSettingsTableOrderingComposer,
      $$AudioSettingsTableAnnotationComposer,
      $$AudioSettingsTableCreateCompanionBuilder,
      $$AudioSettingsTableUpdateCompanionBuilder,
      (
        AudioSetting,
        BaseReferences<_$AppDatabase, $AudioSettingsTable, AudioSetting>,
      ),
      AudioSetting,
      PrefetchHooks Function()
    >;
typedef $$GameModeSettingsTableCreateCompanionBuilder =
    GameModeSettingsCompanion Function({
      Value<int> id,
      Value<int> boardSize,
      Value<int> tilesToSpawn,
    });
typedef $$GameModeSettingsTableUpdateCompanionBuilder =
    GameModeSettingsCompanion Function({
      Value<int> id,
      Value<int> boardSize,
      Value<int> tilesToSpawn,
    });

class $$GameModeSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $GameModeSettingsTable> {
  $$GameModeSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get boardSize => $composableBuilder(
    column: $table.boardSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tilesToSpawn => $composableBuilder(
    column: $table.tilesToSpawn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GameModeSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $GameModeSettingsTable> {
  $$GameModeSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get boardSize => $composableBuilder(
    column: $table.boardSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tilesToSpawn => $composableBuilder(
    column: $table.tilesToSpawn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameModeSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameModeSettingsTable> {
  $$GameModeSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get boardSize =>
      $composableBuilder(column: $table.boardSize, builder: (column) => column);

  GeneratedColumn<int> get tilesToSpawn => $composableBuilder(
    column: $table.tilesToSpawn,
    builder: (column) => column,
  );
}

class $$GameModeSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameModeSettingsTable,
          GameModeSetting,
          $$GameModeSettingsTableFilterComposer,
          $$GameModeSettingsTableOrderingComposer,
          $$GameModeSettingsTableAnnotationComposer,
          $$GameModeSettingsTableCreateCompanionBuilder,
          $$GameModeSettingsTableUpdateCompanionBuilder,
          (
            GameModeSetting,
            BaseReferences<
              _$AppDatabase,
              $GameModeSettingsTable,
              GameModeSetting
            >,
          ),
          GameModeSetting,
          PrefetchHooks Function()
        > {
  $$GameModeSettingsTableTableManager(
    _$AppDatabase db,
    $GameModeSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameModeSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameModeSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameModeSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> boardSize = const Value.absent(),
                Value<int> tilesToSpawn = const Value.absent(),
              }) => GameModeSettingsCompanion(
                id: id,
                boardSize: boardSize,
                tilesToSpawn: tilesToSpawn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> boardSize = const Value.absent(),
                Value<int> tilesToSpawn = const Value.absent(),
              }) => GameModeSettingsCompanion.insert(
                id: id,
                boardSize: boardSize,
                tilesToSpawn: tilesToSpawn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GameModeSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameModeSettingsTable,
      GameModeSetting,
      $$GameModeSettingsTableFilterComposer,
      $$GameModeSettingsTableOrderingComposer,
      $$GameModeSettingsTableAnnotationComposer,
      $$GameModeSettingsTableCreateCompanionBuilder,
      $$GameModeSettingsTableUpdateCompanionBuilder,
      (
        GameModeSetting,
        BaseReferences<_$AppDatabase, $GameModeSettingsTable, GameModeSetting>,
      ),
      GameModeSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HighScoresTableTableManager get highScores =>
      $$HighScoresTableTableManager(_db, _db.highScores);
  $$GameStatesTableTableManager get gameStates =>
      $$GameStatesTableTableManager(_db, _db.gameStates);
  $$AudioSettingsTableTableManager get audioSettings =>
      $$AudioSettingsTableTableManager(_db, _db.audioSettings);
  $$GameModeSettingsTableTableManager get gameModeSettings =>
      $$GameModeSettingsTableTableManager(_db, _db.gameModeSettings);
}

mixin _$GameStateDaoMixin on DatabaseAccessor<AppDatabase> {
  $GameStatesTable get gameStates => attachedDatabase.gameStates;
}
mixin _$HighScoreDaoMixin on DatabaseAccessor<AppDatabase> {
  $HighScoresTable get highScores => attachedDatabase.highScores;
}
mixin _$AudioSettingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $AudioSettingsTable get audioSettings => attachedDatabase.audioSettings;
}
mixin _$GameModeSettingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $GameModeSettingsTable get gameModeSettings =>
      attachedDatabase.gameModeSettings;
}
