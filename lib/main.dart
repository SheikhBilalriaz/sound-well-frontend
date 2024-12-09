import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* Manages app responsiveness across different screen sizes */
import 'package:responsive_sizer/responsive_sizer.dart';

/* GetX package for navigation and state management */
import 'package:get/get.dart';
import 'package:sound_well_app/src/ui/screens/dashboard.dart';
import 'package:sound_well_app/src/ui/screens/login.dart';
import 'package:sound_well_app/src/ui/screens/splash_screen.dart';

/* Defines the current app version */
String version = '1.0';

/* Entry point of the Flutter application */
void main() async {
  /* Ensures Flutter bindings are initialized before running async code */
  WidgetsFlutterBinding.ensureInitialized();

  /* Retrieve stored email from SharedPreferences to check login status */
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');

  /* Launch the app */
  runApp(MyApp(email: email));
}

/* Root widget of the application */
class MyApp extends StatefulWidget {
  /* User email retrieved from SharedPreferences */
  final String? email;
  MyApp({required this.email});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    /* Decide the next screen based on login status */
    _navigateToNextScreen(widget.email);
  }

  /* Determines which screen to navigate to after the splash screen */
  void _navigateToNextScreen(String? email) async {
    /*  Simulate splash screen delay */
    await Future.delayed(const Duration(seconds: 3));
    if (email != null) {
      /* Navigate to dashboard if logged in */
      //TODO: Verify this device is logged in through API
      await Get.offAllNamed('/dashboard');
    } else {
      /* Navigate to login screen otherwise */
      await Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          /* Hides the debug banner */
          debugShowCheckedModeBanner: false,
          /* App title */
          title: 'The Sound Well',
          theme: ThemeData(
            /* Primary app theme */
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          /* Starting route of the app */
          initialRoute: '/splash',
          getPages: [
            /* Splash screen route */
            GetPage(
              name: '/splash',
              page: () => const SplashScreen(),
            ),
            /* Dashboard route */
            GetPage(
              name: '/dashboard',
              page: () => const DashboardScreen(),
            ),
            /* Login screen route */
            GetPage(
              name: '/login',
              page: () => const LogIn(),
            ),
          ],
        );
      },
    );
  }
}
