import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

import 'dev_entry_logic.dart';

class DevEntryPage extends StatelessWidget {
  final logic = Get.find<DevEntryLogic>();

  DevEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: ""),
      backgroundColor: StylesLibrary.c_FFFFFF,
      body: SingleChildScrollView(
        child: Obx(() => Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Column(
                children: [
                  logic.ver.value.toText,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: StylesLibrary.c_F7F8FA,
                    borderRadius: BorderRadius.circular(46.r),
                  ),
                  child: Row(children: [
                    Expanded(
                      child: InputBox(
                          controller: logic.inputCtrl,
                          border: false),
                    ),
                  ]),
                ),
                20.verticalSpace,
                Button(
                  width: 1.sw - 80.w,
                  text: StrLibrary.submit,
                  onTap: logic.tempLogin,
                )
              ]
              ),
            )),
      ),
    );
  }
}
