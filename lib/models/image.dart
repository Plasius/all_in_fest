import 'package:realm/realm.dart';

part 'image.g.dart';

@RealmModel()
class _UserImage {
  @PrimaryKey()
  @MapTo("_id")
  late String imageID;

  late String data;
  late String user;
}
