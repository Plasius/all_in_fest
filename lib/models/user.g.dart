// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class User extends _User with RealmEntity, RealmObject {
  User(
    String userID, {
    String? name,
    String? bio,
    int? since,
  }) {
    RealmObject.set(this, 'userID', userID);
    RealmObject.set(this, 'name', name);
    RealmObject.set(this, 'bio', bio);
    RealmObject.set(this, 'since', since);
  }

  User._();

  @override
  String get userID => RealmObject.get<String>(this, 'userID') as String;
  @override
  set userID(String value) => throw RealmUnsupportedSetError();

  @override
  String? get name => RealmObject.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObject.set(this, 'name', value);

  @override
  String? get bio => RealmObject.get<String>(this, 'bio') as String?;
  @override
  set bio(String? value) => RealmObject.set(this, 'bio', value);

  @override
  int? get since => RealmObject.get<int>(this, 'since') as int?;
  @override
  set since(int? value) => RealmObject.set(this, 'since', value);

  @override
  Stream<RealmObjectChanges<User>> get changes =>
      RealmObject.getChanges<User>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(User._);
    return const SchemaObject(User, [
      SchemaProperty('userID', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('bio', RealmPropertyType.string, optional: true),
      SchemaProperty('since', RealmPropertyType.int, optional: true),
    ]);
  }
}
