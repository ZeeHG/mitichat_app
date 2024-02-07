import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_working_circle/openim_working_circle.dart';
import 'package:openim_working_circle/src/w_apis.dart';
import 'package:url_launcher/url_launcher.dart';

class XhsMomentDetailLogic extends GetxController {
  @override
  void onInit() {
    xhsMomentList.value = [xhsMomentArg.value];
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    super.onClose();
  }

  final xhsMomentArg = Rx<WorkMoments>(Get.arguments['xhsMoment']);
  final xhsMomentList = <WorkMoments>[].obs;
  final inputCtrl = TextEditingController();
  final commentHintText = ''.obs;
  String? replyUserID;

  ViewUserProfileBridge? get bridge => PackageBridge.viewUserProfileBridge;

  WorkingCircleBridge? get wcBridge => PackageBridge.workingCircleBridge;

  List<Comments> get comments => xhsMomentList[0].comments ?? [];

  int get commentsCount => comments.length;

  List<LikeUsers> get likeUsers => xhsMomentList[0].likeUsers ?? [];

  int get likeUsersCount => likeUsers.length;

  /// 我点赞了
  bool get iIsLiked =>
      likeUsers.firstWhereOrNull((e) => e.userID == OpenIM.iMManager.userID) !=
      null;

  /// 点赞/取消点赞 朋友圈
  likeMoments() async {
    final workMomentID = xhsMomentList[0].workMomentID!;
    await LoadingView.singleton.wrap(
      asyncFunction: () async {
        await WApis.likeMoments(workMomentID: workMomentID, like: !iIsLiked);
        await _updateData();
      },
    );
  }

  void onTapOriginCard() async {
    final url = xhsMomentList[0]?.content?.originLink;
    if (null != url &&
        url.isNotEmpty) {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    }
  }

  _updateData() async {
    final detail = await WApis.getMomentsDetail(
        workMomentID: xhsMomentList[0].workMomentID!, momentType: 2);
    final index = xhsMomentList.indexOf(detail);
    xhsMomentList.replaceRange(index, index + 1, [detail]);
  }

  /// 提交评论
  submitComment() async {
    final text = inputCtrl.text.trim();
    if (text.isNotEmpty) {
      await LoadingView.singleton.wrap(asyncFunction: () async {
        await WApis.commentMoments(
          workMomentID: xhsMomentList[0].workMomentID!,
          text: text,
          replyUserID: replyUserID,
        );
        await _updateData();
      });
      cancelComment();
    }
  }

  cancelComment() {
    commentHintText.value = '';
    replyUserID = null;
    inputCtrl.clear();
  }

  /// 评论朋友圈
  commentMoments() async {
    commentHintText.value = '${StrRes.comment}：';
    replyUserID = null;
  }

  /// 回复评论
  replyComment(Comments comments) async {
    if (comments.userID == OpenIM.iMManager.userID) {
      final del = await Get.bottomSheet(
        BottomSheetView(items: [SheetItem(label: StrRes.delete, result: 1)]),
      );
      if (del == 1) {
        delComment(comments);
      }
    } else {
      commentHintText.value = '${StrRes.reply} ${comments.nickname}：';
      replyUserID = comments.userID;
    }
  }

  /// 删除评论
  delComment(Comments comments) async {
    LoadingView.singleton.wrap(
      asyncFunction: () async {
        await WApis.deleteComment(
          workMomentID: xhsMomentList[0].workMomentID!,
          commentID: comments.commentID!,
        );
        await _updateData();
      },
    );
  }

  previewPicture(int index, List<Metas> metas) {
    navigator?.push(TransparentRoute(
      builder: (BuildContext context) => GestureDetector(
        onTap: () => Get.back(),
        child: PreviewPicturePage(
          metas: metas,
          currentIndex: index,
          heroTag: metas.elementAt(index).original,
        ),
      ),
    ));
  }

  previewVideo(String url, String? coverUrl) {
    navigator?.push(TransparentRoute(
      builder: (BuildContext context) => PreviewVideoPage(
        heroTag: url,
        url: url,
        coverUrl: coverUrl,
      ),
    ));
  }

  void viewMeta({int type = 0, required List<Metas> metas, int index = 0}) {
    if (type == 1) {
      previewVideo(metas[0]!.original!, metas[0]?.thumb ?? metas[0]!.original!);
    } else {
      previewPicture(index, metas);
    }
  }
}
