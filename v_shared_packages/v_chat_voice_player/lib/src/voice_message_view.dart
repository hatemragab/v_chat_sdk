// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_voice_player/src/voice_message_controller.dart';

import 'helpers/utils.dart';
import 'widgets/noises.dart';

class VVoiceMessageView extends StatelessWidget {
  final VVoiceMessageController controller;
  final Color activeSliderColor;
  final Color? notActiveSliderColor;
  final Color? backgroundColor;
  final TextStyle counterTextStyle;
  final Widget? playIcon;
  final Widget? pauseIcon;
  final Widget? errorIcon;
  final Function(String speed)? speedBuilder;

  const VVoiceMessageView({
    Key? key,
    required this.controller,
    this.activeSliderColor = Colors.red,
    this.notActiveSliderColor,
    this.backgroundColor,
    this.playIcon,
    this.pauseIcon,
    this.errorIcon,
    this.speedBuilder,
    this.counterTextStyle = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newTHeme = theme.copyWith(
      sliderTheme: SliderThemeData(
        trackShape: CustomTrackShape(),
        thumbShape: SliderComponentShape.noThumb,
        minThumbSeparation: 0,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: backgroundColor,
      ),
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 5,
              ),
              if (controller.isDownloading)
                const SizedBox(
                  height: 38,
                  width: 38,
                  child: CupertinoActivityIndicator(),
                )
              else if (controller.isPlaying)
                InkWell(
                  onTap: controller.pausePlaying,
                  child: pauseIcon ?? _pauseIcon,
                )
              else if (controller.isDownloadError)
                InkWell(
                  onTap: controller.initAndPlay,
                  child: errorIcon ?? _errorIcon,
                )
              else
                InkWell(
                  onTap: controller.initAndPlay,
                  child: playIcon ?? _playIcon,
                ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      width: controller.noiseWidth,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Noises(
                            rList: controller.randoms,
                            activeSliderColor: activeSliderColor,
                          ),
                          AnimatedBuilder(
                            animation: CurvedAnimation(
                              parent: controller.animController,
                              curve: Curves.ease,
                            ),
                            builder: (BuildContext context, Widget? child) {
                              return Positioned(
                                left: controller.animController.value,
                                child: Container(
                                  width: controller.noiseWidth,
                                  height: 6.w(),
                                  color: notActiveSliderColor ??
                                      activeSliderColor.withOpacity(.4),
                                ),
                              );
                            },
                          ),
                          Opacity(
                            opacity: .0,
                            child: SizedBox(
                              width: controller.noiseWidth,
                              //color: Colors.amber.withOpacity(1),
                              child: Theme(
                                data: newTHeme,
                                child: Slider(
                                  value: controller.currentMillSeconds,
                                  max: controller.maxMillSeconds,
                                  onChangeStart: controller.onChangeSliderStart,
                                  onChanged: controller.onChanging,
                                  onChangeEnd: (value) {
                                    controller.onSeek(
                                      Duration(milliseconds: value.toInt()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      controller.remindingTime,
                      style: counterTextStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Transform.translate(
                offset: const Offset(0, -7),
                child: InkWell(
                  onTap: controller.changeSpeed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      controller.playSpeedStr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          );
        },
      ),
    );
  }

  // Function _speedBuilder = (String speed) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: 3,
  //       vertical: 2,
  //     ),
  //     decoration: BoxDecoration(
  //       color: Colors.red,
  //       borderRadius: BorderRadius.circular(4),
  //     ),
  //     child: Text(
  //       speed,
  //       style: const TextStyle(
  //         color: Colors.white,
  //         fontSize: 10,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // };

  Widget get _pauseIcon => Container(
        height: 38,
        width: 38,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.pause_rounded,
          color: Colors.white,
        ),
      );

  Widget get _playIcon => Container(
        height: 38,
        width: 38,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
        ),
      );

  Widget get _errorIcon => Container(
        height: 38,
        width: 38,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      );
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
