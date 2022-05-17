import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class Event {
  String name;
  String artists;
  String imgUrl;
  String place;
  DateTime date;
  String bio;

  Event(
      {required this.name,
      required this.artists,
      required this.imgUrl,
      required this.place,
      required this.date,
      required this.bio});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        name: json['name'],
        artists: json['artists'],
        imgUrl: json['imgUrl'],
        place: json['place'],
        date: json['date'],
        bio: json['bio']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'artists': artists,
        'imgUrl': imgUrl,
        'place': place,
        'date': date,
        'bio': bio
      };
}
