import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/pages/xhs/xhs_logic.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'package:miti_circle/miti_circle.dart';
import 'package:miti_circle/src/w_apis.dart';
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
  final xhsLogic = Get.find<XhsLogic>();

  String? replyUserID;

  ViewUserProfileBridge? get bridge => MitiBridge.viewUserProfileBridge;

  FriendCircleBridge? get wcBridge => MitiBridge.friendCircleBridge;

  List<Comments> get comments => xhsMomentList[0].comments ?? [];

  int get commentsCount => comments.length;

  List<LikeUsers> get likeUsers => xhsMomentList[0].likeUsers ?? [];

  int get likeUsersCount => likeUsers.length;

  bool get isMyMoment => xhsMomentList[0].userID == OpenIM.iMManager.userID;

  /// 我点赞了
  bool get iIsLiked =>
      likeUsers.firstWhereOrNull((e) => e.userID == OpenIM.iMManager.userID) !=
      null;

  /// 点赞/取消点赞 朋友圈
  likeMoments() async {
    final workMomentID = xhsMomentList[0].workMomentID!;
    if (!iIsLiked) {
      ClientApis.addActionRecord(actionRecordList: [
        ActionRecord(
            category: ActionCategory.discover,
            actionName: ActionName.click_like,
            workMomentID: workMomentID)
      ]);
    }
    await LoadingView.singleton.start(
      fn: () async {
        await WApis.likeMoments(workMomentID: workMomentID, like: !iIsLiked);
        await _updateData();
      },
    );
  }

  void onTapOriginCard() async {
    final url = xhsMomentList[0]?.content?.originLink;
    if (null != url && url.isNotEmpty) {
      if (await canLaunchUrl(Uri.parse(url))) {
        ClientApis.addActionRecord(actionRecordList: [
          ActionRecord(
              category: ActionCategory.discover,
              actionName: ActionName.read_origin,
              workMomentID: xhsMomentList[0].workMomentID)
        ]);
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
      ClientApis.addActionRecord(actionRecordList: [
        ActionRecord(
            category: ActionCategory.discover,
            actionName: ActionName.publish_comment,
            workMomentID: xhsMomentList[0].workMomentID)
      ]);
      await LoadingView.singleton.start(fn: () async {
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
    ClientApis.addActionRecord(actionRecordList: [
      ActionRecord(
          category: ActionCategory.discover,
          actionName: ActionName.click_comment,
          workMomentID: xhsMomentList[0].workMomentID)
    ]);
    commentHintText.value = '${StrLibrary.comment}：';
    replyUserID = null;
  }

  /// 回复评论
  replyComment(Comments comments) async {
    ClientApis.addActionRecord(actionRecordList: [
      ActionRecord(
          category: ActionCategory.discover,
          actionName: ActionName.click_comment,
          workMomentID: xhsMomentList[0].workMomentID)
    ]);
    if (comments.userID == OpenIM.iMManager.userID) {
      final del = await Get.bottomSheet(
        barrierColor: StylesLibrary.c_191919_opacity50,
        BottomSheetView(
            items: [SheetItem(label: StrLibrary.delete, result: 1)]),
      );
      if (del == 1) {
        delComment(comments);
      }
    } else {
      commentHintText.value = '${StrLibrary.reply} ${comments.nickname}：';
      replyUserID = comments.userID;
    }
  }

  /// 删除评论
  delComment(Comments comments) async {
    LoadingView.singleton.start(
      fn: () async {
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

  delXhsMoment() async {
    await xhsLogic.delWorkWorkMoments(xhsMomentList[0]);
    Get.back();
  }

  void openMoreSheet() async {
    IMViews.openXhsDetailMoreSheet(
        showDelete: isMyMoment,
        onTapSheetItem: (action) {
          if (action == "delete") {
            delXhsMoment();
          } else if (action == "complaint") {
            AppNavigator.startComplaint(params: {
              "pageTitle": StrLibrary.complaint2,
              "complaintType": ComplaintType.xhs,
              "workMomentID": xhsMomentList[0].workMomentID!
            });
          }
        });
  }
}
