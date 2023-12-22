import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:openim_common/openim_common.dart';
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
    _videoPlayerController =
        await _cachedVideoControllerService.getVideo(widget.url);
    await _videoPlayerController.initialize();
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
        playbackSpeedButtonText: StrRes.playSpeed,
        cancelButtonText: StrRes.cancel,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: widget.heroTag != null
          ? Hero(tag: widget.heroTag!, child: _childView)
          : _childView,
    );
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
              child: ImageUtil.networkImage(
                url: widget.coverUrl!,
                loadProgress: false,
              ),
            ),
          const CircularProgressIndicator(),
        ],
      );
}
