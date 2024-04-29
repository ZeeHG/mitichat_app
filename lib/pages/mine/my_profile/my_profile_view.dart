import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../../core/ctrl/im_ctrl.dart';
import 'my_profile_logic.dart';

class MyProfilePage extends StatelessWidget {
  final logic = Get.find<MyProfileLogic>();
  final imCtrl = Get.find<IMCtrl>();

  MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrLibrary.myInfo,
      ),
      backgroundColor: StylesLibrary.c_F7F8FA,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                12.verticalSpace,
                buildItemGroup(
                  children: [
                    buildItem(
                        label: StrLibrary.avatar,
                        isAvatar: true,
                        value: imCtrl.userInfo.value.nickname,
                        url: imCtrl.userInfo.value.faceURL,
                        onTap: logic.openPhotoSheet,
                        showBorder: false),
                  ],
                ),
                12.verticalSpace,
                buildItemGroup(
                  children: [
                    buildItem(
                        label: StrLibrary.mobile,
                        value: imCtrl.userInfo.value.phoneNumber,
                        showRightArrow: false,
                        showBorder: false),
                    buildItem(
                      label: StrLibrary.email,
                      value: imCtrl.userInfo.value.email,
                      showRightArrow: false,
                    ),
                  ],
                ),
                12.verticalSpace,
                buildItemGroup(
                  children: [
                    buildItem(
                        label: StrLibrary.name,
                        value: imCtrl.userInfo.value.nickname,
                        onTap: logic.editMyName,
                        showBorder: false),
                    buildItem(
                      label: StrLibrary.gender,
                      value: imCtrl.userInfo.value.isMale
                          ? StrLibrary.man
                          : StrLibrary.woman,
                      onTap: logic.selectGender,
                    ),
                    buildItem(
                      label: StrLibrary.birthDay,
                      value: DateUtil.formatDateMs(
                        imCtrl.userInfo.value.birth ?? 0,
                        format: MitiUtils.getTimeFormat1(),
                      ),
                      onTap: logic.openDatePicker,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget buildItemGroup({required List<Widget> children}) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        color: StylesLibrary.c_FFFFFF,
        child: Column(children: children),
      );

  Widget buildItem({
    required String label,
    String? value,
    String? url,
    bool isAvatar = false,
    bool showRightArrow = true,
    bool showBorder = true,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: showRightArrow ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: StylesLibrary.c_F1F2F6,
                width: showBorder ? 1.h : 0,
              ),
            ),
          ),
          height: 50.h,
          child: Row(
            children: [
              label.toText..style = StylesLibrary.ts_333333_14sp,
              const Spacer(),
              if (isAvatar)
                AvatarView(
                  width: 38.w,
                  height: 38.h,
                  url: url,
                  text: value,
                  isCircle: true,
                )
              else
                Expanded(
                    flex: 3,
                    child: (MitiUtils.emptyStrToNull(value) ?? '').toText
                      ..style = StylesLibrary.ts_999999_14sp
                      ..maxLines = 1
                      ..overflow = TextOverflow.ellipsis
                      ..textAlign = TextAlign.right),
              if (showRightArrow)
                ImageLibrary.appRightArrow.toImage
                  ..width = 20.w
                  ..height = 20.h,
            ],
          ),
        ),
      );
}
