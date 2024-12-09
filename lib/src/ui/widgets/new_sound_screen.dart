import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sound_well_app/src/ui/screens/dashboard.dart';
import 'package:sound_well_app/src/ui/widgets/custom_text.dart';
import 'package:sound_well_app/src/utils/app_assets.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';
import 'package:sound_well_app/src/ui/widgets/common.dart';
import 'package:rxdart/rxdart.dart';

class NewSoundScreen extends StatefulWidget {
  final String image;
  final String selectedValue;
  final String text;
  final int duration;
  final String description;
  final String audioPath;

  const NewSoundScreen({
    Key? key,
    required this.image,
    required this.selectedValue,
    required this.text,
    required this.duration,
    required this.description,
    required this.audioPath,
  }) : super(key: key);

  @override
  State<NewSoundScreen> createState() => _NewSoundScreenState();
}

class _NewSoundScreenState extends State<NewSoundScreen> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _player = AudioPlayer();

    try {
      await _player.setAudioSource(
        AudioSource.asset("assets/${widget.audioPath}"),
      );
      await _player.setVolume(1.0);
      switch (widget.duration) {
        case 900000:
          await _player.setClip(
              start: Duration(seconds: 0), end: Duration(seconds: 900));
          break;
        case 1800000:
          await _player.setClip(
              start: Duration(seconds: 0), end: Duration(seconds: 1800));
          break;
        case -1:
          await _player.setLoopMode(LoopMode.all);
          break;
        default:
          break;
      }
      await _player.play();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Loading File Failed...",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(14.sp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: IconButton(
                        onPressed: () {
                          _player.stop();
                          Get.to(DashboardScreen());
                        },
                        icon: Icon(Icons.arrow_back_ios),
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 28.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primaryBlueDark),
                      ),
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
                  ],
                ),
                SizedBox(
                  height: 4.h,
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
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
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
                  height: 4.h,
                ),
                Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Column(
                    children: [
                      StreamBuilder<Duration>(
                        stream: _player.positionStream,
                        builder: (context, snapshot) {
                          var position = snapshot.data ?? Duration.zero;
                          return Column(
                            children: [
                              StreamBuilder<PositionData>(
                                stream: _positionDataStream,
                                builder: (context, snapshot) {
                                  final positionData = snapshot.data;
                                  return SeekBar(
                                    duration:
                                        positionData?.duration ?? Duration.zero,
                                    position:
                                        positionData?.position ?? Duration.zero,
                                    bufferedPosition:
                                        positionData?.bufferedPosition ??
                                            Duration.zero,
                                    onChangeEnd: _player.seek,
                                  );
                                },
                              ),
                              SizedBox(height: 3.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 5.sp),
                                  ControlButtons(_player),
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
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                color: Colors.white,
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                color: Colors.white,
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                color: Colors.white,
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
      ],
    );
  }
}
