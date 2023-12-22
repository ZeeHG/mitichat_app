import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'chat_setup_logic.dart';

class ChatSetupPage extends StatelessWidget {
  final logic = Get.find<ChatSetupLogic>();

  ChatSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(),
      backgroundColor: Styles.c_F8F9FA,
      body: SingleChildScrollView(
        child: Obx(() => Column(
              children: [
                _buildBaseInfoView(),
                _buildContentSearchView(),
                17.verticalSpace,
                _buildItemView(
                  text: StrRes.topContacts,
                  switchOn: logic.isPinned,
                  onChanged: (_) => logic.toggleTopContacts(),
                  showSwitchButton: true,
                  isTopRadius: true,
                ),
                _buildItemView(
                  text: StrRes.messageNotDisturb,
                  hintText: StrRes.messageNotDisturbHint,
                  switchOn: logic.isNotDisturb,
                  onChanged: (_) => logic.toggleNotDisturb(),
                  showSwitchButton: true,
                  isBottomRadius: true,
                ),
                10.verticalSpace,
                _buildItemView(
                  text: StrRes.burnAfterReading,
                  switchOn: logic.isBurnAfterReading,
                  onChanged: (_) => logic.toggleBurnAfterReading(),
                  showSwitchButton: true,
                  isTopRadius: true,
                  isBottomRadius: logic.isBurnAfterReading ? false : true,
                ),
                if (logic.isBurnAfterReading)
                  _buildItemView(
                    text: StrRes.timeSet,
                    value: logic.getBurnAfterReadingDurationStr,
                    onTap: logic.setBurnAfterReadingDuration,
                    showRightArrow: true,
                    isBottomRadius: true,
                  ),
                10.verticalSpace,
                _buildItemView(
                  text: StrRes.periodicallyDeleteMessage,
                  switchOn: logic.isMsgDestruct,
                  onChanged: (_) => logic.toggleDestructMessage(),
                  showSwitchButton: true,
                  isTopRadius: true,
                  isBottomRadius: logic.isMsgDestruct ? false : true,
                ),
                if (logic.isMsgDestruct)
                  _buildItemView(
                    text: StrRes.timeSet,
                    value: logic.getDestructDurationStr,
                    onTap: logic.setDestructMessageDuration,
                    showRightArrow: true,
                    isBottomRadius: true,
                  ),
                10.verticalSpace,
                _buildItemView(
                  text: StrRes.setChatBackground,
                  onTap: logic.setBackgroundImage,
                  showRightArrow: true,
                  isTopRadius: true,
                ),
                _buildItemView(
                  text: StrRes.fontSize,
                  onTap: logic.setFontSize,
                  showRightArrow: true,
                  isBottomRadius: true,
                ),
                10.verticalSpace,
                _buildItemView(
                  text: StrRes.clearChatHistory,
                  textStyle: Styles.ts_FF381F_17sp,
                  onTap: logic.clearChatHistory,
                  showRightArrow: true,
                  isTopRadius: true,
                  isBottomRadius: true,
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildBaseInfoView() => Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: logic.viewUserInfo,
              child: SizedBox(
                width: 60.w,
                child: Column(
                  children: [
                    AvatarView(
                      width: 44.w,
                      height: 44.h,
                      text: logic.conversationInfo.value.showName,
                      url: logic.conversationInfo.value.faceURL,
                    ),
                    8.verticalSpace,
                    (logic.conversationInfo.value.showName ?? '').toText
                      ..style = Styles.ts_8E9AB0_14sp
                      ..maxLines = 1
                      ..overflow = TextOverflow.ellipsis,
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 60.w,
              child: Column(
                children: [
                  ImageRes.addFriendTobeGroup.toImage
                    ..width = 44.w
                    ..height = 44.h
                    ..onTap = logic.createGroup,
                  8.verticalSpace,
                  ''.toText
                    ..style = Styles.ts_8E9AB0_14sp
                    ..maxLines = 1
                    ..overflow = TextOverflow.ellipsis,
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildContentSearchView() {
    Widget childItemView({
      required String icon,
      required String text,
      Function()? onTap,
    }) =>
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Column(
            children: [
              icon.toImage
                ..width = 28.w
                ..height = 28.h,
              4.verticalSpace,
              text.toText..style = Styles.ts_8E9AB0_14sp
            ],
          ),
        );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StrRes.chatContent.toText..style = Styles.ts_8E9AB0_14sp,
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              childItemView(
                icon: ImageRes.chatSearch,
                text: StrRes.search,
                onTap: logic.searchChatHistory,
              ),
              childItemView(
                icon: ImageRes.chatSearchPic,
                text: StrRes.picture,
                onTap: logic.searchChatHistoryPicture,
              ),
              childItemView(
                icon: ImageRes.chatSearchVideo,
                text: StrRes.video,
                onTap: logic.searchChatHistoryVideo,
              ),
              childItemView(
                icon: ImageRes.chatSearchFile,
                text: StrRes.file,
                onTap: logic.searchChatHistoryFile,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemView({
    required String text,
    String? hintText,
    TextStyle? textStyle,
    String? value,
    bool switchOn = false,
    bool isTopRadius = false,
    bool isBottomRadius = false,
    bool showRightArrow = false,
    bool showSwitchButton = false,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: hintText == null ? 46.h : 68.h,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(isTopRadius ? 6.r : 0),
              topLeft: Radius.circular(isTopRadius ? 6.r : 0),
              bottomLeft: Radius.circular(isBottomRadius ? 6.r : 0),
              bottomRight: Radius.circular(isBottomRadius ? 6.r : 0),
            ),
          ),
          child: Row(
            children: [
              null != hintText
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text.toText..style = textStyle ?? Styles.ts_0C1C33_17sp,
                        hintText.toText..style = Styles.ts_8E9AB0_14sp,
                      ],
                    )
                  : (text.toText..style = textStyle ?? Styles.ts_0C1C33_17sp),
              const Spacer(),
              if (null != value) value.toText..style = Styles.ts_8E9AB0_14sp,
              if (showSwitchButton)
                CupertinoSwitch(
                  value: switchOn,
                  activeColor: Styles.c_0089FF,
                  onChanged: onChanged,
                ),
              if (showRightArrow)
                ImageRes.rightArrow.toImage
                  ..width = 24.w
                  ..height = 24.h,
            ],
          ),
        ),
      );
}
