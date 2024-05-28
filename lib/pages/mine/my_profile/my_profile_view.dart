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
                SettingItemGroup(
                  children: [
                    SettingItem(
                        label: StrLibrary.avatar,
                        valueAvatarUrl: imCtrl.userInfo.value.faceURL ?? "",
                        valueAvatarText: imCtrl.userInfo.value.showName,
                        onTap: logic.openPhotoSheet,
                        showBorder: false),
                  ],
                ),
                12.verticalSpace,
                SettingItemGroup(
                  children: [
                    SettingItem(
                        label: StrLibrary.mitiID,
                        value: imCtrl.userInfo.value.mitiID,
                        showRightArrow: true,
                        onTap: logic.mitiIDChangeEntry,
                        showBorder: false),
                  ],
                ),
                12.verticalSpace,
                SettingItemGroup(
                  children: [
                    SettingItem(
                        label: StrLibrary.mobile,
                        value: imCtrl.userInfo.value.phoneNumber,
                        showRightArrow: false,
                        showBorder: false),
                    SettingItem(
                      label: StrLibrary.email,
                      value: imCtrl.userInfo.value.email,
                      showRightArrow: false,
                    ),
                  ],
                ),
                12.verticalSpace,
                SettingItemGroup(
                  children: [
                    SettingItem(
                        label: StrLibrary.name,
                        value: imCtrl.userInfo.value.nickname,
                        onTap: logic.editMyName,
                        showBorder: false),
                    SettingItem(
                      label: StrLibrary.gender,
                      value: imCtrl.userInfo.value.isMale
                          ? StrLibrary.man
                          : StrLibrary.woman,
                      onTap: logic.selectGender,
                    ),
                    SettingItem(
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
}
