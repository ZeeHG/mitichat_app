import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';
import 'user_profile_logic.dart';

class UserProfilePage extends StatelessWidget {
  final logic = Get.find<UserProfileLogic>(tag: GetTags.userProfile);
  final appCommonLogic = Get.find<AppCommonLogic>();

  UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            right: logic.baseDataFinished.value && logic.isFriendship
                ? (ImageRes.appMoreBlack.toImage
                  ..width = 24.w
                  ..height = 24.h
                  ..onTap = logic.friendSetting)
                : null,
          ),
          backgroundColor: Styles.c_F7F8FA,
          body: !logic.baseDataFinished.value
              ? const SizedBox()
              : SizedBox(
                  height: 1.sh,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildBaseInfoView(),
                        // _buildOtherInfoView(),
                        if (logic.isGroupMemberPage)
                          _buildEnterGroupMethodView(),
                        if (logic.iAmOwner.value &&
                            logic.groupMembersInfo != null)
                          _buildItemView(
                            label: StrLibrary.setAsAdmin,
                            showSwitchButton: true,
                            switchOn: logic.hasAdminPermission.value,
                            onChanged: (_) => logic.toggleAdmin(),
                          ),
                        if (logic.iHasMutePermissions.value &&
                            logic.groupMembersInfo != null)
                          _buildItemView(
                            label: StrLibrary.setMute,
                            value:
                                MitiUtils.emptyStrToNull(logic.mutedTime.value),
                            onTap: logic.setMute,
                            showRightArrow: true,
                          ),
                        // DeptItemView.userProfilesPanel(
                        //   userID: logic.userInfo.value.userID,
                        // ),
                        if (logic.isFriendship ||
                            logic.isMyself ||
                            logic.isGroupMemberPage &&
                                !logic
                                    .notAllowLookGroupMemberProfiles.value) ...[
                          _buildItemView(
                            label: StrLibrary.remarkAndLabel,
                            showRightArrow: true,
                            onTap: logic.setFriendRemark,
                          ),
                          _buildItemView(
                            label: StrLibrary.friendPermissions,
                            showRightArrow: true,
                            onTap: () =>
                                AppNavigator.startFriendPermissionSetting(
                                    userID: logic.userInfo.value.userID!),
                          ),
                        ],
                        _buildItemView(
                            label: StrLibrary.workingCircle,
                            showRightArrow: true,
                            addMargin: true,
                            onTap: logic.viewDynamics,
                            height: logic.picMetas.length > 0 ? 75.h : 50.h,
                            customContent: Container(
                              margin: EdgeInsets.only(left: 23.w),
                              child: Wrap(
                                spacing: 6.w,
                                children: logic.picMetas
                                    .map((element) => ImageUtil.networkImage(
                                          url: element.thumb!,
                                          width: 46.w,
                                          height: 46.h,
                                          fit: BoxFit.cover,
                                        ))
                                    .toList(),
                              ),
                            )),
                        _buildItemView(
                          label: StrLibrary.moreInfo,
                          showRightArrow: true,
                          onTap: logic.viewPersonalInfo,
                        ),
                        if ((logic.isFriendship ||
                                logic.allowSendMsgNotFriend) &&
                            !logic.isMyself)
                          _buildButtonGroup(),
                      ],
                    ),
                  ),
                ),
        ));
  }

  Widget _buildBaseInfoView() => Container(
        color: Styles.c_FFFFFF,
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            AvatarView(
              url: logic.userInfo.value.faceURL,
              text: logic.userInfo.value.nickname,
              width: 52.w,
              height: 52.h,
              enabledPreview: true,
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: logic.getShowName().toText
                          ..style = Styles.ts_4B3230_18sp
                          ..maxLines = 1
                          ..overflow = TextOverflow.ellipsis,
                      ),
                      12.horizontalSpace,
                      if (null != logic.userInfo.value.gender)
                        logic.userInfo.value.gender == 1
                            ? (ImageRes.appMan.toImage
                              ..width = 21.w
                              ..height = 15.h)
                            : (ImageRes.appWoman.toImage
                              ..width = 21.w
                              ..height = 15.h)
                    ],
                  ),
                  if (!logic.isGroupMemberPage ||
                      logic.isGroupMemberPage &&
                          !logic.notAllowAddGroupMemberFriend.value) ...[
                    5.verticalSpace,
                    (logic.userInfo.value.userID ?? '').toText
                      ..style = Styles.ts_B3AAAA_14sp
                      ..onTap = logic.copyID
                  ]
                ],
              ),
            ),
            if (!logic.isMyself &&
                logic.isAllowAddFriend &&
                !logic.isFriendship &&
                (!logic.isGroupMemberPage ||
                    logic.isGroupMemberPage &&
                        !logic.notAllowAddGroupMemberFriend.value))
              Material(
                child: Ink(
                  decoration: BoxDecoration(
                    color: Styles.c_8443F8,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: InkWell(
                    onTap: logic.addFriend,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 4.h,
                      ),
                      child: Row(
                        children: [
                          StrLibrary.add.toText..style = Styles.ts_FFFFFF_14sp,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );

  Widget _buildOtherInfoView() => Container(
        color: Styles.c_FFFFFF,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Row(
          children: [
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: showDeveloping,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: Styles.c_F7F7F7,
                        ),
                        width: 40.w,
                        height: 40.h,
                        alignment: Alignment.center,
                        child: ImageRes.appProductView.toImage
                          ..width = 20.w
                          ..height = 22.h,
                      ),
                      10.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StrLibrary.productView,
                            style: Styles.ts_333333_14sp,
                          ),
                          4.verticalSpace,
                          Text(
                            sprintf(StrLibrary.countOfProduct, ["7"]),
                            style: Styles.ts_B3AAAA_12sp,
                          ),
                        ],
                      )
                    ])),
            12.horizontalSpace,
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: showDeveloping,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        color: Styles.c_F7F7F7,
                      ),
                      width: 40.w,
                      height: 40.h,
                      alignment: Alignment.center,
                      child: ImageRes.appFanGroup.toImage
                        ..width = 19.w
                        ..height = 19.h,
                    ),
                    10.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StrLibrary.fanGroup,
                          style: Styles.ts_333333_14sp,
                        ),
                        4.verticalSpace,
                        Text(
                          sprintf(StrLibrary.countOfFanGroup, ["3"]),
                          style: Styles.ts_B3AAAA_12sp,
                        ),
                      ],
                    )
                  ]),
            ),
          ],
        ),
      );

  Widget _buildEnterGroupMethodView() {
    if (logic.joinGroupTime.value == 0 && logic.joinGroupMethod.value.isEmpty) {
      return Container();
    }
    return Container(
      color: Styles.c_FFFFFF,
      padding: EdgeInsets.only(left: 20.w),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.top,
        columnWidths: {0: FixedColumnWidth(100.w)},
        children: [
          if (logic.joinGroupTime.value > 0)
            _buildTabRowView(
              label: StrLibrary.joinGroupDate,
              value: DateUtil.formatDateMs(
                logic.joinGroupTime.value,
                format: appCommonLogic.isZh
                    ? DateFormats.zh_y_mo_d
                    : DateFormats.y_mo_d,
              ),
            ),
          if (logic.joinGroupMethod.value.isNotEmpty)
            _buildTabRowView(
              label: StrLibrary.joinGroupMethod,
              value: logic.joinGroupMethod.value,
            ),
        ],
      ),
    );
  }

  TableRow _buildTabRowView({
    required String label,
    String? value,
  }) =>
      TableRow(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Styles.c_F1F2F6, width: 1.h),
          ),
        ),
        children: [
          TableCell(
            child: Container(
              constraints: BoxConstraints(minHeight: 50.h),
              alignment: Alignment.centerLeft,
              child: label.toText..style = Styles.ts_333333_16sp,
            ),
          ),
          TableCell(
            child: Container(
              padding: EdgeInsets.only(right: 20.w),
              constraints: BoxConstraints(minHeight: 50.h),
              alignment: Alignment.centerRight,
              child: (value ?? '').toText..style = Styles.ts_999999_16sp,
            ),
          ),
        ],
      );

  Widget _buildItemView({
    required String label,
    String? value,
    bool addMargin = false,
    bool showSwitchButton = false,
    bool showRightArrow = false,
    bool switchOn = false,
    double? height,
    Widget? customContent,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      Container(
        margin: EdgeInsets.only(top: addMargin ? 12.h : 0),
        padding: EdgeInsets.only(left: 20.w),
        color: Styles.c_FFFFFF,
        child: Container(
            decoration: BoxDecoration(
              color: Styles.c_FFFFFF,
              border: Border(
                top: BorderSide(color: Styles.c_F1F2F6, width: 1.h),
              ),
            ),
            padding: EdgeInsets.only(right: 20.w),
            child: Ink(
              color: Styles.c_FFFFFF,
              height: height ?? 50.h,
              child: InkWell(
                onTap: onTap,
                child: Row(
                  children: [
                    label.toText..style = Styles.ts_333333_16sp,
                    if (null != customContent) customContent,
                    const Spacer(),
                    if (showSwitchButton)
                      CupertinoSwitch(
                        value: switchOn,
                        activeColor: Styles.c_07C160,
                        onChanged: onChanged,
                      ),
                    if (null != value)
                      value.toText..style = Styles.ts_999999_16sp,
                    if (showRightArrow)
                      ImageRes.appRightArrow.toImage
                        ..width = 24.w
                        ..height = 24.h,
                  ],
                ),
              ),
            )),
      );

  Widget _buildButtonGroup() => Container(
        margin: EdgeInsets.only(top: 12.h),
        child: Column(children: [
          ImageTextButton(
            onTap: logic.toChat,
            icon: ImageRes.appSendMessage,
            text: StrLibrary.sendMessage,
            textStyle: Styles.ts_9280B3_16sp_medium,
            color: Styles.c_FFFFFF,
            height: 50.h,
            iconHeight: 13.h,
            iconWidth: 21.w,
            radius: 0,
          ),
          Divider(
            height: 1.h,
            color: Styles.c_F1F2F6,
          ),
          ImageTextButton(
            onTap: logic.toCall,
            icon: ImageRes.appAudioAndVideoCall,
            text: StrLibrary.audioAndVideoCall,
            textStyle: Styles.ts_9280B3_16sp_medium,
            color: Styles.c_FFFFFF,
            height: 50.h,
            iconHeight: 17.h,
            iconWidth: 17.w,
            radius: 0,
          ),
        ]),
      );
}
