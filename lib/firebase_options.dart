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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyA-Vd47Cy2ddzDkPpHE8IfwgL8oGbF1M04',
    appId: '1:787419964167:web:9dbba743326fdce3759ba2',
    messagingSenderId: '787419964167',
    projectId: 'sidequest-c3199',
    authDomain: 'sidequest-c3199.firebaseapp.com',
    storageBucket: 'sidequest-c3199.appspot.com',
    measurementId: 'G-6XWV9W3VR5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAPIvkSXh0YNxFBbTHVvAAIoouNhZ_SFDU',
    appId: '1:787419964167:android:7dcae52f2e372466759ba2',
    messagingSenderId: '787419964167',
    projectId: 'sidequest-c3199',
    storageBucket: 'sidequest-c3199.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDfnpkQ5GEyxYo8G8SACrq5y2IWyKGjl6o',
    appId: '1:787419964167:ios:dfcc493df62505ab759ba2',
    messagingSenderId: '787419964167',
    projectId: 'sidequest-c3199',
    storageBucket: 'sidequest-c3199.appspot.com',
    iosBundleId: 'com.example.sidequest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDfnpkQ5GEyxYo8G8SACrq5y2IWyKGjl6o',
    appId: '1:787419964167:ios:dfcc493df62505ab759ba2',
    messagingSenderId: '787419964167',
    projectId: 'sidequest-c3199',
    storageBucket: 'sidequest-c3199.appspot.com',
    iosBundleId: 'com.example.sidequest',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA-Vd47Cy2ddzDkPpHE8IfwgL8oGbF1M04',
    appId: '1:787419964167:web:98ed49df65dd6e42759ba2',
    messagingSenderId: '787419964167',
    projectId: 'sidequest-c3199',
    authDomain: 'sidequest-c3199.firebaseapp.com',
    storageBucket: 'sidequest-c3199.appspot.com',
    measurementId: 'G-NH1YKBXWBZ',
  );
}
