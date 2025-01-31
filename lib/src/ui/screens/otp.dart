import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:sound_well_app/src/ui/screens/signup.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';
import 'package:sound_well_app/src/utils/app_assets.dart';

class OtpPage extends StatefulWidget {
  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(8, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(8, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onNextPressed() async {
    String otp = _controllers.map((controller) => controller.text).join();
    if (otp.length == 8) {
      var logger = Logger();
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 5.0,
          ),
        ),
        barrierDismissible: false,
      );
      try {
        const String verifyUrl =
            "https://thesoundwell-vibro-therapy.longevityproducts.info/backend/api/verification";
        final response = await http.post(
          Uri.parse(verifyUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "otp": otp,
          }),
        );
        Get.back();
        if (response.statusCode == 200) {
          Get.to(() => SignUp(otp: otp));
        } else {
          final error = jsonDecode(response.body);
          Get.snackbar(
            "Error",
            "OTP Failed: ${error['error_message']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } catch (e) {
        logger.e(e);
        Get.back();
        Get.snackbar(
          "Error",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } else {
      Get.back();
      Get.snackbar(
        "Error",
        "Please fill all 8 characters.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /* Navigate to the previous page */
  void _onBackPressed() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    /* Screen width and height for responsive design */
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.themeColor,
      appBar: AppBar(
        title: const Text('Enter OTP'),
        backgroundColor: AppColors.primaryBlueDark,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              /* Ensures vertical centering */
              height: screenHeight,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    /* 5% of screen width for horizontal padding */
                    horizontal: screenWidth * 0.05,
                    /* 2% of screen height for vertical padding */
                    vertical: screenHeight * 0.15,
                  ),
                  child: Column(
                    children: [
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
                      const Text(
                        "Enter the 8-character OTP",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      /* Adjusted spacing dynamically */
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(8, (index) {
                          return Flexible(
                            child: SizedBox(
                              /* Adjust size based on screen width */
                              width: screenWidth * 0.1,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                maxLength: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  counterText: '',
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.blueGrey,
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 7) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                      /* Adjusted spacing dynamically */
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _onBackPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Back"),
                          ),
                          ElevatedButton(
                            onPressed: _onNextPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Next"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
