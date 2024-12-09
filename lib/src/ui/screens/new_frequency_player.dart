import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sound_well_app/src/ui/widgets/custom_text.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';
import 'package:sound_well_app/src/ui/screens/add_frequency_plan.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';
import 'package:sound_well_app/src/ui/widgets/common.dart';
import 'package:sound_well_app/src/ui/widgets/new_sound_screen.dart';
import 'package:sound_well_app/src/utils/app_assets.dart';

// ignore: must_be_immutable
class NewFrequencyPlayer extends StatefulWidget {
  final List<FrequencyPlan> files;
  bool replayAudio;

  NewFrequencyPlayer({
    super.key,
    required this.files,
    this.replayAudio = false,
  });

  @override
  State<NewFrequencyPlayer> createState() => _NewFrequencyPlayerState();
}

class _NewFrequencyPlayerState extends State<NewFrequencyPlayer> {
  late AudioPlayer audioPlayer;
  Timer? timer;
  // ignore: unused_field
  Duration _duration = const Duration();
  Duration _position = const Duration();
  int _currentIndex = 0;
  StreamSubscription? _positionSubscription;
  /* To track the play/pause state */
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    audioPlayer = AudioPlayer();
    List<AudioSource> audioSource = [];

    widget.files.forEach((element) {
      audioSource.add(
        ClippingAudioSource(
          start: Duration.zero,
          end: Duration(minutes: element.selectedTiming ?? 15),
          child: AudioSource.asset('${element.audio}'),
        ),
      );
    });

    /* Concatenate the sources into one audio source. */
    final playlist = ConcatenatingAudioSource(
      children: audioSource,
      useLazyPreparation: true,
    );

    try {
      /* Set the concatenated audio source to the player */
      await audioPlayer.setAudioSource(
        playlist,
        initialIndex: 0,
        initialPosition: Duration.zero,
      );
    } on PlayerException catch (e) {
      /* Handle any errors during loading or playback */
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error in loading file"),
        ),
      );
    }

    /* Subscribe to the playing state of the player to update the UI */
    audioPlayer.playingStream.listen((playing) {
      /* Update isPlaying based on the stream */
      setState(() {
        isPlaying = playing;
      });
    });

    /* Set up repeat behavior if needed */
    audioPlayer.playbackEventStream.listen((event) {
      /* Rewind to the start and replay */
      if (event.processingState == ProcessingState.completed && widget.replayAudio) {
        audioPlayer.seek(Duration.zero);
      }
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    disposePlayers();
    super.dispose();
  }

  Future<void> disposePlayers() async {
    await audioPlayer.dispose();
    timer?.cancel();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  /* Navigate to the next track */
  Future<void> _nextTrack() async {
    if (_currentIndex < widget.files.length - 1) {
      await audioPlayer.seek(Duration.zero, index: _currentIndex + 1);
    }
  }

  /* Navigate to the previous track */
  Future<void> _previousTrack() async {
    if (_currentIndex > 0) {
      await audioPlayer.seek(Duration.zero, index: _currentIndex - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalTime =
        widget.files.fold(0, (acc, file) => acc + (file.selectedTiming ?? 0));

    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Padding(
        padding: EdgeInsets.all(14.sp),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: IconButton(
                    onPressed: () {
                      timer?.cancel();
                      audioPlayer.stop();
                      Get.back();
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
                        text: totalTime.toString(),
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.sp),
            Expanded(
              child: StreamBuilder<int?>( 
                  stream: audioPlayer.currentIndexStream,
                  builder: (context, snapshot) {
                    final _curr = snapshot.data ?? 0;
                    return ListView.builder(
                      itemCount: widget.files.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              width: 28.w,
                              height: 13.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(widget.files[index].image),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.files[index].name} - ${widget.files[index].selectedTiming} min",
                                    style: TextStyle(
                                      color: index == _curr
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
                    );
                  }),
            ),
            Text('Total Time: ${totalTime.toString()} minutes',
                style: TextStyle(fontSize: 20, color: Colors.grey)),
            StreamBuilder<Duration>( 
                stream: audioPlayer.positionStream,
                builder: (context, snapshot) {
                  var position = snapshot.data ?? Duration.zero;
                  return Column(
                    children: [
                      StreamBuilder<PositionData>(
                          stream: _positionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data;
                            return SeekBar(
                              duration: positionData?.duration ?? Duration.zero,
                              position: positionData?.position ?? Duration.zero,
                              bufferedPosition:
                                  positionData?.bufferedPosition ?? Duration.zero,
                              onChangeEnd: audioPlayer.seek,
                            );
                          }),
                      SizedBox(height: 30.sp),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _previousTrack,
                            icon: Icon(Icons.skip_previous),
                            color: Colors.white,
                          ),
                          SizedBox(width: 20.sp),
                          ControlButtons(audioPlayer),
                          SizedBox(width: 20.sp),
                          IconButton(
                            onPressed: _nextTrack,
                            icon: Icon(Icons.skip_next),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  );
                }),
            SizedBox(height: 20.sp),
          ],
        ),
      ),
    );
  }
}
