import 'package:realm/realm.dart';

part 'user.g.dart';

@RealmModel()
class _User{
  @PrimaryKey()
  late final String userID;

  late String? name;
  late String? bio;
  late int? since;
}