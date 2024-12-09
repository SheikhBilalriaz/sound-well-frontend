import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sound_well_app/src/ui/widgets/custom_button.dart';
import 'package:sound_well_app/src/ui/widgets/custom_text.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';
import 'package:sound_well_app/src/ui/widgets/dialog.dart';
import 'package:sound_well_app/src/ui/screens/dashboard.dart';

class FreeSounds extends StatelessWidget {
  final String image;
  final String text;
  final String description;
  final String audioPath;
  
  const FreeSounds({
    Key? key,
    required this.image,
    required this.text,
    required this.description,
    required this.audioPath,
  }) : super(key: key);

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
                /* Background Image and Back Button */
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      width: double.infinity,
                      /* 50% of the screen height */
                      height: 50.h,
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      /* 4% of screen width */
                      padding: EdgeInsets.all(4.w),
                      child: IconButton(
                        onPressed: () {
                          Get.to(
                            () => const DashboardScreen(),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                /* Main Content */
                Positioned(
                  /* 50% from the top */
                  top: 50.h,
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
                      padding: EdgeInsets.only(
                        /* 5% of screen width */
                        right: 5.w,
                        /* 5% of screen width */
                        left: 5.w,
                        /* 5% of screen height */
                        top: 5.h,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: text,
                              /* Dynamic font size based on screen width */
                              fontsize: 5.w,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                            ),
                            /* 2% of screen height */
                            SizedBox(
                              height: 2.h,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            /* 2% of screen height */
                            SizedBox(
                              height: 2.h,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext c) {
                                    return ProgressDialog(
                                      image: image,
                                      text: text,
                                      description: description,
                                      audioPath: audioPath,
                                    );
                                  },
                                );
                              },
                              child: const CustomButton(
                                text: "Play",
                                btncolor: AppColors.primaryBlueDark,
                                icon: Icons.play_arrow,
                              ),
                            ),
                            /* 2% of screen height */
                            SizedBox(
                              height: 2.h,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            /* 2% of screen height */
                            SizedBox(
                              height: 2.h,
                            ),
                            CustomText(
                              text: "About this sound",
                              fontWeight: FontWeight.bold,
                              /* Font size based on screen width */
                              fontsize: 4.w,
                            ),
                            /* 1% of screen height */
                            SizedBox(
                              height: 1.h,
                            ),
                            CustomText(
                              text: description,
                              /* Font size based on screen width */
                              fontsize:
                                  3.5.w,
                            ),
                            /* 2% of screen height */
                            SizedBox(
                              height: 2.h,
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
