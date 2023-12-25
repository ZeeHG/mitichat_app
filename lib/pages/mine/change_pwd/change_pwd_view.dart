import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'change_pwd_logic.dart';

class ChangePwdPage extends StatelessWidget {
  final logic = Get.find<ChangePwdLogic>();

  ChangePwdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.back(
            title: StrRes.changePassword,
            right: Container(
              width: 56.w,
              height: 28.h,
              child: Button(
                text: StrRes.determine,
                enabled: logic.enabled,
                onTap: logic.confirm,
                textStyle: Styles.ts_FFFFFF_16sp,
              ),
            )
            // StrRes.determine.toText
            //   ..style = Styles.ts_333333_16sp
            //   ..onTap = logic.confirm,
            ),
        backgroundColor: Styles.c_F7F8FA,
        body: SingleChildScrollView(
          child: Column(
            children: [
              12.verticalSpace,
              _buildItemView(
                label: StrRes.oldPwd,
                controller: logic.oldPwdCtrl,
                autofocus: true,
                isTopRadius: true,
              ),
              Container(
                margin: EdgeInsets.only(left: 12.w, right: 12.w),
                color: Styles.c_F1F2F6,
                height: 1.h,
              ),
              _buildItemView(
                label: StrRes.newPwd,
                controller: logic.newPwdCtrl,
              ),
              Container(
                margin: EdgeInsets.only(left: 12.w, right: 12.w),
                color: Styles.c_F1F2F6,
                height: 1.h,
              ),
              _buildItemView(
                label: StrRes.confirmNewPwd,
                controller: logic.againPwdCtrl,
                isBottomRadius: true,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 12.h, left: 12.w),
                child: Text(
                  StrRes.pwdTips,
                  style: Styles.ts_999999_12sp,
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
          color: Styles.c_FFFFFF,
        ),
        child: Row(
          children: [
            label.toText..style = Styles.ts_333333_16sp,
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: autofocus,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.end,
                style: Styles.ts_333333_16sp,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      );
}
