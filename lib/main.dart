import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_list/ui/home_page.dart';
import 'package:to_do_list/ui/sign_up_page.dart';
import 'package:to_do_list/ui/theme.dart';
import 'package:to_do_list/controllers/auth_controller.dart';
import 'firebase_options.dart'; // Ensure you have Firebase options properly configured

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthController()); // Initialize AuthController with GetX
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await _requestNotificationPermissions();

  runApp(const MyApp());
}

Future<void> _requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted notification permissions!');
  } else {
    print('User declined or has not granted notification permissions.');
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      home: const Initializer(), // Use Initializer to check authentication state
    );
  }
}

class Initializer extends StatelessWidget {
  const Initializer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthController.to.checkAuth(), // Check authentication status
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              width: 50,
              height: 50,
              color: Colors.transparent, // Make sure the background is transparent
              child: CircularProgressIndicator(
                strokeWidth: 2, // Adjust the thickness of the indicator
              ),
            ),
          ); // Placeholder while checking auth
        } else {
          if (snapshot.hasData && snapshot.data!) {
            return const HomePage(); // Navigate to HomePage if authenticated
          } else {
            return const SignUp(); // Navigate to SignUp if not authenticated
          }
        }
      },
    );
  }
}
