// import 'package:flutter/services.dart';

// class VideoPlayerController {
//   final String videoUrl;
//   final MethodChannel _channel = const MethodChannel('video_player');
//   Function(bool)? _onPlaybackStateChanged;

//   VideoPlayerController({required this.videoUrl});

//   void play() {
//     _channel.invokeMethod('play');
//   }

//   void pause() {
//     _channel.invokeMethod('pause');
//   }

//   void loadUrl(String url) {
//     _channel.invokeMethod('loadUrl', url);
//   }

//   void seekBy(int seconds) {
//     _channel.invokeMethod('seekBy', seconds);
//   }

//   void setPlaybackRate(double rate) {
//     _channel.invokeMethod('setPlaybackRate', rate);
//   }

//   void setOnPlaybackStateChanged(Function(bool) callback) {
//     _onPlaybackStateChanged = callback;
//     _channel.setMethodCallHandler(_handleMethodCall);
//   }

//   Future<dynamic> _handleMethodCall(MethodCall call) async {
//     switch (call.method) {
//       case 'onPlaybackStateChanged':
//         if (_onPlaybackStateChanged != null) {
//           _onPlaybackStateChanged!(call.arguments);
//         }
//         break;
//     }
//     return null;
//   }

//   void dispose() {
//     _channel.invokeMethod('dispose');
//   }
// }
