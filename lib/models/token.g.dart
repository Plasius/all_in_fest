// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Token extends _Token with RealmEntity, RealmObject {
  Token(
    String userID, {
    String? token,
  }) {
    RealmObject.set(this, '_id', userID);
    RealmObject.set(this, 'token', token);
  }

  Token._();

  @override
  String get userID => RealmObject.get<String>(this, '_id') as String;
  @override
  set userID(String value) => throw RealmUnsupportedSetError();

  @override
  String? get token => RealmObject.get<String>(this, 'token') as String?;
  @override
  set token(String? value) => RealmObject.set(this, 'token', value);

  @override
  Stream<RealmObjectChanges<Token>> get changes =>
      RealmObject.getChanges<Token>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Token._);
    return const SchemaObject(Token, 'Token', [
      SchemaProperty('_id', RealmPropertyType.string,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('token', RealmPropertyType.string, optional: true),
    ]);
  }
}
