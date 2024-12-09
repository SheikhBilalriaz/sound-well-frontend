import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sound_well_app/src/ui/widgets/custom_text.dart';
import 'package:sound_well_app/src/utils/app_assets.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';
import 'package:sound_well_app/src/ui/screens/selected_frequency.dart';

List<FrequencyPlan> selectedFrequencies = [];

class FrequencyPlan {
  String name;
  Color color;
  String image;
  String audio;
  int? selectedTiming;

  FrequencyPlan({
    required this.name,
    required this.color,
    required this.image,
    required this.audio,
    this.selectedTiming,
  });

  @override
  String toString() {
    return 'FrequencyPlan{name: $name, color: $color, image: $image, audio: $audio, selectedTiming: $selectedTiming}';
  }
}

class AddFrequencyPlan extends StatefulWidget {
  // ignore: use_super_parameters
  const AddFrequencyPlan({Key? key}) : super(key: key);

  @override
  State<AddFrequencyPlan> createState() => _AddFrequencyPlanState();
}

class _AddFrequencyPlanState extends State<AddFrequencyPlan> {
  List<Map<String, dynamic>> frequencyData = [
    {
      "name": "Calibrate",
      "color": Colors.red,
      "image": AppAssets.red,
      "audio": "assets/audios/Calibrate.mp3"
    },
    {
      "name": "Delight",
      "color": Colors.orange,
      "image": AppAssets.orange,
      "audio": "assets/audios/Delight.mp3"
    },
    {
      "name": "Empathy",
      "color": Colors.yellow,
      "image": AppAssets.yellow,
      "audio": "assets/audios/Empathy.mp3"
    },
    {
      "name": "Feel",
      "color": const Color.fromARGB(255, 37, 94, 39),
      "image": AppAssets.green,
      "audio": "assets/audios/Feel.mp3"
    },
    {
      "name": "Gratitude",
      "color": Colors.blue,
      "image": AppAssets.blue,
      "audio": "assets/audios/Gratitude.mp3"
    },
    {
      "name": "Attunement",
      "color": Colors.purple,
      "image": AppAssets.indigo,
      "audio": "assets/audios/Attunement.mp3"
    },
    {
      "name": "Balance",
      "color": Colors.white,
      "image": AppAssets.violate,
      "audio": "assets/audios/Balance.mp3"
    },
  ];

  List<bool> selected = List.generate(7, (index) => false);
  Map<String, int?> selectedTimings = {};
  int selectedCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.themeColor,
        centerTitle: true,
        title: CustomText(
          text: "Add frequency plan",
          fontWeight: FontWeight.bold,
          fontsize: 20.sp,
          textColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
              child: ListView.builder(
                itemCount: frequencyData.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildHeaderRow();
                  } else {
                    return _buildDataRow(
                      frequencyData[index - 1]["name"],
                      frequencyData[index - 1]["color"],
                      index - 1,
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 20.sp),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: MaterialButton(
              minWidth: 50.w,
              height: 6.h,
              color: AppColors.primaryBlueDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: () {
                if (!_isSelectionValid()) {
                  return;
                }
                _saveSelectedFrequencies();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SelectedFrequencies(
                        selectedFrequencies: selectedFrequencies,
                      );
                    },
                  ),
                );
              },
              child: CustomText(
                text: "Continue",
                fontWeight: FontWeight.bold,
                fontsize: 18.sp,
                textColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSelectionValid() {
    bool isAudioSelected = false;
    bool isTimingSelected = true;

    for (int i = 0; i < selected.length; i++) {
      if (selected[i]) {
        isAudioSelected = true;
        if (selectedTimings[frequencyData[i]["name"]] == null) {
          isTimingSelected = false;
          break;
        }
      }
    }

    if (!isAudioSelected) {
      Get.snackbar(
        "Alert!!!",
        "Please select an audio file",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return false;
    } else if (!isTimingSelected) {
      Get.snackbar(
        "Alert!!!",
        "Please select timing for all selected audio files",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      return false;
    } else if (selectedCount > 3) {
      Get.snackbar(
        "Alert!!!",
        "You can only select 3 items",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      return false;
    }

    return true;
  }

  void _saveSelectedFrequencies() {
    selectedFrequencies.clear();
    for (int i = 0; i < selected.length; i++) {
      if (selected[i]) {
        setState(() {
          selectedFrequencies.add(
            FrequencyPlan(
              name: frequencyData[i]["name"],
              color: frequencyData[i]["color"],
              image: frequencyData[i]["image"],
              audio: frequencyData[i]["audio"],
              selectedTiming: selectedTimings[frequencyData[i]["name"]],
            ),
          );
        });
      }
    }
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Frequency',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 30.sp,
        ),
        Text(
          '15 min',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
        Text(
          '30 min',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(String text, Color textColor, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
                color: textColor,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Checkbox(
              side: const BorderSide(width: 1.0, color: Colors.blue),
              value: selected[index],
              fillColor: selected[index]
                  // ignore: deprecated_member_use
                  ? MaterialStateProperty.all(Colors.blue)
                  // ignore: deprecated_member_use
                  : MaterialStateProperty.all(Colors.transparent),
              onChanged: (newValue) {
                setState(() {
                  if (newValue == true && selectedCount >= 3) {
                    Get.snackbar(
                      "Alert!!!",
                      "You can only select 3 items",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      duration: Duration(seconds: 3),
                    );
                    return;
                  }
                  selected[index] = newValue!;
                  if (newValue) {
                    selectedTimings[text] = null;
                    selectedCount++;
                  } else {
                    selectedTimings.remove(text);
                    selectedCount--;
                  }
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Radio(
              value: 15,
              groupValue: selectedTimings[text],
              onChanged: (value) {
                setState(() {
                  // ignore: unnecessary_cast
                  selectedTimings[text] = value as int?;
                });
              },
              activeColor: Colors.white,
            ),
          ),
          Expanded(
            flex: 1,
            child: Radio(
              value: 30,
              groupValue: selectedTimings[text],
              onChanged: (value) {
                setState(
                  () {
                    // ignore: unnecessary_cast
                    selectedTimings[text] = value as int?;
                  },
                );
              },
              activeColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
