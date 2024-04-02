import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import 'delete_user_logic.dart';

class DeleteUserPage extends StatelessWidget {
  final logic = Get.find<DeleteUserLogic>();

  DeleteUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            title: !logic.success.value ? StrLibrary.deleteUser : "",
            hideBack: logic.success.value,
          ),
          backgroundColor: StylesLibrary.c_FFFFFF,
          body: SingleChildScrollView(
            child: Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 36.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: !logic.success.value
                      ? [
                          45.verticalSpace,
                          ImageLibrary.appWarn.toImage
                            ..width = 70.w
                            ..height = 70.h,
                          24.verticalSpace,
                          StrLibrary.deleteUserTips1.toText
                            ..style = StylesLibrary.ts_333333_20sp_medium,
                          10.verticalSpace,
                          StrLibrary.deleteUserTips2.toText
                            ..style = StylesLibrary.ts_999999_16sp,
                          10.verticalSpace,
                          StrLibrary.deleteUserTips3.toText
                            ..style = StylesLibrary.ts_999999_16sp,
                          10.verticalSpace,
                          StrLibrary.deleteUserTips4.toText
                            ..style = StylesLibrary.ts_999999_16sp,
                          25.verticalSpace,
                          Container(
                            height: 46.h,
                            padding: EdgeInsets.symmetric(horizontal: 23.w),
                            decoration: BoxDecoration(
                              color: StylesLibrary.c_F7F8FA,
                              borderRadius: BorderRadius.circular(23.r),
                            ),
                            child: InputBox.password(
                              hintText: StrLibrary.plsEnterPassword,
                              border: false,
                              controller: logic.pwdCtrl,
                            ),
                          ),
                          176.verticalSpace,
                          Button(
                            enabled: logic.enabled.value,
                            width: 1.sw - 72.w,
                            text: StrLibrary.deleteUser,
                            onTap: logic.showDeleteUserModal,
                          )
                        ]
                      : [
                          45.verticalSpace,
                          ImageLibrary.appSuccess.toImage
                            ..width = 70.w
                            ..height = 70.h,
                          24.verticalSpace,
                          StrLibrary.deleteUserSuccess.toText
                            ..style = StylesLibrary.ts_333333_20sp_medium,
                          10.verticalSpace,
                          StrLibrary.deleteUserSuccessTips.toText
                            ..textAlign = TextAlign.center
                            ..style = StylesLibrary.ts_999999_16sp,
                          45.verticalSpace,
                          Button(
                            width: 1.sw - 72.w,
                            text: StrLibrary.finishAndLogout,
                            onTap: logic.logout,
                          )
                        ]),
            ),
          ),
        ));
  }
}
