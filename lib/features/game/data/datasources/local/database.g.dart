// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $HighScoresTable extends HighScores
    with TableInfo<$HighScoresTable, HighScore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HighScoresTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, score];
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HighScore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HighScore(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
    );
  }

  @override
  $HighScoresTable createAlias(String alias) {
    return $HighScoresTable(attachedDatabase, alias);
  }
}

class HighScore extends DataClass implements Insertable<HighScore> {
  final int id;
  final int score;
  const HighScore({required this.id, required this.score});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['score'] = Variable<int>(score);
    return map;
  }

  HighScoresCompanion toCompanion(bool nullToAbsent) {
    return HighScoresCompanion(id: Value(id), score: Value(score));
  }

  factory HighScore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HighScore(
      id: serializer.fromJson<int>(json['id']),
      score: serializer.fromJson<int>(json['score']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'score': serializer.toJson<int>(score),
    };
  }

  HighScore copyWith({int? id, int? score}) =>
      HighScore(id: id ?? this.id, score: score ?? this.score);
  HighScore copyWithCompanion(HighScoresCompanion data) {
    return HighScore(
      id: data.id.present ? data.id.value : this.id,
      score: data.score.present ? data.score.value : this.score,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HighScore(')
          ..write('id: $id, ')
          ..write('score: $score')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, score);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HighScore && other.id == this.id && other.score == this.score);
}

class HighScoresCompanion extends UpdateCompanion<HighScore> {
  final Value<int> id;
  final Value<int> score;
  const HighScoresCompanion({
    this.id = const Value.absent(),
    this.score = const Value.absent(),
  });
  HighScoresCompanion.insert({
    this.id = const Value.absent(),
    required int score,
  }) : score = Value(score);
  static Insertable<HighScore> custom({
    Expression<int>? id,
    Expression<int>? score,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (score != null) 'score': score,
    });
  }

  HighScoresCompanion copyWith({Value<int>? id, Value<int>? score}) {
    return HighScoresCompanion(id: id ?? this.id, score: score ?? this.score);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HighScoresCompanion(')
          ..write('id: $id, ')
          ..write('score: $score')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HighScoresTable highScores = $HighScoresTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [highScores];
}

typedef $$HighScoresTableCreateCompanionBuilder =
    HighScoresCompanion Function({Value<int> id, required int score});
typedef $$HighScoresTableUpdateCompanionBuilder =
    HighScoresCompanion Function({Value<int> id, Value<int> score});

class $$HighScoresTableFilterComposer
    extends Composer<_$AppDatabase, $HighScoresTable> {
  $$HighScoresTableFilterComposer({
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

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
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
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);
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
                Value<int> id = const Value.absent(),
                Value<int> score = const Value.absent(),
              }) => HighScoresCompanion(id: id, score: score),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required int score}) =>
                  HighScoresCompanion.insert(id: id, score: score),
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HighScoresTableTableManager get highScores =>
      $$HighScoresTableTableManager(_db, _db.highScores);
}
