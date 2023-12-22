import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../openim_working_circle.dart';
import '../../w_apis.dart';
import '../work_moments_list/preview_picture/preview_picture_view.dart';
import '../work_moments_list/preview_video/preview_video_view.dart';
import '../work_moments_list/work_moments_list_logic.dart';

class WorkMomentsDetailLogic extends GetxController {
  final inputCtrl = TextEditingController();
  late Rx<WorkMoments> workMoments;
  final popMenuID = ''.obs;
  Offset? popMenuPosition;
  Size? popMenuSize;
  final commentHintText = ''.obs;
  String? replyUserID;

  WorkingCircleBridge? get wcBridge => PackageBridge.workingCircleBridge;

  @override
  void onInit() {
    workMoments = Rx(WorkMoments(workMomentID: Get.arguments['workMomentID']));
    super.onInit();
  }

  @override
  void onReady() {
    LoadingView.singleton.wrap(asyncFunction: () => _updateData());
    super.onReady();
  }

  String get workMomentID => workMoments.value.workMomentID!;

  _updateData() async {
    final detail = await WApis.getMomentsDetail(
      workMomentID: workMomentID,
    );
    if (detail.workMomentID == null || detail.workMomentID!.isEmpty) {
      IMViews.showToast('记录可能已经被删除了');
      Get.back();
      return;
    }
    wcBridge?.opEventSub.add({'opEvent': OpEvent.update, 'data': detail});
    workMoments.update((val) {
      val?.userID = detail.userID;
      val?.content = detail.content;
      val?.likeUsers = detail.likeUsers;
      val?.comments = detail.comments;
      val?.faceURL = detail.faceURL;
      val?.nickname = detail.nickname;
      val?.atUsers = detail.atUsers;
      val?.permissionUsers = detail.permissionUsers;
      val?.createTime = detail.createTime;
      val?.permission = detail.permission;
    });
  }

  showLikeCommentPopMenu(String workMomentID) {
    popMenuID.value = workMomentID;
  }

  hiddenLikeCommentPopMenu() => showLikeCommentPopMenu("");

  popMenuPositionCallback(Offset position, Size size) {
    popMenuPosition = position;
    popMenuSize = size;
  }

  bool iIsLiked() =>
      workMoments.value.likeUsers
          ?.firstWhereOrNull((e) => e.userID == OpenIM.iMManager.userID) !=
      null;

  /// 点赞/取消点赞 朋友圈
  likeMoments() async {
    hiddenLikeCommentPopMenu();
    await LoadingView.singleton.wrap(
      asyncFunction: () async {
        await WApis.likeMoments(workMomentID: workMomentID, like: !iIsLiked());
        await _updateData();
      },
    );
  }

  /// 提交评论
  submitComment() async {
    final text = inputCtrl.text.trim();
    if (text.isNotEmpty) {
      await LoadingView.singleton.wrap(asyncFunction: () async {
        await WApis.commentMoments(
          workMomentID: workMomentID,
          text: text,
          replyUserID: replyUserID,
        );
        await _updateData();
      });
      cancelComment();
    }
  }

  /// 评论朋友圈
  commentMoments() async {
    hiddenLikeCommentPopMenu();
    commentHintText.value = '${StrRes.comment}：';
    replyUserID = null;
  }

  /// 回复评论
  replyComment(Comments comments) async {
    hiddenLikeCommentPopMenu();
    if (comments.userID == OpenIM.iMManager.userID) {
      final del = await Get.bottomSheet(
        BottomSheetView(items: [SheetItem(label: StrRes.delete, result: 1)]),
      );
      if (del == 1) {
        delComment(comments);
      }
    } else {
      commentHintText.value = '${StrRes.reply}${comments.nickname}：';
      replyUserID = comments.userID;
    }
  }

  /// 删除评论
  delComment(Comments comments) async {
    LoadingView.singleton.wrap(
      asyncFunction: () async {
        await WApis.deleteComment(
            workMomentID: workMomentID, commentID: comments.commentID!);
        await _updateData();
      },
    );
  }

  delWorkWorkMoments(WorkMoments moments) async {
    await LoadingView.singleton.wrap(
      asyncFunction: () async {
        await WApis.deleteMoments(workMomentID: moments.workMomentID!);
      },
    );
    wcBridge?.opEventSub.add({'opEvent': OpEvent.delete, 'data': moments});
    Get.back(result: true);
  }

  cancelComment() {
    commentHintText.value = '';
    replyUserID = null;
    inputCtrl.clear();
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

  /// 0：公开 1: 仅自己可见 2：部分可见 3：不给谁看
  previewWhoCanWatchList(WorkMoments moments) {
    if (moments.permission == 2 || moments.permission == 3) {
      WNavigator.startVisibleUsersList(workMoments: moments);
    }
  }
}
