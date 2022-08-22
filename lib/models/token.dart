import 'package:realm/realm.dart';

part 'token.g.dart';

@RealmModel()
class _Token {
  @PrimaryKey()
  @MapTo("_id")
  late String userID;
  late String? token;
}
