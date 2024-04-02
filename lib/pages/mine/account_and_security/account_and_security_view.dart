import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti/pages/mine/phone_email_change/phone_email_change_logic.dart';
import 'package:miti_common/miti_common.dart';
import 'account_and_security_logic.dart';

class AccountAndSecurityPage extends StatelessWidget {
  final logic = Get.find<AccountAndSecurityLogic>();
  final imCtrl = Get.find<IMCtrl>();

  AccountAndSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrLibrary.accountAndSecurity,
      ),
      backgroundColor: StylesLibrary.c_F7F8FA,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                12.verticalSpace,
                _buildItemView(
                  label: StrLibrary.accountManage,
                  showRightArrow: true,
                  onTap: () => logic.accountManage(),
                  valueWidget: AvatarView(
                    width: 38.w,
                    height: 38.h,
                    text: imCtrl.userInfo.value.nickname,
                    url: imCtrl.userInfo.value.faceURL,
                  ),
                ),
                _buildItemView(
                  label: StrLibrary.phoneNumber,
                  showRightArrow: true,
                  onTap: () =>
                      logic.phoneEmailChange(type: PhoneEmailChangeType.phone),
                  value: imCtrl.userInfo.value.phoneNumber,
                ),
                _buildItemView(
                  label: StrLibrary.email,
                  showRightArrow: true,
                  onTap: () =>
                      logic.phoneEmailChange(type: PhoneEmailChangeType.email),
                  value: imCtrl.userInfo.value.email,
                ),
                _buildItemView(
                  label: StrLibrary.changePassword,
                  showRightArrow: true,
                  onTap: logic.changePwd,
                ),
                _buildItemView(
                  label: StrLibrary.deleteUser,
                  showRightArrow: true,
                  onTap: logic.deleteUser,
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildItemView({
    required String label,
    TextStyle? textStyle,
    String? value,
    Widget? valueWidget,
    bool switchOn = false,
    bool showRightArrow = false,
    bool showSwitchButton = false,
    bool showBorder = true,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          decoration: BoxDecoration(
            color: StylesLibrary.c_FFFFFF,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: StylesLibrary.c_F1F2F6,
                  width: showBorder ? 1.h : 0,
                ),
              ),
            ),
            child: Row(
              children: [
                label.toText..style = textStyle ?? StylesLibrary.ts_333333_16sp,
                const Spacer(),
                if (null != value)
                  value.toText..style = StylesLibrary.ts_999999_16sp,
                if (null != valueWidget) valueWidget,
                if (showSwitchButton)
                  CupertinoSwitch(
                    value: switchOn,
                    activeColor: StylesLibrary.c_07C160,
                    onChanged: onChanged,
                  ),
                if (showRightArrow)
                  ImageLibrary.appRightArrow.toImage
                    ..width = 20.w
                    ..height = 20.h,
              ],
            ),
          ),
        ),
      );
}
