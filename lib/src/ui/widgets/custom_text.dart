import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? fontsize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxlines;
  const CustomText({
    super.key,
    required this.text,
    this.textColor,
    this.fontsize,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxlines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxlines,
      style: TextStyle(
        overflow: overflow,
        color: textColor ?? AppColors.primaryWhite,
        fontSize: fontsize ?? 17.sp,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}
