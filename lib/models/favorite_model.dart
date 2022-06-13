import 'dart:collection';

import 'package:all_in_fest/models/event_model.dart';
import 'package:flutter/material.dart';

class FavoriteModel extends ChangeNotifier {
  final List<Event> _events = [];

  UnmodifiableListView<Event> get events => UnmodifiableListView(_events);

  void add(Event event){
    _events.add(event);
    notifyListeners();
  }

  void remove(Event event){
    _events.remove(event);
    notifyListeners();
  }

  void clear(){
    _events.clear();
    notifyListeners();
  }
}