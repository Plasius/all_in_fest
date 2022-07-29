import 'package:realm/realm.dart';

part 'message.g.dart';

@RealmModel()
class _Message {
  @PrimaryKey()
  @MapTo("_id")
  late String messageID;

  late String? from;
  late String? message;
  late int? datetime;
  late String? matchID;
}
