import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/on_generate_route.dart';
import 'core/themes/app_themes.dart';
import 'views/entrypoint/splash_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _notificationRoute = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    // Request permission for notifications
    _firebaseMessaging.requestPermission();

    // Get FCM Token
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token"); // Save this for testing
    });

    // Handle notification when the app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title}");
      // Handle foreground notification UI
    });

    // Handle notification when the app is opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _navigateToPage(message);
      }
    });

    // Handle notification when the app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToPage(message);
    });
  }

  void _navigateToPage(RemoteMessage message) {
    String? route = message.data['route']; // Get route from payload
    if (route != null) {
      setState(() {
        _notificationRoute = route;
      });
      // Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inniti ERP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.defaultTheme,
      onGenerateRoute: RouteGenerator.onGenerate,
      // home: SplashScreen(
      //   notificationRoute: _notificationRoute,
      // ),
       initialRoute: AppRoutes.onboarding,
    );
  }
}
