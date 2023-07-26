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
    apiKey: 'AIzaSyBzyGYtpNvTkSStT47EgpggiV79BicF5eU',
    appId: '1:276083202125:web:211b52adc60bf3ce1fe404',
    messagingSenderId: '276083202125',
    projectId: 'flutter-message-task',
    authDomain: 'flutter-message-task.firebaseapp.com',
    storageBucket: 'flutter-message-task.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAONDyEE2aGJAodIwx7ZV5BNhXeNJl5ck',
    appId: '1:276083202125:android:a133ff44049c5fcc1fe404',
    messagingSenderId: '276083202125',
    projectId: 'flutter-message-task',
    storageBucket: 'flutter-message-task.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbfOk81r2ST6LOf6dokKgk_bfSOtlpqJQ',
    appId: '1:276083202125:ios:72abba53ea2a03a01fe404',
    messagingSenderId: '276083202125',
    projectId: 'flutter-message-task',
    storageBucket: 'flutter-message-task.appspot.com',
    iosClientId: '276083202125-553bncba45t589jmmnfneosoohsd1fen.apps.googleusercontent.com',
    iosBundleId: 'com.flutter.fcm.fcmflutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbfOk81r2ST6LOf6dokKgk_bfSOtlpqJQ',
    appId: '1:276083202125:ios:13b92c15f6b0c8e81fe404',
    messagingSenderId: '276083202125',
    projectId: 'flutter-message-task',
    storageBucket: 'flutter-message-task.appspot.com',
    iosClientId: '276083202125-gmkc9g10fmsft0blajh8hvss55sc4aal.apps.googleusercontent.com',
    iosBundleId: 'com.flutter.fcm.fcmflutter.RunnerTests',
  );
}