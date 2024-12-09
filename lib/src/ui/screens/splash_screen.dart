import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sound_well_app/src/utils/app_assets.dart';
import 'package:sound_well_app/main.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';

/* SplashScreen widget - Displays a splash screen with animations */
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /* Controls the fade-in animation */
  late AnimationController _controller;

  /* Defines the fade-in effect */
  late Animation<double> _fadeAnimation;

  /* Fetches the app version using PackageInfo and updates the state */
  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    /* Fetch app version on initialization */
    getAppVersion();

    /* Initialize animation controller for fade-in effect */
    _controller = AnimationController(
      vsync: this,
      /* Animation duration */
      duration: const Duration(seconds: 3),
    );

    /* Define fade animation curve */
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      /* Smooth in-out curve */
      curve: Curves.easeInOut,
    );

    /* Start the fade-in animation */
    _controller.forward();
  }

  @override
  void dispose() {
    /* Dispose animation controller */
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* Get screen dimensions */
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        /* Expand stack to fill the screen */
        fit: StackFit.expand,
        children: [
          /* Background gradient */
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlack,
                  AppColors.primaryGrey,
                  const Color.fromARGB(255, 3, 26, 45),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /* App logo with fade-in animation */
          Positioned(
            left: 0,
            right: 0,
            /* Position at 30% of screen height */
            top: screenHeight * 0.3,
            child: FadeTransition(
              /* Apply fade effect */
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* App logo */
                  Image.asset(
                    AppAssets.soundIcon,
                    /* Scale image width */
                    width: screenWidth * 0.4,
                    /* Maintain square aspect ratio */
                    height: screenWidth * 0.4,
                  ),
                  /* Spacing below logo */
                  SizedBox(height: screenHeight * 0.02),
                  /* App title */
                  Text(
                    'The Sound Well',
                    style: TextStyle(
                      color: Colors.white,
                      /* Font size based on height */
                      fontSize: screenHeight * 0.035,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3,
                          /* Text shadow */
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /* Version info and loader with fade-in animation */
          Positioned(
            left: 0,
            right: 0,
            /* Position above bottom by 10% */
            bottom: screenHeight * 0.1,
            child: FadeTransition(
              /* Apply fade effect */
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  /* Display app version */
                  Text(
                    'Version: $version',
                    style: TextStyle(
                      color: Colors.white,
                      /* Relative font size */
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.w300,
                      shadows: const [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          /* Text shadow */
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  /* Spacing below version */
                  SizedBox(height: screenHeight * 0.015),

                  /* Circular progress indicator */
                  SizedBox(
                    height: screenHeight * 0.05,
                    /* Circular size */
                    width: screenHeight * 0.05,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
