import 'dart:io';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miti_common/miti_common.dart';

class MessageUtil extends GetxController {
  final Map<String, bool> cachedVoiceMessage = {};

  cacheVoiceMessageList(List<Message> list) {
    final voiceMessageList = list.where(((item) => item.isVoiceType));
    for (var msg in voiceMessageList) {
      _cacheVoiceMessage(msg);
    }
  }

  _cacheVoiceMessage(Message msg) async {
    if (null != msg.clientMsgID &&
        cachedVoiceMessage.containsKey(msg.clientMsgID)) {
      return;
    }
    cachedVoiceMessage[msg.clientMsgID!] = true;
    final cacheAudioPlayer = AudioPlayer();

    bool isReceived = msg.sendID != OpenIM.iMManager.userID;
    String? path = msg.soundElem?.soundPath;
    String? url = msg.soundElem?.sourceUrl;
    if (isReceived) {
      if (null != url && url.trim().isNotEmpty) {
        final audioSource = LockCachingAudioSource(Uri.parse(url));
        cacheAudioPlayer.setAudioSource(audioSource);
      }
    } else {
      bool existFile = false;
      if (path != null && path.trim().isNotEmpty) {
        var file = File(path);
        existFile = await file.exists();
      }
      if (!existFile && null != url && url.trim().isNotEmpty) {
        final audioSource = LockCachingAudioSource(Uri.parse(url));
        cacheAudioPlayer.setAudioSource(audioSource);
      }
    }
    myLogger.e(cachedVoiceMessage.keys);
  }
}
