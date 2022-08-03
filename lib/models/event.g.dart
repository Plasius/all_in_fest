// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Event extends _Event with RealmEntity, RealmObject {
  Event(
    ObjectId eventID, {
    String? name,
    String? stage,
    String? date,
    String? time,
    String? description,
    String? image,
  }) {
    RealmObject.set(this, '_id', eventID);
    RealmObject.set(this, 'name', name);
    RealmObject.set(this, 'stage', stage);
    RealmObject.set(this, 'date', date);
    RealmObject.set(this, 'time', time);
    RealmObject.set(this, 'description', description);
    RealmObject.set(this, 'image', image);
  }

  Event._();

  @override
  ObjectId get eventID => RealmObject.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set eventID(ObjectId value) => throw RealmUnsupportedSetError();

  @override
  String? get name => RealmObject.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObject.set(this, 'name', value);

  @override
  String? get stage => RealmObject.get<String>(this, 'stage') as String?;
  @override
  set stage(String? value) => RealmObject.set(this, 'stage', value);

  @override
  String? get date => RealmObject.get<String>(this, 'date') as String?;
  @override
  set date(String? value) => RealmObject.set(this, 'date', value);

  @override
  String? get time => RealmObject.get<String>(this, 'time') as String?;
  @override
  set time(String? value) => RealmObject.set(this, 'time', value);

  @override
  String? get description =>
      RealmObject.get<String>(this, 'description') as String?;
  @override
  set description(String? value) => RealmObject.set(this, 'description', value);

  @override
  String? get image => RealmObject.get<String>(this, 'image') as String?;
  @override
  set image(String? value) => RealmObject.set(this, 'image', value);

  @override
  Stream<RealmObjectChanges<Event>> get changes =>
      RealmObject.getChanges<Event>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Event._);
    return const SchemaObject(Event, 'Event', [
      SchemaProperty('_id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('stage', RealmPropertyType.string, optional: true),
      SchemaProperty('date', RealmPropertyType.string, optional: true),
      SchemaProperty('time', RealmPropertyType.string, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('image', RealmPropertyType.string, optional: true),
    ]);
  }
}
