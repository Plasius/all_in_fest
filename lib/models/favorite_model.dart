import 'dart:collection';

import 'package:flutter/material.dart';

class FavoriteModel extends ChangeNotifier {
  final List<dynamic> _events = [];

  UnmodifiableListView<dynamic> get events => UnmodifiableListView(_events);

  void add(dynamic event) {
    _events.add(event);
    checkFavorite(event);
    notifyListeners();
  }

  void remove(dynamic event) {
    _events.remove(event);
    checkFavorite(event);
    notifyListeners();
  }

  void clear() {
    _events.clear();
    notifyListeners();
  }

  void filterEvents(String datetime, String stage) {
    _events
        .where((element) => element['datetime'].toString().contains(datetime))
        .where((element) => element['stage'].toString().contains(stage));
  }

  bool? checkFavorite(dynamic event) {
    if (events.contains(event)) {
      return true;
    } else {
      return false;
    }
  }
}
