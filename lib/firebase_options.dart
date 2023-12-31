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
    apiKey: 'AIzaSyCz7ALvyyXYhkZIyyiKum5WBR3ENGmwdXE',
    appId: '1:56709198289:web:879205ca7fb0e7304c70f0',
    messagingSenderId: '56709198289',
    projectId: 'camposestudios-b4a65',
    authDomain: 'camposestudios-b4a65.firebaseapp.com',
    databaseURL: 'https://camposestudios-b4a65-default-rtdb.firebaseio.com',
    storageBucket: 'camposestudios-b4a65.appspot.com',
    measurementId: 'G-5TFYEK3VXK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXifpa7CuiOwg98k4ZKm6UvnxGh6Twy90',
    appId: '1:56709198289:android:0fe7656326ae77b64c70f0',
    messagingSenderId: '56709198289',
    projectId: 'camposestudios-b4a65',
    storageBucket: 'camposestudios-b4a65.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjz9g_cjXR7uDj6C0ot7bg6gAnKT_2Oog',
    appId: '1:56709198289:ios:b2b9ada1ef63999d4c70f0',
    messagingSenderId: '56709198289',
    projectId: 'camposestudios-b4a65',
    storageBucket: 'camposestudios-b4a65.appspot.com',
    iosBundleId: 'com.edbc.camposestudio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBjz9g_cjXR7uDj6C0ot7bg6gAnKT_2Oog',
    appId: '1:56709198289:ios:b2b9ada1ef63999d4c70f0',
    messagingSenderId: '56709198289',
    projectId: 'camposestudios-b4a65',
    storageBucket: 'camposestudios-b4a65.appspot.com',
    iosBundleId: 'com.edbc.camposestudio',
  );
}
