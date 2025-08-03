// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

// 1️⃣ Define a top-level background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background,
  // initialize Firebase before using them:
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  print('🔔 Background message received: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2️⃣ Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  // 3️⃣ Set the background message handler early
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseMessaging _messaging;
  String? _token;

  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
  }

  void _initFirebaseMessaging() async {
    _messaging = FirebaseMessaging.instance;

    // 4️⃣ Request permissions (iOS only; on Android this does nothing)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('🔔 User granted permission: ${settings.authorizationStatus}');

    // 5️⃣ Get the FCM token for this device
    _token = await _messaging.getToken();
    print('🔔 FCM Token: $_token');

    // 6️⃣ Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Foreground message received: ${message.notification?.title}');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.notification?.body ?? 'You have a new notification',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Push Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Counter with Notifications')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Press the button to increment:'),
              const SizedBox(height: 8),
              CounterWidget(),
              const SizedBox(height: 16),
              Text(
                'FCM Token:\n${_token ?? "Fetching..."}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$_count', style: const TextStyle(fontSize: 48)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => setState(() => _count++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
