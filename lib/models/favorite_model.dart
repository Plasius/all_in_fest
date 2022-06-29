import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoriteModel extends ChangeNotifier {
  final List<DocumentSnapshot> _events = [];
  bool? isFavoriteEvent;

  UnmodifiableListView<DocumentSnapshot> get events =>
      UnmodifiableListView(_events);

  void add(DocumentSnapshot event) {
    _events.add(event);
    notifyListeners();
  }

  void remove(DocumentSnapshot event) {
    _events.remove(event);
    notifyListeners();
  }

  void clear() {
    _events.clear();
    notifyListeners();
  }

  void changeFavorite(DocumentSnapshot event) {
    _events.contains(event) ? isFavoriteEvent = true : isFavoriteEvent = false;
  }
}
