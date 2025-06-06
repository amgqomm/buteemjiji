// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC2QHLGuC7CW38tvE9x6MDrEfbdLqrWBPk',
    appId: '1:286511755703:web:d337fcfe842cbf1f3bb832',
    messagingSenderId: '286511755703',
    projectId: 'buteemjiji-10863',
    authDomain: 'buteemjiji-10863.firebaseapp.com',
    storageBucket: 'buteemjiji-10863.firebasestorage.app',
    measurementId: 'G-J4GH6950FK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKRQqO8anWYADXiYFgBzH5DNEuLO6PWCg',
    appId: '1:286511755703:android:15b6b38ce585078b3bb832',
    messagingSenderId: '286511755703',
    projectId: 'buteemjiji-10863',
    storageBucket: 'buteemjiji-10863.firebasestorage.app',
  );

}