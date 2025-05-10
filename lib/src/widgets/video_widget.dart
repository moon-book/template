// part of '../../template.dart';

// // class VideoWidget extends StatefulWidget {
// //   const VideoWidget({
// //     super.key,
// //     required this.url,
// //     this.height,
// //     this.width,
// //   });
// //   final String url;
// //   final double? width;
// //   final double? height;
// //   @override
// //   State<VideoWidget> createState() => _VideoWidgetState();
// // }

// // class _VideoWidgetState extends State<VideoWidget> {
// //   VideoPlayerController? _videoController;
// //   ChewieController? _chewieController;

// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     // TODO: implement dispose
// //     _videoController?.dispose(); // Giải phóng bộ nhớ video khi widget bị hủy

// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (widget.url.isEmpty) return Container();
// //     return Container(
// //       width: widget.width ?? 500,
// //       height: widget.height ?? 200,
// //       // color: Colors.red,
// //       child: FutureBuilder<void>(
// //         future: _initializeVideoPlayer(widget.url),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.done) {
// //             return AspectRatio(
// //               aspectRatio: _videoController!.value.aspectRatio,
// //               child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
// //                   ? Chewie(
// //                       controller: _chewieController!,
// //                     )
// //                   : Container(),
// //             );
// //           } else {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //         },
// //       ),
// //     );
// //   }

// //   Future<void> _initializeVideoPlayer(String videoUrl) async {
// //     _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
// //     await _videoController!.initialize();

// //     // Tạo ChewieController với VideoPlayerController
// //     _chewieController = ChewieController(
// //       videoPlayerController: _videoController!,
// //       aspectRatio: _videoController!.value.aspectRatio,
// //       autoPlay: false,
// //       looping: false,
// //       // Tùy chọn thêm cho điều khiển
// //       allowFullScreen: true, // Cho phép toàn màn hình
// //       allowMuting: true, // Cho phép tắt âm thanh
// //       autoInitialize: true, // Tự động khởi tạo
// //     );
// //     // setState(() {}); // Cập nhật giao diện sau khi video đã sẵn sàng
// //   }
// // }

// // ignore: avoid_web_libraries_in_flutter

// class VideoPLayerMoon extends StatefulWidget {
//   final String url;
//   final bool controls;
//   final RawHlsVideoType videoType;
//   final void Function()? onFinished;
//   final bool autoPlay;
//   final bool disposeWhenNotVisible;
//   final double? width;
//   final double? height;
//   const VideoPLayerMoon({
//     super.key,
//     required this.url,
//     this.controls = true,
//     this.videoType = RawHlsVideoType.livestream,
//     this.onFinished,
//     this.autoPlay = false,
//     this.disposeWhenNotVisible = true,
//     this.width,
//     this.height,
//   });

//   @override
//   State<VideoPLayerMoon> createState() => _VideoPLayerMoonState();
// }

// class _VideoPLayerMoonState extends State<VideoPLayerMoon> {
//   late final html.VideoElement videoElement;
//   late final String id;
//   bool reappear = true;
//   int videoViewId = 0;
//   Function? onEndListener;

//   @override
//   void initState() {
//     super.initState();
//     id = randomAlpha(8);

//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory("video-$id", (int viewId) {
//       // ignore: join_return_with_assignment
//       videoElement = html.VideoElement()
//         ..onCanPlay.listen((event) {
//           if (widget.autoPlay) return;
//           videoElement.pause();
//         })
//         ..className = "video-${widget.videoType.name}"
//         ..id = "video-$id"
//         ..poster = "https://moon.vn/assets/video_holder.png"
//         ..controls = widget.controls
//         ..style.border = "none"
//         ..style.height = "100%"
//         ..style.width = "100%";
//       return videoElement;
//     });

//     if (widget.onFinished != null) {
//       onEndListener = widget.onFinished;
//       html.window.addEventListener("message", listenToEnded);
//     }
//   }

//   @override
//   void dispose() {
//     try {
//       // if (widget.onFinished != null) {
//       //   html.window.removeEventListener("message", listenToEnded);
//       // }
//       onEndListener = null;
//       _pauseVideo();
//       _disposeVideo();
//     } catch (_) {}

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return VisibilityDetector(
//       onVisibilityChanged: (VisibilityInfo info) {
//         if (info.visibleFraction == 0) {
//           try {
//             _pauseVideo();
//             if (widget.disposeWhenNotVisible) {
//               _disposeVideo();
//             }
//           } catch (_) {}
//           reappear = true;
//         }
//         if (info.visibleFraction == 1 && reappear) {
//           _setupVideo(
//             videoElement: videoElement,
//             type: widget.videoType,
//             listenToEnded: widget.onFinished != null,
//           );
//           reappear = false;
//         }
//       },
//       key: ValueKey("video-$id"),
//       child: Container(
//         color: Colors.transparent,
//         height: widget.width ?? MediaQuery.of(context).size.height,
//         width: widget.height ?? MediaQuery.of(context).size.width,
//         child: HtmlElementView(
//           viewType: "video-$id",
//           onPlatformViewCreated: (int viewId) {
//             videoViewId = viewId;
//             _setupVideo(
//               videoElement: videoElement,
//               type: widget.videoType,
//               listenToEnded: widget.onFinished != null,
//             );
//           },
//         ),
//       ),
//     );
//   }

//   _setupVideo({
//     required RawHlsVideoType type,
//     required html.VideoElement videoElement,
//     bool listenToEnded = false,
//   }) {
//     js.context.callMethod(
//       "setUpHlsElement",
//       [videoElement, widget.url, type.name, listenToEnded],
//     );
//   }

//   _pauseVideo() {
//     try {
//       js.context.callMethod("stopVideo", [videoElement]);
//     } catch (_) {
//       js.context.callMethod("stopVideoById", ["video-$id"]);
//     }
//   }

//   _disposeVideo() {
//     js.context.callMethod("disposeHls", ["video-$id"]);
//   }

//   listenToEnded(html.Event e) {
//     if ((e as html.MessageEvent).data as String == "video-$id") {
//       e.preventDefault();
//       onEndListener?.call();
//       onEndListener = null;
//     }
//   }
// }

// enum RawHlsVideoType {
//   livestream,
//   vod,
// }
