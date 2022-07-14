import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase{
  static var db, users, events, matches, messages;
  static var bucket;
  static connect() async{
    db = Db.pool([
      "mongodb://bitclub:Festival22@cluster0-shard-00-00.3v4ig.mongodb.net:27017/allinfest?ssl=true&authSource=admin&retryWrites=true&w=majority",
      "mongodb://bitclub:Festival22@cluster0-shard-00-01.3v4ig.mongodb.net:27017/allinfest?ssl=true&authSource=admin&retryWrites=true&w=majority",
      "mongodb://bitclub:Festival22@cluster0-shard-00-02.3v4ig.mongodb.net:27017/allinfest?ssl=true&authSource=admin&retryWrites=true&w=majority"
    ]);
    await db.open();

    users=db.collection('users');
    events=db.collection('events');
    matches=db.collection('matches');
    messages=db.collection('messages');

    bucket = GridFS(db, "images");
  }
}