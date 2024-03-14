import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'send_verification_application_logic.dart';

class SendVerificationApplicationPage extends StatelessWidget {
  final logic = Get.find<SendVerificationApplicationLogic>();

  SendVerificationApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.back(
          title: logic.isEnterGroup
              ? StrLibrary.groupVerification
              : StrLibrary.friendVerification,
          right: StrLibrary.send.toText
            ..style = Styles.ts_333333_17sp
            ..onTap = logic.send,
        ),
        backgroundColor: Styles.c_F8F9FA,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
                child: (logic.isEnterGroup
                        ? StrLibrary.sendEnterGroupApplication
                        : StrLibrary.sendToBeFriendApplication)
                    .toText
                  ..style = Styles.ts_999999_14sp,
              ),
              Container(
                height: 122.h,
                color: Styles.c_FFFFFF,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: TextField(
                  // expands: true,
                  controller: logic.inputCtrl,
                  autofocus: true,
                  maxLines: 10,
                  maxLength: 20,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
