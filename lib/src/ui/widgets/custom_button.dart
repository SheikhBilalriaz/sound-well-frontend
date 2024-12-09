import 'package:flutter/material.dart';
import 'package:sound_well_app/src/ui/widgets/custom_text.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final Color btncolor;
  final String text;
  final IconData icon;
  const CustomButton({
    super.key,
    required this.text,
    required this.btncolor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: btncolor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primaryWhite,
            ),
            CustomText(
              text: text,
              fontWeight: FontWeight.bold,
              textColor: AppColors.primaryWhite,
            )
          ],
        ),
      ),
    );
  }
}
