// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// import '../../../core/ctrl/im_ctrl.dart';

// class OANotificationLogic extends GetxController {
//   late ConversationInfo info;
//   var messageList = <Message>[].obs;
//   final pageSize = 40;
//   final refreshController = RefreshController(initialRefresh: false);
//   final imCtrl = Get.find<IMCtrl>();
//   int? lastMinSeq;
//   bool _isFirstLoad = false;

//   @override
//   void onInit() {
//     info = Get.arguments;
//     // 新增消息监听
//     imCtrl.onRecvNewMessage = (Message message) {
//       if (message.contentType == MessageType.oaNotification) {
//         if (!messageList.contains(message)) messageList.add(message);
//       }
//     };
//     super.onInit();
//   }

//   @override
//   void onReady() {
//     loadNotification();
//     super.onReady();
//   }

//   /// 3
//   /// 2
//   /// 1
//   /// 0
//   void loadNotification() async {
//     final result =
//         await OpenIM.iMManager.messageManager.getAdvancedHistoryMessageList(
//       conversationID: info.conversationID,
//       count: 200,
//       startMsg: _isFirstLoad ? null : messageList.firstOrNull,
//       lastMinSeq: _isFirstLoad ? null : lastMinSeq,
//     );
//     if (result.messageList == null || result.messageList!.isEmpty) {
//       return refreshController.loadNoData();
//     }
//     final list = result.messageList!;
//     lastMinSeq = result.lastMinSeq;

//     if (_isFirstLoad) {
//       _isFirstLoad = false;
//       messageList.assignAll(list);
//     } else {
//       messageList.insertAll(0, list);
//     }
//     if (list.length < pageSize) {
//       refreshController.loadNoData();
//     } else {
//       refreshController.loadComplete();
//     }
//   }

//   OANotification parse(Message message) =>
//       OANotification.fromJson(json.decode(message.notificationElem!.detail!));

//   Size calSize(OANotification oa, double w, double h) {
//     final width = 50.w;
//     // final width = message.videoElem?.snapshotWidth?.toDouble();
//     // final height = message.videoElem?.snapshotHeight?.toDouble();
//     final height = width * h / w;
//     return Size(width, height);
//   }
// }
