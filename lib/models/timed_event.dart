import 'package:realm/realm.dart';

part 'timed_event.g.dart';

@RealmModel()
class _TimedEvent {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId eventID;

  late String? name;
  late String? stage;
  late String? date;
  late String? start;
  late String? end;
  late String? description;
  late String? image;
}
