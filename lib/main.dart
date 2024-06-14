import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nakcare_app/controller/local_notification.dart';
import 'package:nakcare_app/controller/provider.dart';
import 'package:nakcare_app/page/HomeNavBar.dart';
import 'package:nakcare_app/page/HomePage.dart';
import 'package:nakcare_app/page/VerifyKit.dart';
import 'package:nakcare_app/splash_screen.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Define the callback function

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.init();

  // Initialize the Android Alarm Manager

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      title: 'NakSafe',
      theme: ThemeData(
          primaryColor: Colors.white,
          fontFamily: 'Manrope',
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0xFF3186C6),
              selectionColor: Color(0xFF3186C6),
              selectionHandleColor: Color(0xFF3186C6))),
      home: SplashScreen(),
      routes: {
        '/home_page': (context) => const HomePage(),
        '/home_nav_bar': (context) => const NavBarPage(),
        '/verify_kit': (context) => VerifyKit(),
      },
    );
  }
}
