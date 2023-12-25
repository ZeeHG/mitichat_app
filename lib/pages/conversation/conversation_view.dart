import 'dart:io';
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
    final mq = MediaQuery.of(context);
    return Obx(() => Scaffold(
          appBar: TitleBar.conversation(
              popCtrl: logic.popCtrl,
              onScan: logic.scan,
              onAddFriend: logic.addFriend,
              onAddGroup: logic.addGroup,
              onCreateGroup: logic.createGroup,
              onVideoMeeting: logic.videoMeeting,
              onClickSearch: logic.globalSearch,
              mq: mq,
              left: Expanded(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AvatarView(
                      width: 40.w,
                      height: 40.h,
                      text: im.userInfo.value.nickname,
                      url: im.userInfo.value.faceURL,
                      onTap: logic.viewMyInfo,
                    ),
                    10.horizontalSpace,
                    if (null != im.userInfo.value.nickname)
                      Flexible(
                        child: im.userInfo.value.nickname!.toText
                          ..style = Styles.ts_4B3230_16sp
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
          backgroundColor: Styles.c_FFFFFF,
          body: Column(
            children: [
              Expanded(
                  child: Stack(
                children: [
                  SlidableAutoCloseBehavior(
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
                  IgnorePointer(
                      ignoring: true,
                      child: Container(
                        height: 215.h - 105.h - mq.padding.top,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(ImageRes.appHeaderBg2,
                              package: 'openim_common'),
                          fit: BoxFit.cover,
                          alignment: FractionalOffset.bottomCenter,
                        )),
                      )),
                  // Positioned(
                  //     bottom: 78,
                  //     right: 14,
                  //     child: ImageRes.appBot.toImage
                  //       ..width = 54.w
                  //       ..height = 54.h
                  //       ..onTap = () => {}),
                ],
              )),
            ],
          ),
        ));
  }

  Widget _buildConversationItemView(ConversationInfo info) => Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: logic.existUnreadMsg(info)
              ? 0.7
              : (logic.isPinned(info) ? 0.5 : 0.4),
          children: [
            CustomSlidableAction(
              onPressed: (_) => logic.pinConversation(info),
              flex: logic.isPinned(info) ? 3 : 2,
              backgroundColor: Styles.c_8443F8,
              child:
                  (logic.isPinned(info) ? StrRes.cancelTop : StrRes.top).toText
                    ..style = Styles.ts_FFFFFF_16sp,
            ),
            if (logic.existUnreadMsg(info))
              CustomSlidableAction(
                onPressed: (_) => logic.markMessageHasRead(info),
                flex: 3,
                backgroundColor: Styles.c_999999,
                child: StrRes.markHasRead.toText..style = Styles.ts_FFFFFF_16sp,
              ),
            CustomSlidableAction(
              onPressed: (_) => logic.deleteConversation(info),
              flex: 2,
              backgroundColor: Styles.c_FF4E4C,
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
                height: 70.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AvatarView(
                          width: 46.w,
                          height: 46.h,
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
                        Positioned(
                            right: -7.w,
                            top: -7.h,
                            child: UnreadCountView(
                              count: logic.getUnreadCount(info),
                              size: 20,
                            ))
                      ],
                    ),
                    12.horizontalSpace,
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Styles.c_F5F0F0,
                        width: 1.h,
                      ))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 180.w),
                                child: logic.getShowName(info).toText
                                  ..style = Styles.ts_333333_16sp
                                  ..maxLines = 1
                                  ..overflow = TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              logic.getTime(info).toText
                                ..style = Styles.ts_999999_12sp,
                            ],
                          ),
                          3.verticalSpace,
                          Row(
                            children: [
                              MatchTextView(
                                text: logic.getContent(info),
                                textStyle: Styles.ts_999999_14sp,
                                allAtMap: logic.getAtUserMap(info),
                                prefixSpan: TextSpan(
                                  text: '',
                                  children: [
                                    if (logic.isNotDisturb(info) &&
                                        logic.getUnreadCount(info) > 0)
                                      TextSpan(
                                        text: '[${sprintf(StrRes.nPieces, [
                                              logic.getUnreadCount(info)
                                            ])}] ',
                                        style: Styles.ts_999999_14sp,
                                      ),
                                    TextSpan(
                                      text: logic.getPrefixTag(info),
                                      style: Styles.ts_8443F8_14sp,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                patterns: <MatchPattern>[
                                  MatchPattern(
                                    type: PatternType.at,
                                    style: Styles.ts_999999_14sp,
                                  ),
                                ],
                              ),
                              // logic.getMsgContent(info).toText
                              //   ..style = Styles.ts_999999_14sp,
                              const Spacer(),
                              if (logic.isNotDisturb(info))
                                ImageRes.notDisturb.toImage
                                  ..width = 13.63.w
                                  ..height = 14.07.h
                              // else
                              //   UnreadCountView(
                              //       count: logic.getUnreadCount(info)),
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              if (logic.isPinned(info))
                Container(
                  height: 68.h,
                  margin: EdgeInsets.only(right: 6.w),
                  foregroundDecoration: RotatedCornerDecoration.withColor(
                    color: Styles.c_8443F8,
                    badgeSize: Size(8.29.w, 8.29.h),
                  ),
                )
            ],
          ),
        ),
      );
}
