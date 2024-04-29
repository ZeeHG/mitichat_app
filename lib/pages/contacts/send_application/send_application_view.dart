import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'send_application_logic.dart';

class SendApplicationPage extends StatelessWidget {
  final logic = Get.find<SendApplicationLogic>();

  SendApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: TitleBar.back(
          title: logic.isEnterGroup
              ? StrLibrary.groupVerification
              : StrLibrary.friendVerification,
          right: StrLibrary.send.toText
            ..style = StylesLibrary.ts_333333_16sp
            ..onTap = logic.send,
        ),
        backgroundColor: StylesLibrary.c_F8F9FA,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                child: (logic.isEnterGroup
                        ? StrLibrary.sendEnterGroupApplication
                        : StrLibrary.sendToBeFriendApplication)
                    .toText
                  ..style = StylesLibrary.ts_999999_14sp,
              ),
              Container(
                height: 140.h,
                color: StylesLibrary.c_FFFFFF,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: TextField(
                  // expands: true,
                  controller: logic.inputCtrl,
                  maxLines: 5,
                  maxLength: 20,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
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
