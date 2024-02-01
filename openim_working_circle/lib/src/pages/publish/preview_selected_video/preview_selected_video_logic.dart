import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:video_player/video_player.dart';

import '../publish_logic.dart';

class PreviewSelectedVideoLogic extends GetxController {
  final publishLogic = Get.find<PublishLogic>();
  late VideoPlayerController _videoPlayerController;
  ChewieController? chewieController;
  final isInitialized = false.obs;

  @override
  void onInit() {
    _initializePlayer();
    super.onInit();
  }

  Future<void> _initializePlayer() async {
    final entity = publishLogic.assetsList[0];
    final file = await entity.file;
    _videoPlayerController = VideoPlayerController.file(file!);
    await _videoPlayerController.initialize();
    _createChewieController();
    isInitialized.value = true;
  }

  void _createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      // progressIndicatorDelay: null,
      showControlsOnInitialize: true,
      customControls: const CustomMaterialControls(),
      // hideControlsTimer: const Duration(seconds: 1),
      // showOptions: false,
      showControls: true,
      optionsTranslation: OptionsTranslation(
        playbackSpeedButtonText: StrRes.playSpeed,
        cancelButtonText: StrRes.cancel,
      ),
      additionalOptions: (context) => [],
    );
  }

  void delete() {
    if (chewieController?.isPlaying == true) {
      chewieController?.pause();
    }
    publishLogic.deleteAssets(0);
    if (publishLogic.assetsList.isEmpty) {
      Get.back();
    }
  }
}
