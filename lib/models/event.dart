import 'package:realm/realm.dart';

part 'event.g.dart';

@RealmModel()
class _Event {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId eventID;

  late String? name;
  late String? stage;
  late String? date;
  late String? time;
  late String? description;
  late String? image;
}
