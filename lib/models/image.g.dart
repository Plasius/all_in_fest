// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class UserImage extends _UserImage with RealmEntity, RealmObject {
  UserImage(
    String imageID,
    String data,
    String user,
  ) {
    RealmObject.set(this, '_id', imageID);
    RealmObject.set(this, 'data', data);
    RealmObject.set(this, 'user', user);
  }

  UserImage._();

  @override
  String get imageID => RealmObject.get<String>(this, '_id') as String;
  @override
  set imageID(String value) => throw RealmUnsupportedSetError();

  @override
  String get data => RealmObject.get<String>(this, 'data') as String;
  @override
  set data(String value) => RealmObject.set(this, 'data', value);

  @override
  String get user => RealmObject.get<String>(this, 'user') as String;
  @override
  set user(String value) => RealmObject.set(this, 'user', value);

  @override
  Stream<RealmObjectChanges<UserImage>> get changes =>
      RealmObject.getChanges<UserImage>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(UserImage._);
    return const SchemaObject(UserImage, 'UserImage', [
      SchemaProperty('_id', RealmPropertyType.string,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('data', RealmPropertyType.string),
      SchemaProperty('user', RealmPropertyType.string),
    ]);
  }
}
