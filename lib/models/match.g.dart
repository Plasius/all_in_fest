// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Match extends _Match with RealmEntity, RealmObject {
  Match(
    String matchID, {
    String? user1,
    String? user2,
  }) {
    RealmObject.set(this, '_id', matchID);
    RealmObject.set(this, 'user1', user1);
    RealmObject.set(this, 'user2', user2);
  }

  Match._();

  @override
  String get matchID => RealmObject.get<String>(this, '_id') as String;
  @override
  set matchID(String value) => throw RealmUnsupportedSetError();

  @override
  String? get user1 => RealmObject.get<String>(this, 'user1') as String?;
  @override
  set user1(String? value) => RealmObject.set(this, 'user1', value);

  @override
  String? get user2 => RealmObject.get<String>(this, 'user2') as String?;
  @override
  set user2(String? value) => RealmObject.set(this, 'user2', value);

  @override
  Stream<RealmObjectChanges<Match>> get changes =>
      RealmObject.getChanges<Match>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Match._);
    return const SchemaObject(Match, 'Match', [
      SchemaProperty('_id', RealmPropertyType.string,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('user1', RealmPropertyType.string, optional: true),
      SchemaProperty('user2', RealmPropertyType.string, optional: true),
    ]);
  }
}
