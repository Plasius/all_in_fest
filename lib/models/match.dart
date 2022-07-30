import 'package:realm/realm.dart';

part 'match.g.dart';

@RealmModel()
class _Match {
  @PrimaryKey()
  @MapTo("_id")
  late String matchID;

  late String? user1;
  late String? user2;
}
