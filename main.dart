import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login.dart';
import 'screens/welcomepage.dart';
import 'screens/adminlogin.dart';
import 'screens/studentsignup.dart';
import 'screens/tutorsignup.dart';
import 'screens/tutorshedule.dart';
import 'screens/tutordashboard.dart';
import 'screens/messages.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  runApp(MyApp());
}

Future<void> _requestNotificationPermissions() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

Future<String?> _getToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("Firebase Messaging Token: $token");
  return token;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(),
      routes: {
        '/studentLogin': (context) => LoginPage(role: 'Student'),
        '/tutorLogin': (context) => LoginPage(role: 'Tutor'),
        '/studentSignup': (context) => StudentSignUpPage(),
        '/tutorSignup': (context) => TutorSignUpPage(),
        '/adminLogin': (context) => AdminLoginPage(),
        '/schedulePage': (context) => SchedulePage(),
        '/messages': (context) => MessagesPage()
      },
    );
  }
}
