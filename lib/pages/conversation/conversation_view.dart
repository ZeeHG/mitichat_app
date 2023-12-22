import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:openim/core/controller/im_controller.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sprintf/sprintf.dart';

import 'conversation_logic.dart';

class ConversationPage extends StatelessWidget {
  final logic = Get.find<ConversationLogic>();
  final im = Get.find<IMController>();

  ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Styles.c_F8F9FA,
          appBar: TitleBar.conversation(
              statusStr: logic.imSdkStatus,
              isFailed: logic.isFailedSdkStatus,
              popCtrl: logic.popCtrl,
              onClickCallBtn: logic.viewCallRecords,
              onScan: logic.scan,
              onAddFriend: logic.addFriend,
              onAddGroup: logic.addGroup,
              onCreateGroup: logic.createGroup,
              onVideoMeeting: logic.videoMeeting,
              left: Expanded(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AvatarView(
                      width: 42.w,
                      height: 42.h,
                      text: im.userInfo.value.nickname,
                      url: im.userInfo.value.faceURL,
                    ),
                    10.horizontalSpace,
                    if (null != im.userInfo.value.nickname)
                      Flexible(
                        child: im.userInfo.value.nickname!.toText
                          ..style = Styles.ts_0C1C33_17sp
                          ..maxLines = 1
                          ..overflow = TextOverflow.ellipsis,
                      ),
                    10.horizontalSpace,
                    if (null != logic.imSdkStatus)
                      Flexible(
                          child: SyncStatusView(
                        isFailed: logic.isFailedSdkStatus,
                        statusStr: logic.imSdkStatus!,
                      )),
                  ],
                ),
              )),
          // backgroundColor: Styles.c_FFFFFF,
          body: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: logic.globalSearch,
                child: SearchBox(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                ),
              ),
              Expanded(
                child: SlidableAutoCloseBehavior(
                  child: SmartRefresher(
                    controller: logic.refreshController,
                    header: IMViews.buildHeader(),
                    footer: IMViews.buildFooter(),
                    enablePullUp: true,
                    enablePullDown: true,
                    onRefresh: logic.onRefresh,
                    onLoading: logic.onLoading,
                    child: ListView.builder(
                      itemCount: logic.list.length,
                      controller: logic.scrollController,
                      itemBuilder: (_, index) => AutoScrollTag(
                        key: ValueKey(index),
                        controller: logic.scrollController,
                        index: index,
                        child: _buildConversationItemView(
                          logic.list.elementAt(index),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildConversationItemView(ConversationInfo info) => Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: logic.existUnreadMsg(info) ? 0.7 : (logic.isPinned(info) ? 0.5 : 0.4),
          children: [
            CustomSlidableAction(
              onPressed: (_) => logic.pinConversation(info),
              flex: logic.isPinned(info) ? 3 : 2,
              backgroundColor: Styles.c_0089FF,
              child: (logic.isPinned(info) ? StrRes.cancelTop : StrRes.top).toText..style = Styles.ts_FFFFFF_16sp,
            ),
            if (logic.existUnreadMsg(info))
              CustomSlidableAction(
                onPressed: (_) => logic.markMessageHasRead(info),
                flex: 3,
                backgroundColor: Styles.c_8E9AB0,
                child: StrRes.markHasRead.toText..style = Styles.ts_FFFFFF_16sp,
              ),
            CustomSlidableAction(
              onPressed: (_) => logic.deleteConversation(info),
              flex: 2,
              backgroundColor: Styles.c_FF381F,
              child: StrRes.delete.toText..style = Styles.ts_FFFFFF_16sp,
            ),
          ],
        ),
        child: _buildItemView(info),
      );

  Widget _buildItemView(ConversationInfo info) => Ink(
        child: InkWell(
          onTap: () => logic.toChat(conversationInfo: info),
          child: Stack(
            children: [
              Container(
                height: 68.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        AvatarView(
                          width: 48.w,
                          height: 48.h,
                          text: logic.getShowName(info),
                          url: info.faceURL,
                          isGroup: logic.isGroupChat(info),
                          textStyle: Styles.ts_FFFFFF_14sp_medium,
                        ),
                        // if (logic.isNotDisturb(info) &&
                        //     logic.getUnreadCount(info) > 0)
                        //   Transform.translate(
                        //     offset: Offset(42.h, -2),
                        //     child: const RedDotView(),
                        //   ),
                      ],
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 180.w),
                                child: logic.getShowName(info).toText
                                  ..style = Styles.ts_0C1C33_17sp
                                  ..maxLines = 1
                                  ..overflow = TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              logic.getTime(info).toText..style = Styles.ts_8E9AB0_12sp,
                            ],
                          ),
                          3.verticalSpace,
                          Row(
                            children: [
                              MatchTextView(
                                text: logic.getContent(info),
                                textStyle: Styles.ts_8E9AB0_14sp,
                                allAtMap: logic.getAtUserMap(info),
                                prefixSpan: TextSpan(
                                  text: '',
                                  children: [
                                    if (logic.isNotDisturb(info) && logic.getUnreadCount(info) > 0)
                                      TextSpan(
                                        text: '[${sprintf(StrRes.nPieces, [logic.getUnreadCount(info)])}] ',
                                        style: Styles.ts_8E9AB0_14sp,
                                      ),
                                    TextSpan(
                                      text: logic.getPrefixTag(info),
                                      style: Styles.ts_0089FF_14sp,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                patterns: <MatchPattern>[
                                  MatchPattern(
                                    type: PatternType.at,
                                    style: Styles.ts_8E9AB0_14sp,
                                  ),
                                ],
                              ),
                              // logic.getMsgContent(info).toText
                              //   ..style = Styles.ts_8E9AB0_14sp,
                              const Spacer(),
                              if (logic.isNotDisturb(info))
                                ImageRes.notDisturb.toImage
                                  ..width = 13.63.w
                                  ..height = 14.07.h
                              else
                                UnreadCountView(count: logic.getUnreadCount(info)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (logic.isPinned(info))
                Container(
                  height: 68.h,
                  margin: EdgeInsets.only(right: 6.w),
                  foregroundDecoration: RotatedCornerDecoration.withColor(
                    color: Styles.c_0089FF,
                    badgeSize: Size(8.29.w, 8.29.h),
                  ),
                )
            ],
          ),
        ),
      );
}
