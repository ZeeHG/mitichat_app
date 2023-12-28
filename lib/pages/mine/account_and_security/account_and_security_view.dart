import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim/core/controller/im_controller.dart';
import 'package:openim/pages/mine/phone_email_change/phone_email_change_logic.dart';
import 'package:openim_common/openim_common.dart';

import 'account_and_security_logic.dart';

class AccountAndSecurityPage extends StatelessWidget {
  final logic = Get.find<AccountAndSecurityLogic>();
  final imLogic = Get.find<IMController>();

  AccountAndSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.accountAndSecurity,
      ),
      backgroundColor: Styles.c_F7F8FA,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                12.verticalSpace,
                _buildItemView(
                  label: StrRes.phoneNumber,
                  showRightArrow: true,
                  onTap: () => logic.phoneEmailChange(type: PhoneEmailChangeType.phone),
                  value: imLogic.userInfo.value.phoneNumber,
                ),
                _buildItemView(
                  label: StrRes.email,
                  showRightArrow: true,
                  onTap: () => logic.phoneEmailChange(type: PhoneEmailChangeType.email),
                  value: imLogic.userInfo.value.email,
                ),
                _buildItemView(
                  label: StrRes.changePassword,
                  showRightArrow: true,
                  onTap: logic.changePwd,
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
    bool switchOn = false,
    bool isTopRadius = false,
    bool isBottomRadius = false,
    bool showRightArrow = false,
    bool showSwitchButton = false,
    bool showBorder = true,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      Container(
        child: Ink(
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
          ),
          child: InkWell(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Styles.c_F1F2F6,
                        width: showBorder ? 1.h : 0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      label.toText..style = textStyle ?? Styles.ts_333333_16sp,
                      const Spacer(),
                      if (null != value)
                        value.toText..style = Styles.ts_999999_16sp,
                      if (showSwitchButton)
                        CupertinoSwitch(
                          value: switchOn,
                          activeColor: Styles.c_07C160,
                          onChanged: onChanged,
                        ),
                      if (showRightArrow)
                        ImageRes.appRightArrow.toImage
                          ..width = 20.w
                          ..height = 20.h,
                    ],
                  ),
                ),
              )),
        ),
      );
}
