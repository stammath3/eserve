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
        return macos;
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
    apiKey: 'AIzaSyBjYsNhW-yoZMwF8H8eCvi41jTdQQ91yvI',
    appId: '1:324066568811:web:9b29a8456f1763ff935f2e',
    messagingSenderId: '324066568811',
    projectId: 'eserve-hmu',
    authDomain: 'eserve-hmu.firebaseapp.com',
    storageBucket: 'eserve-hmu.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBFqDfbD1-XMV_RzS-mlAS6o1BoLWL510s',
    appId: '1:324066568811:android:4d74cad0f44d4c21935f2e',
    messagingSenderId: '324066568811',
    projectId: 'eserve-hmu',
    storageBucket: 'eserve-hmu.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMU4nFdu-1CazuFeyq4XMS3U9GkG1yVfI',
    appId: '1:324066568811:ios:51c22daa17f83862935f2e',
    messagingSenderId: '324066568811',
    projectId: 'eserve-hmu',
    storageBucket: 'eserve-hmu.appspot.com',
    iosClientId: '324066568811-pvg8uj0qft6vhlp6smio06fjtlirk6c0.apps.googleusercontent.com',
    iosBundleId: 'com.example.eServe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMU4nFdu-1CazuFeyq4XMS3U9GkG1yVfI',
    appId: '1:324066568811:ios:51c22daa17f83862935f2e',
    messagingSenderId: '324066568811',
    projectId: 'eserve-hmu',
    storageBucket: 'eserve-hmu.appspot.com',
    iosClientId: '324066568811-pvg8uj0qft6vhlp6smio06fjtlirk6c0.apps.googleusercontent.com',
    iosBundleId: 'com.example.eServe',
  );
}
