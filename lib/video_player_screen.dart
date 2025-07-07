// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/native_video_player.dart';
// import 'package:flutter_application_1/video_player_controller.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final dynamic data;
//   const VideoPlayerScreen({super.key, required this.data});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   final videoUrl =
//       "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
//   late VideoPlayerController _controller;
//   double _playbackRate = 1.0;
//   bool _isPlaying = false;
//   bool _isFullscreen = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController(videoUrl: videoUrl);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _isFullscreen
//           ? null
//           : AppBar(
//               title: const Text('PlatformView Video Player'),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.fullscreen),
//                   onPressed: () {
//                     setState(() => _isFullscreen = true);
//                   },
//                 ),
//               ],
//             ),
//       body: _isFullscreen ? _buildFullscreenView() : _buildNormalView(),
//     );
//   }

//   Widget _buildNormalView() {
//     return Column(
//       children: [
//         Expanded(
//           child: AspectRatio(
//             aspectRatio: 16 / 9,
//             child: NativeVideoPlayer(
//               controller: _controller,
//               onPlaybackStateChanged: (isPlaying) {
//                 setState(() => _isPlaying = isPlaying);
//               },
//             ),
//           ),
//         ),
//         _buildControls(),
//         _buildVideoList(),
//       ],
//     );
//   }

//   Widget _buildFullscreenView() {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: NativeVideoPlayer(
//             controller: _controller,
//             onPlaybackStateChanged: (isPlaying) {
//               setState(() => _isPlaying = isPlaying);
//             },
//           ),
//         ),
//         Positioned(
//           top: 40,
//           left: 20,
//           child: IconButton(
//             icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
//             onPressed: () {
//               setState(() => _isFullscreen = false);
//             },
//           ),
//         ),
//         Positioned(
//           bottom: 20,
//           left: 0,
//           right: 0,
//           child: _buildControls(),
//         ),
//       ],
//     );
//   }

//   Widget _buildControls() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.skip_previous),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//             onPressed: () {
//               if (_isPlaying) {
//                 _controller.pause();
//               } else {
//                 _controller.play();
//               }
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.skip_next),
//             onPressed: () {},
//           ),
//           const SizedBox(width: 20),
//           IconButton(
//             icon: const Icon(Icons.replay_10),
//             onPressed: () => _controller.seekBy(-10),
//           ),
//           IconButton(
//             icon: const Icon(Icons.forward_10),
//             onPressed: () => _controller.seekBy(10),
//           ),
//           const SizedBox(width: 20),
//           DropdownButton<double>(
//             value: _playbackRate,
//             items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
//                 .map((rate) => DropdownMenuItem(
//                       value: rate,
//                       child: Text("${rate}x"),
//                     ))
//                 .toList(),
//             onChanged: (value) {
//               if (value != null) {
//                 setState(() => _playbackRate = value);
//                 _controller.setPlaybackRate(value);
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVideoList() {
//     final videos = [
//       {
//         "title": "Big Buck Bunny",
//         "url":
//             "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
//       },
//       {
//         "title": "Elephant Dream",
//         "url":
//             "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
//       },
//       {
//         "title": "For Bigger Blazes",
//         "url":
//             "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
//       },
//       {
//         "title": "Tears of Steel",
//         "url":
//             "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"
//       },
//     ];

//     return Expanded(
//       child: ListView.builder(
//         itemCount: videos.length,
//         itemBuilder: (context, index) {
//           final video = videos[index];
//           return ListTile(
//             leading: const Icon(Icons.play_circle_outline),
//             title: Text(video["title"]!),
//             onTap: () {
//               _controller.loadUrl(video["url"]!);
//               _controller.play();
//               setState(() => _isPlaying = true);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
