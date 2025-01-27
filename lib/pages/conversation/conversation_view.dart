import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti/pages/contacts/contacts_view.dart';
import 'package:miti/pages/home/home_logic.dart';
import 'package:miti/utils/ai_util.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sprintf/sprintf.dart';

import 'conversation_logic.dart';

class ConversationPage extends StatelessWidget {
  final logic = Get.find<ConversationLogic>();
  final im = Get.find<IMCtrl>();
  final homeLogic = Get.find<HomeLogic>();
  final aiUtil = Get.find<AiUtil>();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Obx(() => IndexedStack(
          index: logic.tabIndex.value,
          children: [
            Scaffold(
                appBar: TitleBar.conversation(
                    popCtrl: logic.popCtrl,
                    onScan: logic.scan,
                    onAddFriend: logic.addFriend,
                    onAddGroup: logic.addGroup,
                    onCreateGroup: logic.createGroup,
                    onClickSearch: logic.globalSearch,
                    onSwitchTab: logic.switchTab,
                    tabIndex: logic.tabIndex,
                    mq: mq,
                    unhandledCount: homeLogic.unhandledFriendAndGroupCount,
                    // left: PopButton(
                    //   popCtrl: logic.serverPopCtrl,
                    //   cusMenus: List.generate(
                    //     logic.loginInfoList.length,
                    //     (i) => CusPopMenuInfo(
                    //         child: _buildCusPopMenuInfo(
                    //             info: logic.loginInfoList[i],
                    //             showBorder: i != logic.loginInfoList.length - 1),
                    //         onTap: () =>
                    //             logic.switchAccount(logic.loginInfoList[i])),
                    //   ),
                    //   child: Stack(
                    //     clipBehavior: Clip.none,
                    //     children: [
                    //       AvatarView(
                    //         width: 40.w,
                    //         height: 40.h,
                    //         text: im.userInfo.value.nickname,
                    //         url: im.userInfo.value.faceURL,
                    //         // onTap: () => switchHomeTab(2)
                    //       ),
                    //       Positioned(
                    //           bottom: 0,
                    //           right: -4.w,
                    //           child: ImageLibrary.appSwitch.toImage
                    //             ..width = 18.w
                    //             ..height = 18.h)
                    //     ],
                    //   ),
                    // ),
                    left: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: logic.myQrcode,
                      child: AvatarView(
                        width: 40.w,
                        height: 40.h,
                        text: im.userInfo.value.nickname,
                        url: im.userInfo.value.faceURL,
                        // onTap: () => switchHomeTab(2)
                      ),
                    )),
                backgroundColor: StylesLibrary.c_FFFFFF,
                body: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 1.sh - 56.h),
                    child: Container(
                      color: StylesLibrary.c_F7F8FA,
                      child: Column(
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
                                  onRefresh: () =>
                                      logic.loadConversationList(true),
                                  onLoading: logic.loadConversationList,
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
                                    height: 183.h - 105.h - mq.padding.top,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                      image: AssetImage(
                                          ImageLibrary.appHeaderBg3,
                                          package: 'miti_common'),
                                      fit: BoxFit.cover,
                                      alignment: FractionalOffset.bottomCenter,
                                    )),
                                  )),
                            ],
                          )),
                        ],
                      ),
                    ))),
            ContactsPage()
          ],
        ));
  }

  Widget _buildConversationItemView(ConversationInfo info) => Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: logic.existUnreadMsg(info)
              ? 0.7
              : (logic.isPinned(info) ? 0.6 : 0.5),
          children: [
            CustomSlidableAction(
              onPressed: (_) => logic.pinConversation(info),
              flex: logic.isPinned(info) ? 3 : 2,
              backgroundColor: StylesLibrary.c_8443F8,
              child:
                  (logic.isPinned(info) ? StrLibrary.cancelTop : StrLibrary.top)
                      .toText
                    ..style = StylesLibrary.ts_FFFFFF_16sp,
            ),
            if (logic.existUnreadMsg(info))
              CustomSlidableAction(
                onPressed: (_) => logic.markMessageHasRead(info),
                flex: 3,
                backgroundColor: StylesLibrary.c_999999,
                child: StrLibrary.markHasRead.toText
                  ..style = StylesLibrary.ts_FFFFFF_16sp,
              ),
            CustomSlidableAction(
              onPressed: (_) => logic.deleteConversation(info),
              flex: 2,
              backgroundColor: StylesLibrary.c_FF4E4C,
              child: StrLibrary.delete.toText
                ..style = StylesLibrary.ts_FFFFFF_16sp,
            ),
          ],
        ),
        child: _buildItemView(info),
      ));

  Widget _buildItemView(ConversationInfo info) => Obx(() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => logic.toChat(conversationInfo: info),
        child: Container(
          padding: EdgeInsets.only(left: 12.w),
          child: Stack(
            children: [
              Container(
                height: 68.h,
                padding: EdgeInsets.only(left: 10.w, right: 12.w),
                decoration: BoxDecoration(
                    color: StylesLibrary.c_FFFFFF,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(34.r),
                        bottomLeft: Radius.circular(34.r))),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AvatarView(
                          width: 54.w,
                          height: 54.h,
                          text: logic.getShowName(info),
                          url: info.faceURL,
                          isGroup: logic.isGroupChat(info),
                        ),
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
                                ..style = StylesLibrary.ts_332221_16sp
                                ..maxLines = 1
                                ..overflow = TextOverflow.ellipsis,
                            ),
                            if (aiUtil.isAi(info.userID)) ...[
                              9.horizontalSpace,
                              ImageLibrary.appAiMarker.toImage
                                ..width = 18.w
                                ..height = 16.h,
                            ],
                            const Spacer(),
                            logic.getTime(info).toText
                              ..style = StylesLibrary.ts_999999_12sp,
                          ],
                        ),
                        5.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: MatchTextView(
                                text: logic.getContent(info),
                                textStyle: StylesLibrary.ts_999999_14sp,
                                allAtMap: logic.getAtUserMap(info),
                                prefixSpan: TextSpan(
                                  text: '',
                                  children: [
                                    if (logic.isNotDisturb(info) &&
                                        logic.getUnreadCount(info) > 0)
                                      TextSpan(
                                        text: '[${sprintf(StrLibrary.nPieces, [
                                              logic.getUnreadCount(info)
                                            ])}] ',
                                        style: StylesLibrary.ts_999999_14sp,
                                      ),
                                    TextSpan(
                                      text: logic.getPrefixTag(info),
                                      style: StylesLibrary.ts_8443F8_14sp,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                patterns: <MatchPattern>[
                                  MatchPattern(
                                    type: PatternType.at,
                                    style: StylesLibrary.ts_999999_14sp,
                                  ),
                                ],
                              ),
                            ),
                            10.horizontalSpace,
                            if (logic.isNotDisturb(info))
                              ImageLibrary.notDisturb.toImage
                                ..width = 13.63.w
                                ..height = 14.07.h,
                            UnreadCountView(
                              count: logic.getUnreadCount(info),
                              size: 18,
                            )
                            // else
                            //   UnreadCountView(
                            //       count: logic.getUnreadCount(info)),
                          ],
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              if (logic.isPinned(info))
                Container(
                  height: 68.h,
                  margin: EdgeInsets.only(right: 6.w),
                  foregroundDecoration: RotatedCornerDecoration.withColor(
                    color: StylesLibrary.c_8443F8,
                    badgeSize: Size(8.29.w, 8.29.h),
                  ),
                )
            ],
          ),
        ),
      ));

  Widget _buildCusPopMenuInfo(
          {required AccountLoginInfo info, showBorder = true}) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Container(
          width: 243.h,
          height: 62.h,
          decoration: BoxDecoration(
            border: showBorder
                ? BorderDirectional(
                    bottom:
                        BorderSide(color: StylesLibrary.c_F1F2F6, width: 1.h),
                  )
                : null,
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AvatarView(
                    width: 40.w,
                    height: 40.h,
                    text: info.nickname,
                    url: info.faceURL,
                  ),
                  if (logic.curLoginInfoKey == info.id)
                    Positioned(
                        bottom: 0,
                        right: -4.w,
                        child: ImageLibrary.appChecked2.toImage
                          ..width = 18.w
                          ..height = 18.h)
                ],
              ),
              8.horizontalSpace,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    info.nickname.toText
                      ..style = StylesLibrary.ts_333333_16sp
                      ..maxLines = 1
                      ..overflow = TextOverflow.ellipsis,
                    info.server.toText
                      ..style = StylesLibrary.ts_999999_14sp
                      ..maxLines = 1
                      ..overflow = TextOverflow.ellipsis,
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
