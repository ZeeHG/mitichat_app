import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';
import 'group_setup_logic.dart';

class GroupSetupPage extends StatelessWidget {
  final logic = Get.find<GroupSetupLogic>();

  GroupSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(title: logic.appBarTitle),
          backgroundColor: Styles.c_F7F8FA,
          body: Obx(() => SingleChildScrollView(
                child: Column(
                  children: [
                    if (logic.isJoinedGroup.value) _buildBaseInfoView(),
                    if (logic.isJoinedGroup.value) _buildMemberView(),
                    10.verticalSpace,
                    // _buildContentSearchView(),
                    // 群聊名称
                    _buildItemView(
                      text: StrRes.groupName,
                      value: logic.groupInfo.value.groupName,
                      showRightArrow: true,
                      isTopRadius: true,
                      isBottomRadius: !logic.isOwner,
                      onTap:
                          logic.isOwnerOrAdmin ? logic.modifyGroupName : null,
                    ),
                    // 群二维码
                    _buildItemView(
                      text: StrRes.groupQrcode,
                      showRightArrow: true,
                      isTopRadius: true,
                      isBottomRadius: !logic.isOwner,
                      onTap: logic.viewGroupQrcode,
                    ),
                    _buildItemView(
                      text: StrRes.groupAc,
                      showRightArrow: true,
                      isTopRadius: true,
                      isBottomRadius: !logic.isOwner,
                      onTap: logic.editGroupAnnouncement,
                    ),
                    if (logic.isOwner)
                      _buildItemView(
                        text: StrRes.groupManage,
                        showRightArrow: true,
                        isBottomRadius: true,
                        onTap: logic.groupManage,
                      ),
                    // 备注
                    // _buildItemView(
                    //   text: StrRes.remark,
                    //   showRightArrow: true,
                    //   isBottomRadius: true,
                    //   onTap: () => showDeveloping(),
                    // ),
                    10.verticalSpace,
                    // 查找聊天内容
                    _buildItemView(
                      text: StrRes.groupSearch,
                      showRightArrow: true,
                      isBottomRadius: true,
                      onTap: logic.searchChatHistory,
                    ),
                    10.verticalSpace,
                    _buildItemView(
                      text: StrRes.messageNotDisturb,
                      switchOn: logic.isNotDisturb,
                      showSwitchButton: true,
                      isBottomRadius: true,
                      onChanged: (_) => logic.toggleNotDisturb(),
                    ),
                    _buildItemView(
                      text: StrRes.topChat,
                      switchOn: logic.isPinned,
                      showSwitchButton: true,
                      isTopRadius: true,
                      onChanged: (_) => logic.toggleTopChat(),
                    ),
                    // 保存到通讯录
                    // _buildItemView(
                    //   text: StrRes.saveToContact,
                    //   switchOn: false,
                    //   showSwitchButton: true,
                    //   isTopRadius: true,
                    //   onChanged: (_) => showDeveloping(),
                    // ),
                    // 聊天加密
                    _buildItemView(
                      text: StrRes.chatEncryption,
                      switchOn: true,
                      showSwitchButton: true,
                      isTopRadius: true,
                      // onChanged: (_) => showDeveloping(),
                    ),
                    // _buildItemView(
                    //   text: StrRes.autoTranslate,
                    //   switchOn: logic.isAutoTranslate,
                    //   onChanged: (_) => logic.toggleAutoTranslate(),
                    //   showSwitchButton: true,
                    //   isTopRadius: true,
                    //   isBottomRadius: logic.isAutoTranslate ? false : true,
                    // ),
                    // _buildItemView(
                    //     text: StrRes.targetLang,
                    //     value: logic.targetLangStr,
                    //     onTap: logic.setTargetLang,
                    //     showRightArrow: true,
                    //     isBottomRadius: true,
                    //   ),
                    10.verticalSpace,
                    _buildItemView(
                      text: StrRes.myGroupMemberNickname,
                      value: logic.myGroupMembersInfo.value.nickname,
                      showRightArrow: true,
                      isTopRadius: true,
                      isBottomRadius: true,
                      onTap: logic.modifyMyGroupNickname,
                    ),
                    // 显示群成员昵称
                    // _buildItemView(
                    //   text: StrRes.showGroupMemberNickname,
                    //   switchOn: false,
                    //   showSwitchButton: true,
                    //   isTopRadius: true,
                    //   onTap: () => showDeveloping(),
                    // ),
                    10.verticalSpace,
                    // 设置当前聊天背景
                    // _buildItemView(
                    //   text: StrRes.setChatBackground,
                    //   showRightArrow: true,
                    //   isTopRadius: true,
                    //   isBottomRadius: true,
                    //   onTap: () => showDeveloping(),
                    // ),
                    // _buildItemView(
                    //   text: StrRes.periodicallyDeleteMessage,
                    //   switchOn: logic.isMsgDestruct,
                    //   onChanged: (_) => logic.toggleDestructMessage(),
                    //   showSwitchButton: true,
                    //   isTopRadius: true,
                    //   isBottomRadius: logic.isMsgDestruct ? false : true,
                    // ),
                    // if (logic.isMsgDestruct)
                    //   _buildItemView(
                    //     text: StrRes.timeSet,
                    //     value: logic.getDestructDurationStr,
                    //     onTap: logic.setDestructMessageDuration,
                    //     showRightArrow: true,
                    //     isBottomRadius: true,
                    //   ),
                    // 10.verticalSpace,
                    // 清空聊天
                    _buildItemView(
                      text: StrRes.clearChatHistory,
                      showRightArrow: true,
                      isTopRadius: true,
                      isBottomRadius: true,
                      onTap: logic.clearChatHistory,
                    ),
                    // 10.verticalSpace,
                    // 投诉
                    // _buildItemView(
                    //   text: StrRes.complaint,
                    //   showRightArrow: true,
                    //   isTopRadius: true,
                    //   isBottomRadius: true,
                    //   onTap: () => showDeveloping(),
                    // ),
                    10.verticalSpace,
                    if (!logic.isOwner)
                      Button(
                        text: logic.isJoinedGroup.value
                            ? StrRes.exitGroup
                            : StrRes.delete,
                        textStyle: Styles.ts_FC4D4D_16sp,
                        radius: 0,
                        enabledColor: Styles.c_FFFFFF,
                        onTap: logic.quitGroup,
                      ),
                    if (logic.isOwner)
                      Button(
                        text: StrRes.dismissGroup,
                        textStyle: Styles.ts_FC4D4D_16sp,
                        radius: 0,
                        enabledColor: Styles.c_FFFFFF,
                        onTap: logic.quitGroup,
                      ),
                    40.verticalSpace,
                  ],
                ),
              )),
        ));
  }

  Widget _buildBaseInfoView() => Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 50.h,
              height: 50.h,
              child: Stack(
                children: [
                  AvatarView(
                    width: 42.w,
                    height: 42.h,
                    url: logic.groupInfo.value.faceURL,
                    text: logic.groupInfo.value.groupName,
                    textStyle: Styles.ts_FFFFFF_14sp,
                    isGroup: true,
                    onTap:
                        logic.isOwnerOrAdmin ? logic.modifyGroupAvatar : null,
                  ),
                  if (logic.isOwnerOrAdmin)
                    Align(
                        alignment: Alignment.bottomRight,
                        child: ImageRes.editAvatar.toImage
                          ..width = 14.w
                          ..height = 14.h)
                ],
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: logic.isOwnerOrAdmin ? logic.modifyGroupName : null,
                    child: Row(
                      children: [
                        ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 200.w),
                            child:
                                (logic.groupInfo.value.groupName ?? '').toText
                                  ..style = Styles.ts_333333_16sp),
                        '(${logic.groupInfo.value.memberCount ?? 0})'.toText
                          ..style = Styles.ts_333333_16sp,
                        6.horizontalSpace,
                        if (logic.isOwnerOrAdmin)
                          ImageRes.editName.toImage
                            ..width = 12.w
                            ..height = 12.h,
                      ],
                    ),
                  ),
                  4.verticalSpace,
                  logic.groupInfo.value.groupID.toText
                    ..style = Styles.ts_999999_14sp
                    ..onTap = logic.copyGroupID,
                ],
              ),
            ),
            ImageRes.mineQr.toImage
              ..width = 18.w
              ..height = 18.h
              ..onTap = logic.viewGroupQrcode,
          ],
        ),
      );

  Widget _buildMemberView() => Container(
        padding: EdgeInsets.only(left: 20.w),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
        ),
        child: Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: logic.length(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 5.h,
                childAspectRatio: 42.w / 64.h,
              ),
              itemBuilder: (BuildContext context, int index) {
                return logic.itemBuilder(
                  index: index,
                  builder: (info) => Column(
                    children: [
                      SizedBox(
                        width: 42.w,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AvatarView(
                              width: 42.w,
                              height: 42.h,
                              url: info.faceURL,
                              text: info.nickname,
                              textStyle: Styles.ts_FFFFFF_14sp,
                              onTap: () => logic.viewMemberInfo(info),
                            ),
                            if (logic.groupInfo.value.ownerUserID ==
                                info.userID)
                              // if (info.roleLevel == GroupRoleLevel.owner)
                              Positioned(
                                bottom: 0.h,
                                child: Container(
                                  width: 52.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Styles.c_E8EAEF,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: StrRes.groupOwner.toText
                                    ..style = Styles.ts_999999_10sp
                                    ..maxLines = 1
                                    ..overflow = TextOverflow.ellipsis,
                                ),
                              )
                          ],
                        ),
                      ),
                      2.verticalSpace,
                      (info.nickname ?? '').toText
                        ..style = Styles.ts_999999_10sp
                        ..maxLines = 1
                        ..overflow = TextOverflow.ellipsis,
                    ],
                  ),
                  addButton: () => GestureDetector(
                    onTap: logic.addMember,
                    child: Column(
                      children: [
                        ImageRes.addMember.toImage
                          ..width = 42.w
                          ..height = 42.h,
                        2.verticalSpace,
                        StrRes.addMember.toText..style = Styles.ts_999999_10sp,
                      ],
                    ),
                  ),
                  delButton: () => GestureDetector(
                    onTap: logic.removeMember,
                    child: Column(
                      children: [
                        ImageRes.delMember.toImage
                          ..width = 42.w
                          ..height = 42.h,
                        2.verticalSpace,
                        StrRes.delMember.toText..style = Styles.ts_999999_10sp,
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              color: Styles.c_F1F2F6,
              height: 1.h,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: logic.viewGroupMembers,
              child: Container(
                padding: EdgeInsets.only(right: 20.w),
                height: 50.h,
                child: Row(
                  children: [
                    sprintf(StrRes.viewAllGroupMembers,
                        [logic.groupInfo.value.memberCount]).toText
                      ..style = Styles.ts_333333_16sp,
                    const Spacer(),
                    ImageRes.appRightArrow.toImage
                      ..width = 24.w
                      ..height = 24.h,
                  ],
                ),
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
              text.toText..style = Styles.ts_999999_14sp
            ],
          ),
        );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StrRes.chatContent.toText..style = Styles.ts_999999_14sp,
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
          color: Styles.c_FFFFFF,
          child: Container(
            height: 46.h,
            margin: EdgeInsets.only(left: 20.w),
            padding: EdgeInsets.only(right: 20.w),
            decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: Styles.c_F1F2F6, width: 1.h))
                // borderRadius: BorderRadius.only(
                //   topRight: Radius.circular(isTopRadius ? 6.r : 0),
                //   topLeft: Radius.circular(isTopRadius ? 6.r : 0),
                //   bottomLeft: Radius.circular(isBottomRadius ? 6.r : 0),
                //   bottomRight: Radius.circular(isBottomRadius ? 6.r : 0),
                // ),
                ),
            child: Row(
              children: [
                Expanded(
                    child: text.toText
                      ..style = textStyle ?? Styles.ts_333333_16sp
                      ..maxLines = 1),
                if (null != value)
                  value.toText
                    ..style = Styles.ts_999999_14sp
                    ..maxLines = 1
                    ..overflow = TextOverflow.ellipsis,
                if (showSwitchButton)
                  CupertinoSwitch(
                    value: switchOn,
                    activeColor: Styles.c_07C160,
                    onChanged: onChanged,
                  ),
                if (showRightArrow)
                  ImageRes.appRightArrow.toImage
                    ..width = 24.w
                    ..height = 24.h,
              ],
            ),
          ),
        ),
      );
}
