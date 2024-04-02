import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:miti_circle/src/widgets/work_moments_item.dart';

import 'detail_logic.dart';

class MomentsDetailPage extends StatelessWidget {
  final logic = Get.find<MomentsDetailLogic>(tag: GetTags.momentsDetail);

  MomentsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.detail),
      backgroundColor: StylesLibrary.c_FFFFFF,
      body: Obx(() => logic.workMoments.value.nickname == null
          ? const SizedBox()
          : Stack(
              children: [
                Listener(
                  onPointerDown: (event) {
                    logic.cancelComment();
                    final position = logic.popMenuPosition;
                    final size = logic.popMenuSize;
                    if (null != position && size != null) {
                      final dx = event.position.dx;
                      final dy = event.position.dy;
                      if (dx > position.dx &&
                          dx < (position.dx + size.width) &&
                          dy > position.dy &&
                          dy < (position.dy + size.height)) {
                        // 点击事件在菜单上
                      } else {
                        logic.hiddenLikeCommentPopMenu();
                      }
                    }
                  },
                  child: ListView(
                    children: [
                      Obx(
                        () => WorkMomentsItem(
                          moments: logic.workMoments.value,
                          popMenuID: logic.popMenuID.value,
                          delMoment: logic.delWorkWorkMoments,
                          replyComment: (_, c) => logic.replyComment(c),
                          delComment: (_, c) => logic.delComment(c),
                          onPositionCallback: logic.popMenuPositionCallback,
                          onTapLike: (_) => logic.likeMoments(),
                          onTapComment: (_) => logic.commentMoments(),
                          isLike: logic.iIsLiked(),
                          showLikeCommentPopMenu: logic.showLikeCommentPopMenu,
                          previewVideo: logic.previewVideo,
                          previewPicture: logic.previewPicture,
                          previewWhoCanWatchList: logic.previewWhoCanWatchList,
                        ),
                      )
                    ],
                  ),
                ),
                if (logic.commentHintText.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _inputBox,
                  ),
              ],
            )),
    );
  }

  Widget get _inputBox => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        color: StylesLibrary.c_F7F8FA,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: StylesLibrary.c_FFFFFF,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  controller: logic.inputCtrl,
                  autofocus: true,
                  minLines: 1,
                  maxLines: 4,
                  style: StylesLibrary.ts_333333_16sp,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: logic.commentHintText.value,
                    hintStyle: StylesLibrary.ts_999999_16sp,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),
            12.horizontalSpace,
            ImageLibrary.appSendMessage2.toImage
              ..width = 28.w
              ..height = 28.h
              ..onTap = logic.submitComment,
          ],
        ),
      );
}
