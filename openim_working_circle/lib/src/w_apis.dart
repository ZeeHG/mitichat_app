import 'dart:convert';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_working_circle/src/w_urls.dart';
import 'package:uuid/uuid.dart';

class WApis {
  /// 发布工作圈动态
  /// [type] 0 picture  1 video
  static Future publishMoments({
    String? text,
    int type = 0,
    List<Map<String, String>>? metas,
    List<UserInfo> permissionUserList = const [],
    List<GroupInfo> permissionGroupList = const [],
    List<UserInfo> atUserList = const [],
    int permission = 0,
  }) async {
    var metasUrl = [];
    // if (metas != null && metas.isNotEmpty) {
    //   const thumbKey = 'thumb'; // 缩率图
    //   const originalKey = 'original'; // 原文件
    //   // 将所有的多媒体文件取出来， 进行上传
    //   await Future.forEach<Map<String, String>>(metas, (element) async {
    //     var thumbPath = element[thumbKey]!;
    //     var originalPath = element[originalKey]!;
    //     final result = await Future.wait([
    //       OpenIM.iMManager.putFile(
    //         putID: '${DateTime.now().millisecondsSinceEpoch}',
    //         filePath: thumbPath,
    //         fileName: thumbPath,
    //       ),
    //       OpenIM.iMManager.putFile(
    //         putID: '${DateTime.now().millisecondsSinceEpoch}',
    //         filePath: originalPath,
    //         fileName: originalPath,
    //       ),
    //     ]);
    //     metasUrl.add({thumbKey: result[0], originalKey: result[1]});
    //   });
    // }

    if (null != metas && metas.isNotEmpty) {
      const thumbKey = 'thumb'; // 缩率图
      const originalKey = 'original'; // 原文件
      final allMetas = <String>[];
      for (var m in metas) {
        allMetas.add(m[thumbKey]!);
        allMetas.add(m[originalKey]!);
      }
      final result =
          await Future.wait(allMetas.map((e){
            final suffix = IMUtils.getSuffix(e);
            return OpenIM.iMManager.uploadFile(
              id: const Uuid().v4(),
              filePath: e,
              fileName: "${const Uuid().v4()}$suffix",
            );
          }));
      if (result.length.isEven) {
        for (int i = 0; i < result.length; i += 2) {
          final thumb = jsonDecode(result[i])['url'];
          final original = jsonDecode(result[i + 1])['url'];
          metasUrl.add({thumbKey: "$thumb?type=image&width=420&height=420", originalKey: original});
        }
      }
    }

    return HttpUtil.post(
      WUrls.createMoments,
      options: Apis.chatTokenOptions,
      data: <String, dynamic>{
        "content": {"metas": metasUrl, "text": text ?? '', "type": type},
        'permissionUserIDs': permissionUserList.map((e) => e.userID).toList(),
        'permissionGroupIDs':
            permissionGroupList.map((e) => e.groupID).toList(),
        'atUserIDs': atUserList.map((e) => e.userID).toList(),
        'permission': permission,
      },
    );
  }

  /// 删除
  static Future deleteMoments({
    required String workMomentID,
  }) {
    return HttpUtil.post(
      WUrls.deleteMoments,
      options: Apis.chatTokenOptions,
      data: <String, dynamic>{'workMomentID': workMomentID},
    );
  }

  /// 一条工作圈详情
  static Future<WorkMoments> getMomentsDetail({
    required String workMomentID,
  }) async {
    final result = await HttpUtil.post(
      WUrls.getMomentsDetail,
      options: Apis.chatTokenOptions,
      data: <String, dynamic>{'workMomentID': workMomentID},
    );
    return WorkMoments.fromJson(result['workMoment']);
  }

  /// 获取工作圈列表
  static Future<WorkMomentsList> getMomentsList({
    int pageNumber = 1,
    int showNumber = 20,
  }) {
    return HttpUtil.post(
      WUrls.getMomentsList,
      options: Apis.chatTokenOptions,
      data: <String, dynamic>{
        "pagination": {"pageNumber": pageNumber, "showNumber": showNumber}
      },
    ).then((value) => WorkMomentsList.fromJson(value));
  }

  static Future<WorkMomentsList> getUserMomentsList({
    required String userID,
    int pageNumber = 1,
    int showNumber = 20,
  }) {
    return HttpUtil.post(
      WUrls.getUserMomentsList,
      options: Apis.chatTokenOptions,
      data: <String, dynamic>{
        "userID": userID,
        "pagination": {"pageNumber": pageNumber, "showNumber": showNumber}
      },
    ).then((value) => WorkMomentsList.fromJson(value));
  }

  /// 点赞工作圈
  static Future likeMoments({
    required String workMomentID,
    required bool like,
  }) {
    return HttpUtil.post(
      WUrls.likeMoments,
      options: Apis.chatTokenOptions,
      data: <String, dynamic>{'workMomentID': workMomentID, "like": like},
    );
  }

  /// 评论工作圈
  static Future commentMoments({
    required String workMomentID,
    String? replyUserID,
    required String text,
  }) {
    return HttpUtil.post(
      WUrls.commentMoments,
      options: Apis.chatTokenOptions,
      data: <String, dynamic>{
        'workMomentID': workMomentID,
        'replyUserID': replyUserID ?? '',
        'content': text
      },
    );
  }

  /// 删除
  static Future deleteComment({
    required String workMomentID,
    required String commentID,
  }) {
    return HttpUtil.post(
      WUrls.deleteComment,
      options: Apis.chatTokenOptions,
      data: <String, dynamic>{
        'workMomentID': workMomentID,
        'commentID': commentID
      },
    );
  }

  /// 互动消息
  static Future<List<WorkMoments>> getInteractiveLogs({
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    final result = await HttpUtil.post(
      WUrls.getInteractiveLogs,
      options: Apis.chatTokenOptions,
      data: <String, dynamic>{
        "pagination": {"pageNumber": pageNumber, "showNumber": showNumber}
      },
    );
    final list = result['workMoments'];
    if (list == null) return [];
    return (list as List).map((e) => WorkMoments.fromJson(e)).toList();
  }

  /// 1:未读数 2:消息列表 3:全部
  static Future clearUnreadCount({required int type}) => HttpUtil.post(
        WUrls.clearUnreadCount,
        options: Apis.chatTokenOptions,
        data: <String, dynamic>{"type": type},
      );

  static Future<int> getUnreadCount() async {
    final result = await HttpUtil.post(
      WUrls.getUnreadCount,
      options: Apis.chatTokenOptions,
    );
    return result['total'] ?? 0;
  }
}
