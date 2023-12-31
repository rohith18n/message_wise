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
    apiKey: 'AIzaSyAWQbQqBUCgjz_1HSjzTxWxxOxXpzJs0NI',
    appId: '1:380431189866:web:8268e9f6f4f7c3b7e60713',
    messagingSenderId: '380431189866',
    projectId: 'messagewise-1700d',
    authDomain: 'messagewise-1700d.firebaseapp.com',
    storageBucket: 'messagewise-1700d.appspot.com',
    measurementId: 'G-9QKVXDSZEC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrJkW7KI-N7vbL6kD-RTyWwlNEsjkuNiU',
    appId: '1:380431189866:android:5c6d2de6566c7064e60713',
    messagingSenderId: '380431189866',
    projectId: 'messagewise-1700d',
    storageBucket: 'messagewise-1700d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCiPtTJwHTuboVsLm-F3ZUiPWmQ3i5b5SI',
    appId: '1:380431189866:ios:9e84318531df714ae60713',
    messagingSenderId: '380431189866',
    projectId: 'messagewise-1700d',
    storageBucket: 'messagewise-1700d.appspot.com',
    iosBundleId: 'com.example.messageWise',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCiPtTJwHTuboVsLm-F3ZUiPWmQ3i5b5SI',
    appId: '1:380431189866:ios:b46d6a79cfc6ac9be60713',
    messagingSenderId: '380431189866',
    projectId: 'messagewise-1700d',
    storageBucket: 'messagewise-1700d.appspot.com',
    iosBundleId: 'com.example.messageWise.RunnerTests',
  );
}
