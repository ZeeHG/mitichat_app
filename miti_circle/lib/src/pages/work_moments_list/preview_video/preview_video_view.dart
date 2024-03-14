import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:miti_common/miti_common.dart';
import 'package:video_player/video_player.dart';

class PreviewVideoPage extends StatefulWidget {
  const PreviewVideoPage(
      {super.key, required this.url, this.coverUrl, this.heroTag});

  final String url;
  final String? coverUrl;
  final String? heroTag;

  @override
  State<PreviewVideoPage> createState() => _PreviewVideoPageState();
}

class _PreviewVideoPageState extends State<PreviewVideoPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  final _cachedVideoControllerService =
      CachedVideoControllerService(DefaultCacheManager());

  @override
  void initState() {
    initializePlayer();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    myLogger.i({"message": "initializePlayer开始"});
    _videoPlayerController =
        await _cachedVideoControllerService.getVideo(widget.url);
    myLogger.i({"message": "_videoPlayerController创建成功"});
    await _videoPlayerController.initialize();
    myLogger
        .i({"message": "_videoPlayerController初始化完成, 开始创建_chewieController"});
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      progressIndicatorDelay: const Duration(milliseconds: 1500),
      showControlsOnInitialize: true,
      // hideControlsTimer: const Duration(seconds: 1),
      customControls: const CustomMaterialControls(),
      optionsTranslation: OptionsTranslation(
        playbackSpeedButtonText: StrLibrary.playSpeed,
        cancelButtonText: StrLibrary.cancel,
      ),
      showOptions: false,
      // showControls: true,
      additionalOptions: (context) => [],
      // customControls: MaterialControls(
      // ),
      // showOptions: false,
      // Try playing around with some of these other options:
      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: SizedBox(),
      // autoInitialize: true,
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: widget.heroTag != null
  //         ? Hero(tag: widget.heroTag!, child: _childView)
  //         : _childView,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            systemNavigationBarColor: Styles.c_000000,
            systemNavigationBarIconBrightness: Brightness.light),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Styles.c_000000,
            toolbarHeight: 0,
          ),
          backgroundColor: Styles.c_000000,
          body: widget.heroTag != null
              ? Hero(tag: widget.heroTag!, child: _childView)
              : _childView,
        ));
  }

  Widget get _childView => Material(
        color: Styles.c_000000,
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : _buildCoverView(),
      );

  Widget _buildCoverView() => Stack(
        alignment: Alignment.center,
        children: [
          if (null != widget.coverUrl)
            Center(
                child:
                    // ImageUtil.networkImage(
                    //   url: widget.coverUrl!,
                    //   loadProgress: false,
                    // ),
                    CachedNetworkImage(
              imageUrl: widget.coverUrl!,
            )),
          const CircularProgressIndicator(),
          Positioned(
            right: 15,
            top: MediaQuery.of(context).padding.top + 10,
            child: GestureDetector(
              onTap: () {
                // Pop through controller
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 32,
              ),
            ),
          )
        ],
      );
}
