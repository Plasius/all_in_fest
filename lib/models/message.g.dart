// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Message extends _Message with RealmEntity, RealmObject {
  Message(
    String messageID, {
    String? from,
    String? message,
    int? datetime,
    String? matchID,
  }) {
    RealmObject.set(this, '_id', messageID);
    RealmObject.set(this, 'from', from);
    RealmObject.set(this, 'message', message);
    RealmObject.set(this, 'datetime', datetime);
    RealmObject.set(this, 'matchID', matchID);
  }

  Message._();

  @override
  String get messageID => RealmObject.get<String>(this, '_id') as String;
  @override
  set messageID(String value) => throw RealmUnsupportedSetError();

  @override
  String? get from => RealmObject.get<String>(this, 'from') as String?;
  @override
  set from(String? value) => RealmObject.set(this, 'from', value);

  @override
  String? get message => RealmObject.get<String>(this, 'message') as String?;
  @override
  set message(String? value) => RealmObject.set(this, 'message', value);

  @override
  int? get datetime => RealmObject.get<int>(this, 'datetime') as int?;
  @override
  set datetime(int? value) => RealmObject.set(this, 'datetime', value);

  @override
  String? get matchID => RealmObject.get<String>(this, 'matchID') as String?;
  @override
  set matchID(String? value) => RealmObject.set(this, 'matchID', value);

  @override
  Stream<RealmObjectChanges<Message>> get changes =>
      RealmObject.getChanges<Message>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Message._);
    return const SchemaObject(Message, 'Message', [
      SchemaProperty('_id', RealmPropertyType.string,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('from', RealmPropertyType.string, optional: true),
      SchemaProperty('message', RealmPropertyType.string, optional: true),
      SchemaProperty('datetime', RealmPropertyType.int, optional: true),
      SchemaProperty('matchID', RealmPropertyType.string, optional: true),
    ]);
  }
}
