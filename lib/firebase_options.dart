// ════════════════════════════════════════════════════════════════════════════
// firebase_options.dart
//
// Generated/customised for the Easy Work Web Firebase project.
// DO NOT commit real API keys to public repositories.
// ════════════════════════════════════════════════════════════════════════════
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return web; // only web target for now
      case TargetPlatform.iOS:
        return web;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD8YY2R8ie8RcNpKODIujHYweQ_uCNOweA',
    authDomain: 'easy-work-web-e916b.firebaseapp.com',
    projectId: 'easy-work-web-e916b',
    storageBucket: 'easy-work-web-e916b.appspot.com',
    messagingSenderId: '716950112047',
    appId: '1:716950112047:web:218fe8a371c76e293f43da',
  );
}
