import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sound_well_app/src/ui/widgets/custom_text.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';

class SmallButton extends StatelessWidget {
  final String text;
  final VoidCallback voidCallback;
  const SmallButton({
    super.key,
    required this.text,
    required this.voidCallback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: voidCallback,
      child: Container(
        /* Use responsive width (50% of the screen width) */
        width: 50.w,
        decoration: BoxDecoration(
          color: AppColors.primaryBlueDark,
          borderRadius: BorderRadius.circular(17),
        ),
        alignment: Alignment.center,
        child: Padding(
          /* Use responsive vertical padding */
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: CustomText(
            text: text,
            fontWeight: FontWeight.bold,
            textColor: AppColors.primaryWhite,
            /* Responsive font size */
            fontsize: 2.h,
          ),
        ),
      ),
    );
  }
}
