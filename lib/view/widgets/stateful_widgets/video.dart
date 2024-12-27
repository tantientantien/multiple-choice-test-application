import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';


// class VideoPlayerWidget extends StatefulWidget {
//   final String videoURL;

//   VideoPlayerWidget({required this.videoURL});

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _videoPlayerController;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool isVideoPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _videoPlayerController = VideoPlayerController.network(widget.videoURL);
//     _initializeVideoPlayerFuture =
//         _videoPlayerController.initialize().then((_) {
//       setState(() {
//         isVideoPlaying = true;
//       });
//       _videoPlayerController.play();
//       _videoPlayerController.setLooping(true);
//     });
//   }

//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done &&
//             isVideoPlaying) {
//           return Column(
//             children: [
//               AspectRatio(
//                 aspectRatio: _videoPlayerController.value.aspectRatio,
//                 child: VideoPlayer(_videoPlayerController),
//               ),
//               // ElevatedButton(
//               //   onPressed: () {
//               //     setState(() {
//               //       if (_videoPlayerController.value.isPlaying) {
//               //         _videoPlayerController.pause();
//               //       } else {
//               //         _videoPlayerController.play();
//               //       }
//               //     });
//               //   },
//               //   child: Text(_videoPlayerController.value.isPlaying ? 'Pause' : 'Play'),
//               // ),
//             ],
//           );
//         } else {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }
// }

// // class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
// //   late VideoPlayerController _videoPlayerController;
// //   late Future<void> _initializeVideoPlayerFuture;

// //   @override
// //   void initState() {
// //     _videoPlayerController = VideoPlayerController.network(widget.videoURL);
// //     _initializeVideoPlayerFuture =
// //         _videoPlayerController.initialize().then((_) {
// //       _videoPlayerController.play();
// //       _videoPlayerController.setLooping(true);
// //       setState(() {});
// //     });
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     _videoPlayerController.dispose();
// //     super.dispose();
// //   }

// //   Widget build(BuildContext context) {
// //     return FutureBuilder(
// //         future: _initializeVideoPlayerFuture,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.done) {
// //             return AspectRatio(
// //               aspectRatio: _videoPlayerController.value.aspectRatio,
// //               child: VideoPlayer(_videoPlayerController),
// //             );
// //           } else {
// //             return const Center(
// //               child: CircularProgressIndicator(),
// //             );
// //           }
// //         });
// //   }
// // }

class VideoPlayerPage extends StatefulWidget {
  final Uri assetVideoPath;
  VideoPlayerPage({required this.assetVideoPath});
  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}
class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late CustomVideoPlayerController _customVideoPlayerController;
  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomVideoPlayer(
          customVideoPlayerController: _customVideoPlayerController),
    );
  }
  void initializeVideoPlayer() {
    VideoPlayerController _videoPlayerController;
    _videoPlayerController =
        VideoPlayerController.networkUrl(widget.assetVideoPath)
          ..initialize().then((value) {
            setState(() {});
          });
    _customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: _videoPlayerController);
  }
}
