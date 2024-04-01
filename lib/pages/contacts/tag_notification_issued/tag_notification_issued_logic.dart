// import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:miti/routes/app_navigator.dart';
// import 'package:miti_common/miti_common.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// class TagNotificationIssuedLogic extends GetxController {
//   final refreshCtrl = RefreshController();
//   final list = <TagNotification>[].obs;
//   int pageNumber = 1;
//   int showNumber = 20;
//   final _audioPlayer = AudioPlayer();
//   final _currentPlayID = "".obs;

//   @override
//   void onInit() {
//     _initPlayListener();
//     super.onInit();
//   }

//   @override
//   void onReady() {
//     LoadingView.singleton.start(fn: () => queryNotificationLogs());
//     super.onReady();
//   }

//   queryNotificationLogs() async {
//     List<TagNotification>? list;
//     try {
//       list = await Apis.getTagNotificationLog(
//         pageNumber: pageNumber = 1,
//         showNumber: showNumber,
//       );
//       this.list.assignAll(list);
//     } catch (_) {}
//     refreshCtrl.refreshCompleted();
//     if (null == list || list.length < showNumber) {
//       refreshCtrl.loadNoData();
//     } else {
//       refreshCtrl.loadComplete();
//     }
//   }

//   loadNotificationLogs() async {
//     List<TagNotification>? list;
//     try {
//       list = await Apis.getTagNotificationLog(
//         pageNumber: ++pageNumber,
//         showNumber: showNumber,
//       );
//       this.list.assignAll(list);
//     } catch (_) {}
//     if (null == list || list.length < showNumber) {
//       refreshCtrl.loadNoData();
//     } else {
//       refreshCtrl.loadComplete();
//     }
//   }

//   int getAcceptCount(TagNotification ntf) {
//     final c1 = (ntf.users == null ? 0 : ntf.users!.length);
//     final c2 = (ntf.groups == null ? 0 : ntf.groups!.length);
//     final c3 = (ntf.tags == null ? 0 : ntf.tags!.length);
//     return c1 + c2 + c3;
//   }

//   String getAcceptObject(TagNotification ntf) {
//     final list = <String?>[];
//     if (null != ntf.users) {
//       for (var user in ntf.users!) {
//         list.add(user.nickname);
//       }
//     }
//     if (null != ntf.groups) {
//       for (var group in ntf.groups!) {
//         list.add(group.groupName);
//       }
//     }
//     if (null != ntf.tags) {
//       for (var tag in ntf.tags!) {
//         list.add(tag.tagName);
//       }
//     }
//     return list.join('、');
//   }

//   void newBuild() async {
//     final result = await AppNavigator.startNewBuildNotification();
//     if (result == true) {
//       LoadingView.singleton.start(fn: () => queryNotificationLogs());
//     }
//   }

//   delete(TagNotification ntf) async {
//     final result = await Get.dialog(
//       CustomDialog(title: StrLibrary.confirmDelTagNotificationHint),
//     );
//     if (result == true) {
//       await LoadingView.singleton.start(
//         fn: () => Apis.delTagNotificationLog(ids: [ntf.id!]),
//       );
//       list.remove(ntf);
//     }
//   }

//   void viewNotificationDetail(TagNotification ntf) async {
//     // stopVoiceMessage(ntf);
//     final result = await AppNavigator.startNotificationDetail(
//       notification: ntf,
//     );
//     if (result == true) {
//       LoadingView.singleton.start(fn: () => queryNotificationLogs());
//     }
//   }

//   bool isPlaySound(TagNotification ntf) {
//     return _currentPlayID.value == ntf.id!;
//   }

//   /// 播放语音消息
//   void playVoiceMessage(TagNotification ntf) async {
//     var isClickSame = _currentPlayID.value == ntf.id;
//     if (_audioPlayer.playerState.playing) {
//       _currentPlayID.value = "";
//       _audioPlayer.stop();
//     }
//     if (!isClickSame) {
//       bool isValid = await _initVoiceSource(ntf);
//       if (isValid) {
//         _audioPlayer.seek(Duration.zero);
//         _audioPlayer.play();
//         _currentPlayID.value = ntf.id!;
//       }
//     }
//   }

//   void stopVoiceMessage(TagNotification ntf) {
//     if (_audioPlayer.playerState.playing) {
//       _currentPlayID.value = "";
//       _audioPlayer.stop();
//     }
//   }

//   /// 语音消息资源处理
//   Future<bool> _initVoiceSource(TagNotification ntf) async {
//     String? url = ntf.parseContent()?.soundElem?.sourceUrl;
//     bool isExistSource = false;
//     if (null != url && url.trim().isNotEmpty) {
//       isExistSource = true;
//       _audioPlayer.setUrl(url);
//     }
//     return isExistSource;
//   }

//   void _initPlayListener() {
//     _audioPlayer.playerStateStream.listen((state) {
//       switch (state.processingState) {
//         case ProcessingState.idle:
//         case ProcessingState.loading:
//         case ProcessingState.buffering:
//         case ProcessingState.ready:
//           break;
//         case ProcessingState.completed:
//           _currentPlayID.value = "";
//           break;
//       }
//     });
//   }
// }
