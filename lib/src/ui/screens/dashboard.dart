import 'dart:io';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:sound_well_app/src/controller/dashboard_controller.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';
import 'package:sound_well_app/src/utils/app_assets.dart';
import 'package:sound_well_app/src/ui/widgets/custom_text.dart';
import 'package:sound_well_app/src/ui/widgets/dashboard_container.dart';
import 'package:sound_well_app/src/utils/free_sounds.dart';
import 'package:sound_well_app/src/ui/screens/selected_frequency.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController dashboard = Get.put(DashboardController());

  /* Fetch device ID for Android/iOS */
  Future<String> getDeviceId() async {
    var logger = Logger();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = "unknown_device";

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? "unknown_device";
      }
    } catch (e) {
      logger.e(e);
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }

    return deviceId;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.themeColor,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final email = prefs.getString('email');
                final deviceId = await getDeviceId();
                await dashboard.logout(email.toString(), deviceId);
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
          backgroundColor: AppColors.themeColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: false,
          title: CustomText(
            text: "TheSoundWell",
            fontWeight: FontWeight.bold,
            fontsize: 20.sp,
            textColor: Colors.white,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 14.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomDashboardContainer(
                      image: AppAssets.red,
                      text: "Calibrate",
                      voidcallback: () {
                        Get.to(
                          () => FreeSounds(
                            audioPath: "audios/Calibrate.mp3",
                            image: AppAssets.red,
                            text: "Calibrate",
                            description:
                                "The red chakra, also known as the root chakra or Muladhara chakra, is the first and most foundational chakra. It is located at the base of the spine and is associated with the color red and the element earth. The root chakra is responsible for our sense of security, stability, and grounding. It is also associated with our basic needs for survival, such as food, water, and shelter. When the root chakra is balanced, we feel safe and secure in the world. We feel confident in our ability to take care of ourselves and to meet our basic needs. We also feel connected to the earth and to our physical bodies. When the root chakra is imbalanced, we may feel anxious, insecure, or unstable. We may have difficulty meeting our basic needs, or we may feel disconnected from our physical bodies. Here are some of the things that the red chakra is in charge of: Survival instincts, Sense of security and safety, Grounding and connection to the earth, Physical health and vitality, Basic needs, such as food, water, and shelter, Financial stability, Willpower and determination, Courage and confidence, Self-esteem and self-worth",
                          ),
                        );
                      },
                    ),
                    CustomDashboardContainer(
                      image: AppAssets.orange,
                      text: "Delight",
                      voidcallback: () {
                        Get.to(
                          () => FreeSounds(
                            audioPath: "audios/Delight.mp3",
                            image: AppAssets.orange,
                            text: "Delight",
                            description:
                                "The orange chakra is the sacral chakra, or svadhisthana chakra. It is the second primary chakra in the body, and is located below the navel, in the lower abdomen and pelvis. It is associated with the color orange, the element of water, and the sense of taste. The sacral chakra is the center of creativity, pleasure, sexuality, and emotions. It is also responsible for our sense of self-worth and our ability to connect with others. When the sacral chakra is balanced, we feel confident, joyful, and connected to our bodies and our desires. We are also able to express ourselves creatively and authentically. However, when the sacral chakra is blocked, we may experience feelings of shame, guilt, insecurity, and fear. We may also have difficulty expressing our emotions or connecting with others. Additionally, we may experience physical problems such as sexual dysfunction, fertility issues, and lower back pain.",
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomDashboardContainer(
                      image: AppAssets.yellow,
                      text: "Empathy",
                      voidcallback: () {
                        Get.to(
                          () => FreeSounds(
                            audioPath: "audios/Empathy.mp3",
                            image: AppAssets.yellow,
                            text: "Empathy",
                            description:
                                " The yellow chakra is the solar plexus chakra, or manipura chakra. It is the third primary chakra in the body, and is located above the navel, in the upper abdomen. It is associated with the color yellow, the element of fire, and the sense of sight. The solar plexus chakra is the center of personal power, self-esteem, and confidence. It is also responsible for our ability to set and achieve goals, and to take action in our lives. When the solar plexus chakra is balanced, we feel empowered, motivated, and in control of our lives. We are also able to assert ourselves in a healthy way and to stand up for what we believe in. However, when the solar plexus chakra is blocked, we may experience feelings of insecurity, self-doubt, and fear. We may also have difficulty setting and achieving goals, or we may feel overwhelmed and powerless. Additionally, we may experience physical problems such as digestive problems, adrenal fatigue, and chronic fatigue syndrome.",
                          ),
                        );
                      },
                    ),
                    CustomDashboardContainer(
                      image: AppAssets.green,
                      text: "Feel",
                      voidcallback: () {
                        Get.to(
                          () => FreeSounds(
                            audioPath: "audios/Feel.mp3",
                            image: AppAssets.green,
                            text: "Feel",
                            description:
                                "The green chakra is the heart chakra, or anahata chakra. It is the fourth primary chakra in the body, and is located in the center of the chest, near the heart. It is associated with the color green, the element of air and the sense of touch. The heart chakra is the center of love, compassion, empathy, and forgiveness. It is also responsible for our ability to connect with others on a deep and meaningful level. When the heart chakra is balanced, we feel loved, accepted, and connected to the world around us. We are also able to give and receive love freely and unconditionally. However, when the heart chakra is blocked, we may experience feelings of loneliness, isolation, and bitterness. We may also have difficulty forming and maintaining healthy relationships. Additionally, we may experience physical problems such as heart disease, high blood pressure, and respiratory problems.",
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomDashboardContainer(
                      image: AppAssets.blue,
                      text: "Gratitude",
                      voidcallback: () {
                        Get.to(
                          () => FreeSounds(
                            audioPath: "audios/Gratitude.mp3",
                            image: AppAssets.blue,
                            text: "Gratitude",
                            description:
                                "The blue chakra is the throat chakra, or vishuddha chakra. It is the fifth primary chakra in the body, and is located in the throat area. It is associated with the color blue, the element of sound, and the sense of hearing. The throat chakra is the center of communication, self-expression, and creativity. It is also responsible for our ability to speak our truth, to listen to others, and to express ourselves authentically. When the throat chakra is balanced, we are able to communicate clearly and effectively. We are also able to express our thoughts, feelings, and needs freely and honestly. However, when the throat chakra is blocked, we may experience difficulty communicating our thoughts and feelings. We may also feel shy, insecure, or afraid to speak up. Additionally, we may have difficulty listening to others or understanding their perspectives. Additionally, we may experience physical problems such as sore throats, laryngitis, and thyroid problems.",
                          ),
                        );
                      },
                    ),
                    CustomDashboardContainer(
                      image: AppAssets.indigo,
                      text: "Attunement",
                      voidcallback: () {
                        Get.to(
                          () => FreeSounds(
                            audioPath: "audios/Calibrate.mp3",
                            image: AppAssets.indigo,
                            text: "Attunement",
                            description:
                                "The 6th chakra, also known as the third eye chakra or ajna chakra, is located between the eyebrows. It is associated with the color indigo.The third eye chakra is the center of intuition, imagination, and psychic abilities. It is also responsible for our ability to see the world beyond the physical, and to connect with our higher selves. When the third eye chakra is balanced, we have a strong intuition and we are able to see the world clearly, without judgment. We are also able to tap into our creativity and to imagine new possibilities. However, when the third eye chakra is blocked, we may experience difficulty trusting our intuition or seeing things clearly. We may also have difficulty being creative or imagining new possibilities. Additionally, we may experience headaches, migraines, and vision problems.",
                          ),
                        );
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomDashboardContainer(
                      image: AppAssets.violate,
                      text: "Balance",
                      voidcallback: () {
                        Get.to(
                          () => FreeSounds(
                            audioPath: "audios/Delight.mp3",
                            image: AppAssets.violate,
                            text: "Balance",
                            description:
                                "The violet chakra, also known as the crown chakra or sahasrara chakra, is the seventh and highest chakra in the body. It is located at the top of the head, and is associated with the color violet, the element of spirit, and the sense of cosmic consciousness. The crown chakra is the center of spirituality, enlightenment, and connection to the divine. It is responsiblefor our ability to see the world through a higher perspective and to understand our place in the universe.When the crown chakra is balanced, we feel a sense of deep peace, inner knowing, and unity with all things. However, when the crown chakra is blocked, we may experience feelings of detachment, isolation, and lack of purpose. We may also have difficulty connecting with our spiritual side or understanding our place in the world. Additionally, we may experience physical problems such as headaches, migraines, and insomnia.",
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: CustomDashboardContainer(
                        image: AppAssets.threefreplan,
                        text: "Three frequencies plan",
                        voidcallback: () {
                          Get.to(
                            () => SelectedFrequencies(
                              selectedFrequencies: [],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 14.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
