// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:helpers/helpers.dart'
//     show OpacityTransition, SwipeTransition, AnimatedInteractiveViewer;
// import 'package:video_editor/video_editor.dart';
//
// class VideoEditor extends StatefulWidget {
//   const VideoEditor({required this.file});
//
//   final File file;
//
//   @override
//   State<VideoEditor> createState() => _VideoEditorState();
// }
//
// class _VideoEditorState extends State<VideoEditor> {
//   final _exportingProgress = ValueNotifier<double>(0.0);
//   final _isExporting = ValueNotifier<bool>(false);
//   final double height = 60;
//   late VideoEditorController _controller;
//
//   @override
//   void initState() {
//     _controller = VideoEditorController.file(
//       widget.file,
//       maxDuration: const Duration(seconds: 1200),
//       trimStyle: TrimSliderStyle(),
//     )..initialize().then((_) => setState(() {}));
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_controller.initialized) {
//       return const Scaffold(
//         backgroundColor: Colors.black,
//         body: SafeArea(child: Center(child: CircularProgressIndicator())),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _topNavBar(),
//             Expanded(
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         CropGridViewer(
//                           controller: _controller,
//                           showGrid: false,
//                         ),
//                         AnimatedBuilder(
//                           animation: _controller.video,
//                           builder: (_, __) => OpacityTransition(
//                             visible: !_controller.isPlaying,
//                             child: GestureDetector(
//                               onTap: _controller.video.play,
//                               child: Container(
//                                 width: 40,
//                                 height: 40,
//                                 decoration: const BoxDecoration(
//                                   color: Colors.white,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.play_arrow,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 200,
//                     margin: const EdgeInsets.only(top: 10),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: _trimSlider(),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   ValueListenableBuilder(
//                     valueListenable: _isExporting,
//                     builder: (_, bool export, __) => OpacityTransition(
//                       visible: export,
//                       child: AlertDialog(
//                         backgroundColor: Colors.white,
//                         contentPadding: EdgeInsets.zero,
//                         title: ValueListenableBuilder(
//                           valueListenable: _exportingProgress,
//                           builder: (_, double value, __) => Text(
//                             "${(value * 100).ceil()}%",
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                         elevation: 0,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _exportVideo() async {
//     _exportingProgress.value = 0;
//     _isExporting.value = true;
//     // NOTE: To use `-crf 1` and [VideoExportPreset] you need `ffmpeg_kit_flutter_min_gpl` package (with `ffmpeg_kit` only it won't work)
//     await _controller.exportVideo(
//       // preset: VideoExportPreset.medium,
//       //  customInstruction: "-crf 17",
//       onProgress: (stats, value) => _exportingProgress.value = value,
//       onError: (e, s) {
//         throw s;
//       },
//       onCompleted: (file) {
//         Navigator.of(context).pop(file);
//       },
//     );
//   }
//
//   Widget _topNavBar() {
//     return SafeArea(
//       child: SizedBox(
//         height: height,
//         child: Row(
//           children: [
//             const Expanded(
//               child: BackButton(
//                 color: Colors.white,
//               ),
//             ),
//             const Expanded(
//               child: SizedBox(),
//             ),
//             Expanded(
//               child: IconButton(
//                 onPressed: _isExporting.value
//                     ? null
//                     : () => _controller.rotate90Degrees(RotateDirection.left),
//                 icon: const Icon(Icons.rotate_left),
//                 color: Colors.white,
//               ),
//             ),
//             Expanded(
//               child: IconButton(
//                 onPressed: _isExporting.value
//                     ? null
//                     : () => _controller.rotate90Degrees(),
//                 icon: const Icon(Icons.rotate_right),
//                 color: Colors.white,
//               ),
//             ),
//             Expanded(
//               child: ValueListenableBuilder<bool>(
//                 valueListenable: _isExporting,
//                 builder: (context, value, child) => value
//                     ? const CupertinoActivityIndicator(
//                         color: Colors.white,
//                       )
//                     : IconButton(
//                         onPressed: _exportVideo,
//                         icon: const Icon(Icons.done),
//                         color: Colors.white,
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String formatter(Duration duration) => [
//         duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
//         duration.inSeconds.remainder(60).toString().padLeft(2, '0')
//       ].join(":");
//
//   List<Widget> _trimSlider() {
//     return [
//       AnimatedBuilder(
//         animation: _controller.video,
//         builder: (_, __) {
//           final duration = _controller.video.value.duration.inSeconds;
//           final pos = _controller.trimPosition * duration;
//           final start = _controller.minTrim * duration;
//           final end = _controller.maxTrim * duration;
//
//           return Padding(
//             padding: EdgeInsets.symmetric(horizontal: height / 4),
//             child: Row(
//               children: [
//                 Text(
//                   formatter(Duration(seconds: pos.toInt())),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 const Expanded(child: SizedBox()),
//                 OpacityTransition(
//                   visible: _controller.isTrimming,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         formatter(Duration(seconds: start.toInt())),
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                         formatter(Duration(seconds: end.toInt())),
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//       Container(
//         width: MediaQuery.of(context).size.width,
//         margin: EdgeInsets.symmetric(vertical: height / 4),
//         child: TrimSlider(
//           controller: _controller,
//           height: height,
//           horizontalMargin: height / 4,
//           child: TrimTimeline(
//             controller: _controller,
//             margin: const EdgeInsets.only(top: 10),
//           ),
//         ),
//       )
//     ];
//   }
//
//   @override
//   void dispose() {
//     _exportingProgress.dispose();
//     _isExporting.dispose();
//     _controller.dispose();
//     super.dispose();
//   }
// }
