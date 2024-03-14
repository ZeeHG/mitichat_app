import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/core/controller/im_controller.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import 'phone_email_change_logic.dart';

class PhoneEmailChangePage extends StatelessWidget {
  final logic = Get.find<PhoneEmailChangeLogic>();
  final imLogic = Get.find<IMController>();

  PhoneEmailChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(),
      backgroundColor: Styles.c_FFFFFF,
      body: Obx(() => Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  43.verticalSpace,
                  (logic.isPhone &&
                              (null == imLogic.userInfo.value.phoneNumber ||
                                  imLogic
                                      .userInfo.value.phoneNumber!.isEmpty)) ||
                          (!logic.isPhone &&
                              (null == imLogic.userInfo.value.email ||
                                  imLogic.userInfo.value.email!.isEmpty))
                      ? (sprintf(StrLibrary.noBind,
                              [logic.isPhone ? StrLibrary.mobile : StrLibrary.email])
                          .toText
                        ..style = Styles.ts_999999_18sp)
                      : ((logic.isPhone
                              ? StrLibrary.curBindPhone
                              : StrLibrary.curBindEmail)
                          .toText
                        ..style = Styles.ts_999999_18sp),
                  20.verticalSpace,
                  if (logic.isPhone &&
                      null != imLogic.userInfo.value.phoneNumber)
                    imLogic.userInfo.value.phoneNumber!.toText
                      ..style = Styles.ts_333333_24sp_medium,
                  if (!logic.isPhone && null != imLogic.userInfo.value.email)
                    imLogic.userInfo.value.email!.toText
                      ..style = Styles.ts_333333_24sp_medium,
                  50.verticalSpace,
                  Button(
                    width: 1.sw - 86.w,
                    text: logic.isPhone &&
                            (imLogic.userInfo.value.phoneNumber?.isNotEmpty ??
                                false)
                        ? StrLibrary.changePhone
                        : logic.isPhone &&
                                (imLogic.userInfo.value.phoneNumber?.isEmpty ??
                                    true)
                            ? StrLibrary.bindPhone
                            : !logic.isPhone &&
                                    (imLogic.userInfo.value.email?.isNotEmpty ??
                                        false)
                                ? StrLibrary.changeEmail
                                : StrLibrary.bindEmail,
                    onTap: logic.phoneEmailChangeDetail,
                  )
                ]
                // (logic.isPhone? imLogic.userInfo.value.phoneNumber : imLogic.userInfo.value.email),
                ),
          )),
    );
  }
}
