// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_application_1/video_player_controller.dart';

// class NativeVideoPlayer extends StatelessWidget {
//   final VideoPlayerController controller;
//   final Function(bool)? onPlaybackStateChanged;

//   const NativeVideoPlayer({
//     super.key,
//     required this.controller,
//     this.onPlaybackStateChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (onPlaybackStateChanged != null) {
//       controller.setOnPlaybackStateChanged(onPlaybackStateChanged!);
//     }

//     if (Theme.of(context).platform == TargetPlatform.iOS) {
//       return UiKitView(
//         viewType: 'NativeVideoPlayer',
//         creationParams: {'videoUrl': controller.videoUrl},
//         creationParamsCodec: const StandardMessageCodec(),
//       );
//     } else if (Theme.of(context).platform == TargetPlatform.android) {
//       return AndroidView(
//         viewType: 'NativeVideoPlayer',
//         creationParams: {'videoUrl': controller.videoUrl},
//         creationParamsCodec: const StandardMessageCodec(),
//       );
//     } else {
//       return const Center(
//         child: Text('Platform not supported'),
//       );
//     }
//   }
// }
