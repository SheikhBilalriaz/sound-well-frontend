import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sound_well_app/src/ui/widgets/small_button.dart';
import 'package:sound_well_app/src/ui/widgets/custom_text.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';
import 'package:sound_well_app/src/ui/widgets/new_sound_screen.dart';

class ProgressDialog extends StatefulWidget {
  final String image;
  final String text;
  final String description;
  final String audioPath;

  const ProgressDialog({
    Key? key,
    required this.image,
    required this.text,
    required this.description,
    required this.audioPath,
  }) : super(key: key);

  @override
  State<ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {
  int selectedOption = 1;
  String selectedValue = "15 minutes";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.themeColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          /* Using responsive padding */
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* Responsive height for spacing */
              SizedBox(
                height: 2.h,
              ),
              CustomText(
                text: "Select Loop Interval",
                fontWeight: FontWeight.bold,
                /* Responsive font size */
                fontsize: 2.5.h,
              ),
              /* Responsive height for spacing */
              SizedBox(
                height: 2.h,
              ),
              ListTile(
                title: InkWell(
                  onTap: () {
                    setState(
                      () {
                        selectedOption = 1;
                        selectedValue = "15 min";
                      },
                    );
                  },
                  child: CustomText(
                    text: "15 minutes",
                    fontWeight: FontWeight.bold,
                    /* Responsive font size */
                    fontsize: 2.2.h,
                  ),
                ),
                leading: Radio(
                  activeColor: AppColors.primaryBlueDark,
                  value: 1,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(
                      () {
                        selectedOption = value!;
                      },
                    );
                  },
                ),
              ),
              ListTile(
                title: InkWell(
                  onTap: () {
                    setState(
                      () {
                        selectedOption = 2;
                        selectedValue = "30 min";
                      },
                    );
                  },
                  child: CustomText(
                    text: "30 minutes",
                    fontWeight: FontWeight.bold,
                    /* Responsive font size */
                    fontsize: 2.2.h,
                  ),
                ),
                leading: Radio(
                  activeColor: AppColors.primaryBlueDark,
                  value: 2,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(
                      () {
                        selectedOption = value!;
                      },
                    );
                  },
                ),
              ),
              ListTile(
                title: InkWell(
                  onTap: () {
                    setState(
                      () {
                        selectedOption = 3;
                        selectedValue = "Loop";
                      },
                    );
                  },
                  child: CustomText(
                    text: "Loop",
                    fontWeight: FontWeight.bold,
                    /* Responsive font size */
                    fontsize: 2.2.h,
                  ),
                ),
                leading: Radio(
                  activeColor: AppColors.primaryBlueDark,
                  value: 3,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(
                      () {
                        selectedOption = value!;
                      },
                    );
                  },
                ),
              ),
              /* Responsive height for spacing */
              SizedBox(
                height: 3.h,
              ),
              SmallButton(
                text: "Continue",
                voidCallback: () {
                  Get.to(
                    () => NewSoundScreen(
                      image: widget.image,
                      selectedValue: selectedOption == 1
                          ? "15 min"
                          : selectedOption == 2
                              ? "30 min"
                              : "Loop",
                      text: widget.text,
                      description: widget.description,
                      duration: selectedOption == 1
                          ? 15 * 60 * 1000
                          : selectedOption == 2
                              ? 30 * 60 * 1000
                              : -1,
                      audioPath: widget.audioPath,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
