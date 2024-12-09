import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sound_well_app/src/ui/widgets/custom_button.dart';
import 'package:sound_well_app/src/ui/widgets/custom_text.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';
import 'package:sound_well_app/src/ui/screens/dashboard.dart';

class PaidSounds extends StatelessWidget {
  final String image;
  final String text;
  final String description;
  const PaidSounds({
    super.key,
    required this.image,
    required this.text,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Get.to(
          () => const DashboardScreen(),
        );
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: AppColors.themeColor,
            ),
            child: Stack(
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      width: double.infinity,
                      height: 80.sp,
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        onPressed: () {
                          Get.to(
                            () => const DashboardScreen(),
                          );
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 300,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.themeColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 20.0,
                        left: 20.0,
                        top: 40.0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: text,
                              fontsize: 22.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                            ),
                            SizedBox(
                              height: 25.sp,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 15.sp,
                            ),
                            const CustomButton(
                              text: "Unlock",
                              btncolor: AppColors.primaryOrange,
                              icon: Icons.lock,
                            ),
                            SizedBox(
                              height: 15.sp,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 15.sp,
                            ),
                            CustomText(
                              text: "About this sound",
                              fontWeight: FontWeight.bold,
                              fontsize: 18.sp,
                            ),
                            SizedBox(
                              height: 10.sp,
                            ),
                            CustomText(
                              text: description,
                              fontsize: 16.sp,
                            ),
                            SizedBox(
                              height: 14.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
