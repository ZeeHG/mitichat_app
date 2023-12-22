import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_working_circle/src/widgets/work_moments_item.dart';

import 'detail_logic.dart';

class WorkMomentsDetailPage extends StatelessWidget {
  final logic = Get.find<WorkMomentsDetailLogic>(tag: GetTags.momentsDetail);

  WorkMomentsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.detail),
      backgroundColor: Styles.c_FFFFFF,
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
        color: Styles.c_F0F2F6,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Styles.c_FFFFFF,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  controller: logic.inputCtrl,
                  autofocus: true,
                  minLines: 1,
                  maxLines: 4,
                  style: Styles.ts_0C1C33_17sp,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: logic.commentHintText.value,
                    hintStyle: Styles.ts_8E9AB0_17sp,
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
            ImageRes.sendMessage.toImage
              ..width = 32.w
              ..height = 32.h
              ..onTap = logic.submitComment,
          ],
        ),
      );
}
