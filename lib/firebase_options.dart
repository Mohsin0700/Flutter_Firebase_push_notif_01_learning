// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get android => const FirebaseOptions(
    apiKey: 'AIzaSyAY0DYhU66Yh-LP_xlCuFSqvDRDDeCD7gk',
    appId: '1:532683508259:android:79df14724b2f097daeff96',
    messagingSenderId: '532683508259',
    projectId: 'mi-counter-app',
    storageBucket: 'i-counter-app.firebasestorage.app',
  );

  // If you added iOS support, add an `ios` getter here similarly.
}
