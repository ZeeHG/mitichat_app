import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'change_pwd_logic.dart';

class ChangePwdPage extends StatelessWidget {
  final logic = Get.find<ChangePwdLogic>();

  ChangePwdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: TitleBar.back(
            title: StrLibrary.changePassword,
            right: SizedBox(
              width: 56.w,
              height: 28.h,
              child: Button(
                text: StrLibrary.determine,
                enabled: logic.enabled,
                onTap: logic.confirm,
                textStyle: StylesLibrary.ts_FFFFFF_16sp,
              ),
            )),
        backgroundColor: StylesLibrary.c_F7F8FA,
        body: SingleChildScrollView(
          child: Column(
            children: [
              12.verticalSpace,
              _buildItemView(
                label: StrLibrary.oldPwd,
                controller: logic.oldPwdCtrl,
                autofocus: true,
                isTopRadius: true,
              ),
              Container(
                margin: EdgeInsets.only(left: 12.w, right: 12.w),
                color: StylesLibrary.c_F1F2F6,
                height: 1.h,
              ),
              _buildItemView(
                label: StrLibrary.newPwd,
                controller: logic.newPwdCtrl,
              ),
              Container(
                margin: EdgeInsets.only(left: 12.w, right: 12.w),
                color: StylesLibrary.c_F1F2F6,
                height: 1.h,
              ),
              _buildItemView(
                label: StrLibrary.confirmNewPwd,
                controller: logic.againPwdCtrl,
                isBottomRadius: true,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 12.h, left: 12.w),
                child: Text(
                  StrLibrary.pwdTips,
                  style: StylesLibrary.ts_999999_12sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemView({
    required String label,
    TextEditingController? controller,
    bool autofocus = false,
    bool isTopRadius = false,
    bool isBottomRadius = false,
  }) =>
      Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: StylesLibrary.c_FFFFFF,
        ),
        child: Row(
          children: [
            label.toText..style = StylesLibrary.ts_333333_16sp,
            Expanded(
              child: InputBox.password(
                border: false,
                controller: controller,
                inputFormatters: [MitiUtils.getPasswordFormatter()],
              ),
            ),
          ],
        ),
      );
}
