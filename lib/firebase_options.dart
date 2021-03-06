// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAxVs_fJDWmGzz1Ep84xbpd_zJuDgaFxUY',
    appId: '1:230888413088:web:4c6fd00eb6c9e20aa3b6c5',
    messagingSenderId: '230888413088',
    projectId: 'festival-2e218',
    authDomain: 'festival-2e218.firebaseapp.com',
    databaseURL: 'https://festival-2e218-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'festival-2e218.appspot.com',
    measurementId: 'G-B10C8LZMDK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOLWOrcIGXFIVQJ1LB2wIPy5hZhzlt1Ck',
    appId: '1:230888413088:android:5cd607a276d591cfa3b6c5',
    messagingSenderId: '230888413088',
    projectId: 'festival-2e218',
    databaseURL: 'https://festival-2e218-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'festival-2e218.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC1og1ScJ8vz518kWsJ278rOZL6ReUJqoQ',
    appId: '1:230888413088:ios:fcde8f1f18a06e2ba3b6c5',
    messagingSenderId: '230888413088',
    projectId: 'festival-2e218',
    databaseURL: 'https://festival-2e218-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'festival-2e218.appspot.com',
    iosClientId: '230888413088-lfhuaa309v9mtspevp4lufeftgr84m54.apps.googleusercontent.com',
    iosBundleId: 'hu.bitclub.allinfest',
  );
}
