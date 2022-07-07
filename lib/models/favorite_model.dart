import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoriteModel extends ChangeNotifier {
  final List<DocumentSnapshot> _events = [];

  UnmodifiableListView<DocumentSnapshot> get events =>
      UnmodifiableListView(_events);

  void add(DocumentSnapshot event) {
    _events.add(event);
    checkFavorite(event);
    notifyListeners();
  }

  void remove(DocumentSnapshot event) {
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

  bool? checkFavorite(DocumentSnapshot event) {
    if (events.contains(event)) {
      return true;
    } else {
      return false;
    }
  }
}
