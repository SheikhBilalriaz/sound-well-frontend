import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class LogInController extends GetxController {
  Future<void> login(String email, String password, String deviceId) async {
    var logger = Logger();
    const String loginUrl =
        "https://thesoundwell-vibro-therapy.longevityproducts.info/backend/api/user-login";

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "device_id": deviceId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("email", data['token']);

        Get.snackbar(
          "Success",
          "Login Successful!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        Get.offAllNamed('/dashboard');
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          "Login Failed: ${error['error_message']}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      logger.e(e);
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
