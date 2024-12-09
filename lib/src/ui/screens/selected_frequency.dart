import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sound_well_app/src/ui/widgets/custom_text.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';
import 'package:sound_well_app/src/ui/screens/dashboard.dart';
import 'package:sound_well_app/src/ui/screens/add_frequency_plan.dart';
import 'package:sound_well_app/src/ui/screens/new_frequency_player.dart';

class SelectedFrequencies extends StatefulWidget {
  final List<FrequencyPlan> selectedFrequencies;
  SelectedFrequencies({required this.selectedFrequencies});

  @override
  State<SelectedFrequencies> createState() => _SelectedFrequenciesState();
}

class _SelectedFrequenciesState extends State<SelectedFrequencies> {
  @override
  void dispose() {
    selectedFrequencies.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(
          () => const DashboardScreen(),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.themeColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: Colors.white,
            ),
            onPressed: () {
              Get.offAll(
                () => const DashboardScreen(),
              );
            },
          ),
          backgroundColor: AppColors.themeColor,
          centerTitle: true,
          title: CustomText(
            text: "${selectedFrequencies.length} Frequency Plan",
            fontWeight: FontWeight.bold,
            /* Increased font size for readability */
            fontsize: 22.sp,
            textColor: Colors.white,
          ),
        ),
        body: Padding(
          /* Adding horizontal padding for better spacing */
          padding: EdgeInsets.symmetric(
            horizontal: 5.w,
          ),
          child: Column(
            children: [
              /* Responsive height */
              SizedBox(height: 2.h),
              Expanded(
                child: widget.selectedFrequencies.isNotEmpty
                    ? ListView.builder(
                        itemCount: widget.selectedFrequencies.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            /* Padding for each item */
                            padding: EdgeInsets.symmetric(
                              vertical: 2.h,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 5.w),
                                  /* Reduced width for better responsiveness */
                                  width: 28.w,
                                  height: 15.h,
                                  decoration: BoxDecoration(
                                    /* Rounded corners */
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      widget.selectedFrequencies[index].image,
                                      /* Ensuring the image is responsive */
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${widget.selectedFrequencies[index].name} - ${widget.selectedFrequencies[index].selectedTiming} min',
                                        style: TextStyle(
                                          color: Colors.white,
                                          /* Responsive font size */
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: CustomText(
                          text: "No frequency added yet",
                          fontWeight: FontWeight.bold,
                          fontsize: 18.sp,
                          textColor: Colors.grey,
                        ),
                      ),
              ),
              /* Added some vertical spacing */
              SizedBox(height: 3.h),
              Container(
                margin: EdgeInsets.only(bottom: 3.h),
                child: MaterialButton(
                  /* Adjusted width to be more responsive */
                  minWidth: 70.w,
                  /* Increased height for better touch response */
                  height: 7.h,
                  color: AppColors.primaryBlueDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onPressed: () {
                    if (widget.selectedFrequencies.isEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddFrequencyPlan();
                          },
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return NewFrequencyPlayer(
                              files: widget.selectedFrequencies,
                            );
                          },
                        ),
                      );
                    }
                  },
                  child: CustomText(
                    text: widget.selectedFrequencies.isEmpty
                        ? "Add Frequency"
                        : "Play",
                    fontWeight: FontWeight.bold,
                    fontsize: 18.sp,
                    textColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
