import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';
import 'group_setup_logic.dart';

class GroupSetupPage extends StatelessWidget {
  final logic = Get.find<GroupSetupLogic>();

  GroupSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
              title: logic.appBarTitle, backgroundColor: Styles.transparent),
          backgroundColor: Styles.c_F7F8FA,
          body: Obx(() => SingleChildScrollView(
                child: Column(
                  children: [
                    if (logic.isJoinedGroup.value) _baseInfoView(),
                    if (logic.isJoinedGroup.value) _memberView(),
                    15.verticalSpace,
                    // _buildContentSearchView(),
                    // 群聊名称
                    _itemView(
                      text: StrLibrary.groupName,
                      value: logic.groupInfo.value.groupName,
                      showRightArrow: true,
                      isTopRadius: true,
                      onTap:
                          logic.isOwnerOrAdmin ? logic.modifyGroupName : null,
                    ),
                    // 群二维码
                    _itemView(
                      text: StrLibrary.groupQrcode,
                      showRightArrow: true,
                      showBorder: true,
                      onTap: logic.viewGroupQrcode,
                    ),
                    _itemView(
                      text: StrLibrary.groupAc,
                      showRightArrow: true,
                      showBorder: true,
                      isBottomRadius: !logic.isOwner,
                      onTap: logic.editGroupAnnouncement,
                    ),
                    if (logic.isOwner)
                      _itemView(
                        text: StrLibrary.groupManage,
                        showRightArrow: true,
                        showBorder: true,
                        isBottomRadius: true,
                        onTap: logic.groupManage,
                      ),
                    15.verticalSpace,
                    // 查找聊天内容
                    _itemView(
                      text: StrLibrary.groupSearch,
                      showRightArrow: true,
                      isTopRadius: true,
                      isBottomRadius: true,
                      onTap: logic.chatHistory,
                    ),
                    15.verticalSpace,
                    _itemView(
                      text: StrLibrary.messageNotDisturb,
                      switchOn: logic.isNotDisturb,
                      showSwitchButton: true,
                      isTopRadius: true,
                      onChanged: (_) => logic.toggleNotDisturb(),
                    ),
                    _itemView(
                      text: StrLibrary.topChat,
                      switchOn: logic.isPinned,
                      showSwitchButton: true,
                      showBorder: true,
                      onChanged: (_) => logic.toggleTopChat(),
                    ),
                    // 聊天加密
                    _itemView(
                        text: StrLibrary.chatEncryption,
                        switchOn: true,
                        showBorder: true,
                        showSwitchButton: true,
                        isBottomRadius: true
                        // onChanged: (_) => showDeveloping(),
                        ),
                    15.verticalSpace,
                    _itemView(
                      text: StrLibrary.myGroupMemberNickname,
                      value: logic.myGroupMembersInfo.value.nickname,
                      showRightArrow: true,
                      isTopRadius: true,
                      isBottomRadius: true,
                      onTap: logic.modifyMyGroupNickname,
                    ),
                    15.verticalSpace,
                    _itemView(
                      text: StrLibrary.clearChatHistory,
                      showRightArrow: true,
                      isTopRadius: true,
                      isBottomRadius: true,
                      onTap: logic.clearChatHistory,
                    ),
                    15.verticalSpace,
                    if (!logic.isOwner)
                      Button(
                        width: 1.sw - 30.w,
                        height: 52.h,
                        text: logic.isJoinedGroup.value
                            ? StrLibrary.exitGroup
                            : StrLibrary.delete,
                        textStyle: Styles.ts_FC4D4D_16sp,
                        radius: 10.r,
                        enabledColor: Styles.c_FFFFFF,
                        onTap: logic.quitGroup,
                      ),
                    if (logic.isOwner)
                      Button(
                        width: 1.sw - 30.w,
                        height: 52.h,
                        text: StrLibrary.dismissGroup,
                        textStyle: Styles.ts_FC4D4D_16sp,
                        radius: 10.r,
                        enabledColor: Styles.c_FFFFFF,
                        onTap: logic.quitGroup,
                      ),
                    40.verticalSpace,
                  ],
                ),
              )),
        ));
  }

  Widget _baseInfoView() => Container(
        height: 80.h,
        margin: EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
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

  Widget _memberView() => Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        padding: EdgeInsets.only(left: 20.w),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.r),
            bottomRight: Radius.circular(10.r),
          ),
        ),
        child: Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: logic.length(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 0,
                mainAxisSpacing: 2.h,
                childAspectRatio: 48.w / 48.h,
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
                              onTap: () => logic.viewMemberInfo(info),
                            ),
                            if (logic.groupInfo.value.ownerUserID ==
                                info.userID)
                              // if (info.roleLevel == GroupRoleLevel.owner)
                              Positioned(
                                bottom: 0.h,
                                child: Container(
                                  width: 52.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Styles.c_E8EAEF,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: StrLibrary.groupOwner.toText
                                    ..style = Styles.ts_999999_10sp
                                    ..maxLines = 1
                                    ..overflow = TextOverflow.ellipsis,
                                ),
                              )
                          ],
                        ),
                      ),
                      2.verticalSpace,
                      SizedBox(
                          width: 50.w,
                          child: (info.nickname ?? '').toText
                            ..style = Styles.ts_999999_10sp
                            ..textAlign = TextAlign.center
                            ..maxLines = 1
                            ..overflow = TextOverflow.ellipsis),
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
                        StrLibrary.addMember.toText
                          ..style = Styles.ts_999999_10sp,
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
                        StrLibrary.delMember.toText
                          ..style = Styles.ts_999999_10sp,
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
                height: 52.h,
                child: Row(
                  children: [
                    sprintf(StrLibrary.viewAllGroupMembers,
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

  Widget _itemView({
    required String text,
    TextStyle? textStyle,
    String? value,
    bool switchOn = false,
    bool isTopRadius = false,
    bool isBottomRadius = false,
    bool showRightArrow = false,
    bool showSwitchButton = false,
    bool showBorder = false,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(isTopRadius ? 10.r : 0),
              topLeft: Radius.circular(isTopRadius ? 10.r : 0),
              bottomLeft: Radius.circular(isBottomRadius ? 10.r : 0),
              bottomRight: Radius.circular(isBottomRadius ? 10.r : 0),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Styles.c_FFFFFF,
              border: showBorder
                  ? Border(top: BorderSide(color: Styles.c_F1F2F6, width: 1.h))
                  : null,
            ),
            height: 52.h,
            padding: EdgeInsets.only(right: 15.w),
            margin: EdgeInsets.only(left: 15.w),
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
