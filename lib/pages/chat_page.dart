// ignore_for_file: library_prefixes, implementation_imports, prefer_typing_uninitialized_variables, avoid_print

import 'package:all_in_fest/models/message.dart';
import 'package:all_in_fest/models/open_realm.dart';
import 'package:realm/src/user.dart' as realmUser;
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:realm/realm.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/mongo_connect.dart';
import 'menu_sidebar.dart';
