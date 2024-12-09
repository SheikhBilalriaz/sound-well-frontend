import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sound_well_app/src/ui/widgets/custom_text.dart';

class CustomDashboardContainer extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback voidcallback;
  const CustomDashboardContainer({
    super.key,
    required this.image,
    required this.text,
    required this.voidcallback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            InkWell(
              onTap: voidcallback,
              child: SizedBox(
                width: 38.w,
                height: 20.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 102,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.black38, shape: BoxShape.circle),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.sp,
        ),
        SizedBox(
          width: 38.w,
          child: CustomText(
            textAlign: TextAlign.center,
            text: text,
            fontWeight: FontWeight.bold,
            maxlines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
