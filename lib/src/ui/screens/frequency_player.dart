import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sound_well_app/src/ui/widgets/custom_text.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';
import 'package:sound_well_app/src/ui/screens/add_frequency_plan.dart';

// ignore: must_be_immutable
class FrequencyPlayer extends StatefulWidget {
  final List<FrequencyPlan> files;
  bool replayAudio;

  // ignore: use_super_parameters
  FrequencyPlayer({
    Key? key,
    required this.files,
    this.replayAudio = false,
  }) : super(key: key);

  @override
  State<FrequencyPlayer> createState() => _FrequencyPlayerState();
}

class _FrequencyPlayerState extends State<FrequencyPlayer> {
  late AudioPlayer audioPlayer;
  late Timer timer;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  int _currentIndex = 0;
  StreamSubscription? _positionSubscription;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    durationAudio();
    _startAudioPositionSubscription();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    disposePlayers();
    super.dispose();
  }

  Future<void> disposePlayers() async {
    await audioPlayer.dispose();
    timer.cancel();
  }

  Future<void> playAudio() async {
    await audioPlayer.setSource(AssetSource(widget.files[_currentIndex].audio));
    await audioPlayer.play(AssetSource(widget.files[_currentIndex].audio));
    startTimer();
    setState(
      () {
        _position = Duration.zero;
      },
    );
  }

  void startTimer() {
    timer =
        Timer(Duration(minutes: widget.files[_currentIndex].selectedTiming!),
            () async {
      await audioPlayer.stop();
      if (_currentIndex < widget.files.length - 1) {
        setState(
          () {
            _currentIndex++;
          },
        );
        playAudio();
      } else {
        setState(
          () {
            _currentIndex = 0;
          },
        );
      }
    });
  }

  Future<void> durationAudio() async {
    await audioPlayer.setSource(AssetSource(widget.files[_currentIndex].audio));
    audioPlayer.onDurationChanged.listen((Duration dd) {
      setState(
        () {
          _duration = dd;
        },
      );
    });
  }

  void _startAudioPositionSubscription() {
    _positionSubscription = audioPlayer.onPositionChanged.listen((event) {
      if (_currentIndex < widget.files.length - 1 &&
          event >=
              Duration(minutes: widget.files[_currentIndex].selectedTiming!)) {
        setState(
          () {
            _currentIndex++;
          },
        );
        playAudio();
      }
      if (_currentIndex < widget.files.length &&
          event >=
              Duration(minutes: widget.files[_currentIndex].selectedTiming!)) {
        setState(
          () {
            audioPlayer.stop();
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalTime =
        widget.files.fold(0, (acc, file) => acc + (file.selectedTiming ?? 0));

    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 30.sp),
            Expanded(
              child: ListView.builder(
                itemCount: widget.files.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10, top: 10),
                        width: 28.w,
                        height: 13.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(widget.files[index].image),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.files[index].name} - ${widget.files[index].selectedTiming} min",
                              style: TextStyle(
                                color: index == _currentIndex
                                    ? Colors.blue
                                    : Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Text(
              'Total Time: ${totalTime.toString()} minutes',
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            StreamBuilder(
              stream: audioPlayer.onDurationChanged,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration>(
                  stream: audioPlayer.onPositionChanged,
                  builder: (context, snapshot) {
                    var position = snapshot.data ?? Duration.zero;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Slider(
                          //   activeColor: Colors.blue,
                          //   value: position.inSeconds.toDouble(),
                          //   onChanged: (double value) {
                          //     audioPlayer
                          //         .seek(Duration(seconds: value.toInt()));
                          //     if (value >=
                          //         widget.files[_currentIndex].selectedTiming! *
                          //             60) {
                          //       if (_currentIndex < widget.files.length - 1) {
                          //         setState(() {
                          //           _currentIndex++;
                          //         });
                          //         playAudio();
                          //       }
                          //     }
                          //   },
                          //   min: 0.0,
                          //   max: duration.inSeconds.toDouble(),
                          // ),
                          Slider(
                            activeColor: Colors.blue,
                            value: position.inSeconds.toDouble(),
                            onChanged: (double value) {
                              audioPlayer
                                  .seek(Duration(seconds: value.toInt()));
                            },
                            onChangeEnd: (double value) {
                              if (value >=
                                  widget.files[_currentIndex].selectedTiming! *
                                      60) {
                                if (_currentIndex < widget.files.length - 1) {
                                  setState(() {
                                    _currentIndex++;
                                  });
                                  playAudio();
                                }
                              }
                            },
                            min: 0.0,
                            max: duration.inSeconds.toDouble(),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                // ignore: unnecessary_string_interpolations
                                text: "${position.toString().split('.').first}",
                                textColor: Colors.grey,
                              ),
                              CustomText(
                                // ignore: unnecessary_string_interpolations
                                text: "${duration.toString().split('.').first}",
                                textColor: Colors.grey,
                              )
                            ],
                          ),
                          SizedBox(height: 20.sp),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (audioPlayer.state ==
                                      PlayerState.playing) {
                                    audioPlayer.pause();
                                  } else {
                                    if (_position < _duration) {
                                      audioPlayer.resume();
                                    } else {
                                      if (_currentIndex <
                                          widget.files.length - 1) {
                                        playAudio();
                                      }
                                    }
                                  }
                                },
                                icon: Icon(
                                  audioPlayer.state == PlayerState.playing
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 100,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 20.sp),
          ],
        ),
      ),
    );
  }
}
