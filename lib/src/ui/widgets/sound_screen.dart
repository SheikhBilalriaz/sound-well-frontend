import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sound_well_app/src/ui/widgets/custom_text.dart';
import 'package:sound_well_app/src/utils/app_assets.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';
import 'package:sound_well_app/src/utils/free_sounds.dart';

class SoundScreen extends StatefulWidget {
  final String image;
  final String selectedValue;
  final String text;
  final int duration;
  final String description;
  final String audioPath;

  const SoundScreen(
      {Key? key,
      required this.image,
      required this.selectedValue,
      required this.text,
      required this.duration,
      required this.description,
      required this.audioPath})
      : super(key: key);

  @override
  State<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  bool isPlaying = false;
  final audioPlayer = AudioPlayer();
  late Timer timer;
  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    super.initState();
    durationAudio();
  }

  @override
  void dispose() {
    disposePlayers();
    super.dispose();
  }

  Future<void> disposePlayers() async {
    await audioPlayer.dispose();
    timer.cancel();
  }

  Future<void> playAudio() async {
    await audioPlayer.play(AssetSource(widget.audioPath));
    startTimer();
    setState(() {
      isPlaying = true;
    });
  }

  void startTimer() {
    timer = Timer(Duration(milliseconds: widget.duration), () {
      audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    });
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer.pause();
      timer.cancel();
      setState(() {
        isPlaying = false;
      });
    } else {
      if (_position < _duration) {
        /* Check if audio is paused */
        if (_position.inMilliseconds != 0) {
          /* Resume playing from the current position */
          audioPlayer.resume();
        } else {
          /* Start playing from the current position */
          audioPlayer.seek(_position);
          audioPlayer.resume();
        }
      } else {
        /* If audio reaches the end, start playing from the beginning */
        audioPlayer.seek(Duration.zero);
        setState(() {
          _position = Duration.zero;
        });
        playAudio();
      }
      /* Start the timer */
      startTimer();
      setState(() {
        isPlaying = true;
      });
    }
  }

  Future<void> durationAudio() async {
    await audioPlayer.setSource(AssetSource(widget.audioPath));
    audioPlayer.onDurationChanged.listen((Duration dd) {
      setState(() {
        _duration = dd;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration dd) {
      setState(() {
        _position = dd;
      });
      /* Check if the current position matches the selected duration */
      if (_position >= Duration(milliseconds: widget.duration)) {
        /* Pause audio */
        audioPlayer.pause();
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        await audioPlayer.stop();
        Get.to(() => FreeSounds(
              image: widget.image,
              text: widget.text,
              description: widget.description,
              audioPath: widget.audioPath,
            ));
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.themeColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(14.sp),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 28.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primaryBlueDark)),
                    child: Row(
                      children: [
                        Image.asset(
                          AppAssets.circularArrowIcon,
                          width: 10.w,
                        ),
                        CustomText(
                          text: widget.selectedValue,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.sp,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 38.w,
                      height: 20.h,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            widget.image,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 25.sp,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      textAlign: TextAlign.center,
                      text: widget.text,
                      fontsize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 35.sp,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        StreamBuilder<Duration>(
                          stream: audioPlayer.onPositionChanged,
                          builder: (context, snapshot) {
                            var position = snapshot.data ?? Duration.zero;
                            return Column(
                              children: [
                                Slider(
                                  activeColor: Colors.blue,
                                  value: isPlaying
                                      ? position.inMilliseconds.toDouble()
                                      : _position.inMilliseconds.toDouble(),
                                  /* Seek to the new position */
                                  onChanged: (double value) {
                                    setState(() {
                                      _position =
                                          Duration(milliseconds: value.toInt());
                                      audioPlayer.seek(_position);
                                    });
                                  },
                                  min: 0.0,
                                  max: _duration.inMilliseconds.toDouble(),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text:
                                          "${_position.toString().split('.').first}",
                                      textColor: Colors.grey,
                                    ),
                                    CustomText(
                                      text:
                                          "${_duration.toString().split('.').first}",
                                      textColor: Colors.grey,
                                    )
                                  ],
                                ),
                                SizedBox(height: 30.sp),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        audioPlayer.seek(Duration(
                                            milliseconds:
                                                _position.inMilliseconds -
                                                    10000));
                                      },
                                      child: Image.asset(AppAssets.backIcon),
                                    ),
                                    SizedBox(width: 20.sp),
                                    InkWell(
                                      onTap: playPause,
                                      child: Icon(
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 100,
                                      ),
                                    ),
                                    SizedBox(width: 20.sp),
                                    InkWell(
                                      onTap: () {
                                        audioPlayer.seek(Duration(
                                            milliseconds:
                                                _position.inMilliseconds +
                                                    10000));
                                      },
                                      child: Image.asset(AppAssets.forwardIcon),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
