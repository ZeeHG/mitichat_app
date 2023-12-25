import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'account_setup_logic.dart';

class AccountSetupPage extends StatelessWidget {
  final logic = Get.find<AccountSetupLogic>();

  AccountSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.accountSetup,
      ),
      backgroundColor: Styles.c_F7F8FA,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                12.verticalSpace,
                _buildItemView(
                  showBorder: false,
                  label: StrRes.notDisturbMode,
                  switchOn: logic.isGlobalNotDisturb,
                  onChanged: (_) => logic.toggleNotDisturbMode(),
                  showSwitchButton: true,
                  isTopRadius: true,
                ),
                _buildItemView(
                  label: StrRes.allowRing,
                  switchOn: logic.isAllowBeep,
                  onChanged: (_) => logic.toggleBeep(),
                  showSwitchButton: true,
                ),
                _buildItemView(
                  label: StrRes.allowVibrate,
                  switchOn: logic.isAllowVibration,
                  onChanged: (_) => logic.toggleVibration(),
                  showSwitchButton: true,
                  isBottomRadius: true,
                ),
                12.verticalSpace,
                _buildItemView(
                  showBorder: false,
                  label: StrRes.forbidAddMeToFriend,
                  switchOn: !logic.isAllowAddFriend,
                  onChanged: (_) => logic.toggleForbidAddMeToFriend(),
                  showSwitchButton: true,
                  isTopRadius: true,
                ),
                _buildItemView(
                  label: StrRes.blacklist,
                  onTap: logic.blacklist,
                  showRightArrow: true,
                ),
                _buildItemView(
                  label: StrRes.languageSetup,
                  value: logic.curLanguage.value,
                  onTap: logic.languageSetting,
                  showRightArrow: true,
                  isBottomRadius: true,
                ),
                12.verticalSpace,
                _buildItemView(
                  showBorder: false,
                  label: StrRes.unlockSettings,
                  onTap: logic.unlockSetup,
                  showRightArrow: true,
                  isTopRadius: true,
                ),
                _buildItemView(
                  label: StrRes.changePassword,
                  showRightArrow: true,
                  onTap: logic.changePwd,
                ),
                _buildItemView(
                  label: StrRes.clearChatHistory,
                  onTap: logic.clearChatHistory,
                  showRightArrow: true,
                  isBottomRadius: true,
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
                      // if (null != value)
                      //   value.toText..style = Styles.ts_999999_16sp,
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
