import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sound_well_app/src/ui/screens/login.dart';
import 'package:logger/logger.dart';

class SignupController extends GetxController {
  createAccount(String first_name, String last_name, String email,
      String password, String otp) async {
    var logger = Logger();
    Get.dialog(
      // ignore: prefer_const_constructors
      Center(
        // ignore: prefer_const_constructors
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 5.0,
        ),
      ),
      barrierDismissible: false,
    );

    try {
      const String loginUrl =
          "https://thesoundwell-vibro-therapy.longevityproducts.info/backend/api/user-register";
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "first_name": first_name,
          "last_name": last_name,
          "email": email,
          "password": password,
          "otp": int.parse(otp),
        }),
      );

      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar(
          "Success",
          "User Successfully Registered!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        Get.to(const LogIn());
      } else {
        Get.back();
        final error = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          "Signup Failed: ${error['error_message']}",
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
  }
}
