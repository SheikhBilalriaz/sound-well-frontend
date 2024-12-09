import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_well_app/src/ui/screens/login.dart';
import 'package:logger/logger.dart';

class DashboardController extends GetxController {
  Future<void> logout(String email, String deviceId) async {
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

    const String loginUrl =
        "https://thesoundwell-vibro-therapy.longevityproducts.info/backend/api/user-logout";

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "device_id": deviceId,
        }),
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('email');
        Get.offAll(() => LogIn());
      } else {
        Get.back();
        final error = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          "Logout Failed: ${error['error_message']}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
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
        duration: Duration(seconds: 3),
      );
    }
  }
}
