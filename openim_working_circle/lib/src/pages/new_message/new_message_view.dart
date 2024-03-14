import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sprintf/sprintf.dart';

import 'new_message_logic.dart';

class NewMessagePage extends StatelessWidget {
  final logic = Get.find<NewMessageLogic>();

  NewMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TitleBar.back(
          title: StrLibrary.message,
          right: StrLibrary.clearAll.toText
            ..style = Styles.ts_333333_16sp
            ..onTap = logic.clearNewMessage,
        ),
        backgroundColor: Styles.c_FFFFFF,
        body: Obx(
          () => AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                  systemNavigationBarColor: Styles.c_FFFFFF),
              child: SmartRefresher(
                controller: logic.refreshCtrl,
                enablePullUp: true,
                enablePullDown: true,
                header: IMViews.buildHeader(),
                footer: IMViews.buildFooter(),
                onRefresh: logic.refreshNewMessage,
                onLoading: logic.loadNewMessage,
                child: ListView.builder(
                  itemCount: logic.list.length,
                  itemBuilder: (_, index) {
                    final info = logic.list.elementAt(index);
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => logic.viewDetail(info),
                      child: _buildItemView(
                        info: info,
                        underline: index != logic.list.length - 1,
                      ),
                    );
                  },
                ),
              )),
        ));
  }

  Widget _buildItemView({
    required WorkMoments info,
    bool underline = false,
  }) {
    String? nickname;
    String? faceURL;
    String? content;
    String? replyNickname;
    if (info.type == 1) {
      // 为你点了赞
      final liker = info.likeUsers!.firstOrNull;
      nickname = liker!.nickname!;
      faceURL = liker.faceURL;
    } else if (info.type == 2) {
      nickname = info.nickname!;
      faceURL = info.faceURL;
    } else if (info.type == 3) {
      // 评论了你
      final comment = info.comments!.firstOrNull;
      nickname = comment!.nickname;
      content = comment.content;
      replyNickname =
          IMUtils.getShowName(comment.replyUserID, comment.replyNickname);
      faceURL = comment.faceURL;
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        border: underline
            ? BorderDirectional(
                bottom: BorderSide(color: Styles.c_EDEDED, width: 1.h),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarView(
            url: faceURL,
            text: nickname,
            width: 48.w,
            height: 48.h,
          ),
          6.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (nickname ?? '').toText..style = Styles.ts_9280B3_16sp_medium,
                4.verticalSpace,
                // 为你点了赞
                info.type == 1
                    ? Row(
                        children: [
                          Icon(
                            Icons.thumb_up,
                            size: 13.w,
                            color: Styles.c_9280B3,
                          ),
                          4.horizontalSpace,
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: StrLibrary.likedWho2,
                              style: Styles.ts_333333_14sp,
                            ),
                            TextSpan(
                              text: " ${info.nickname}",
                              style: Styles.ts_9280B3_14sp,
                            )
                          ]))
                        ],
                      )
                    // 提到了你
                    : info.type == 2
                        ? (sprintf(StrLibrary.mentionedWho,
                            [info.atUsers?.firstOrNull?.nickname]).toText
                          ..style = Styles.ts_333333_14sp)
                        // 评论了你
                        : (null == replyNickname || replyNickname.isEmpty)
                            ? RichText(
                                text: TextSpan(children: [
                                TextSpan(
                                  text: StrLibrary.commentedWho2,
                                  style: Styles.ts_333333_14sp,
                                ),
                                TextSpan(
                                  text: " ${info.nickname}：",
                                  style: Styles.ts_9280B3_14sp,
                                ),
                                TextSpan(
                                  text: content,
                                  style: Styles.ts_333333_14sp,
                                ),
                              ]))
                            // 某某回复了某某
                            : RichText(
                                text: TextSpan(children: [
                                  // 回复：xxx ： 内容
                                  TextSpan(
                                    text: StrLibrary.replied,
                                    style: Styles.ts_333333_14sp,
                                  ),
                                  TextSpan(
                                    text: ' $replyNickname：',
                                    style: Styles.ts_9280B3_14sp,
                                  ),
                                  TextSpan(
                                    text: content,
                                    style: Styles.ts_333333_14sp,
                                  ),
                                ]),
                              ),
                2.verticalSpace,
                TimelineUtil.format(
                  (info.createTime ?? 0),
                  dayFormat: DayFormat.Full,
                  locale: Get.locale?.languageCode ?? 'zh',
                ).toText
                  ..style = Styles.ts_999999_12sp,
              ],
            ),
          ),
          _buildMateView(info),
        ],
      ),
    );
  }

  Widget _buildMateView(WorkMoments info) {
    final mateContent = info.content;
    if (null == mateContent ||
        mateContent.metas == null ||
        mateContent.metas!.isEmpty) {
      return const SizedBox();
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          ImageUtil.networkImage(
            url: mateContent.metas!.first.thumb!,
            width: 60.w,
            height: 60.h,
            fit: BoxFit.cover,
          ),
          if (mateContent.type == 1)
            ImageRes.videoPause.toImage
              ..width = 20.w
              ..height = 20.h,
        ],
      );
    }
  }
}
