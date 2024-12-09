import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_well_app/src/ui/screens/otp.dart';
import 'package:sound_well_app/src/utils/app_assets.dart';
import 'package:sound_well_app/src/controller/login_controller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final LogInController _controller = Get.put(LogInController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;

  /* Fetch device ID for Android/iOS */
  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = "unknown_device";
    var logger = Logger();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? "unknown_device";
      }
    } catch (e) {
      logger.e(e);
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }

    return deviceId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 26, 45),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          /* Screen dimensions for responsiveness */
          final double screenWidth = constraints.maxWidth;
          final double screenHeight = constraints.maxHeight;

          return Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              /* Responsive horizontal padding */
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /* Top spacing */
                  SizedBox(height: screenHeight * 0.05),

                  /* Logo section */
                  Container(
                    /* 40% of screen width */
                    width: screenWidth * 0.4,
                    /* Square aspect ratio */
                    height: screenWidth * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppAssets.soundIcon),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /* Login title */
                  Text(
                    'Log In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      /* Responsive font size */
                      fontSize: screenHeight * 0.03,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  /* Email input field */
                  Padding(
                    padding: EdgeInsets.symmetric(
                      /* Vertical padding */
                      vertical: screenHeight * 0.01,
                    ),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Enter your email',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          /* Responsive label size */
                          fontSize: screenHeight * 0.02,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  /* Password input field */
                  Padding(
                    padding: EdgeInsets.symmetric(
                      /* Vertical padding */
                      vertical: screenHeight * 0.01,
                    ),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Enter your password',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          /* Responsive label size */
                          fontSize: screenHeight * 0.02,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "Register Yourself!",
                          style: const TextStyle(
                            /* Link color */
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            /* Underline the link */
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              /* Navigate to the OTP page */
                              Get.to(() => OtpPage());
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  /* Login button */
                  SizedBox(
                    /* 80% of screen width */
                    width: screenWidth * 0.8,
                    /* Responsive button height */
                    height: screenHeight * 0.07,
                    child: ElevatedButton(
                      onPressed: () async {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();
                        final deviceId = await getDeviceId();

                        if (email.isEmpty || password.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please enter email and password",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 3),
                          );
                          return;
                        }
                        _controller.login(email, password, deviceId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          /* Responsive font size */
                          fontSize: screenHeight * 0.025,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  /* Bottom spacing */
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
