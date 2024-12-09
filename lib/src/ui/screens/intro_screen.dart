import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sound_well_app/src/utils/app_assets.dart';
import 'package:sound_well_app/src/ui/screens/dashboard.dart';
import 'package:sound_well_app/src/ui/screens/pdf_view.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 26, 45),
      body: ListView(physics: BouncingScrollPhysics(), children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.intro),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => PDFScreen());
              },
              child: Text('Get Started',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Get.offAll(() => DashboardScreen());
          },
          child: Text('Skip',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ),
      ]),
    );
  }
}
