import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

import 'active_account_entry_logic.dart';

class ActiveAccountEntryPage extends StatelessWidget {
  final logic = Get.find<ActiveAccountEntryLogic>();

  ActiveAccountEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: ""),
      backgroundColor: StylesLibrary.c_FFFFFF,
      body: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
          child: Column(children: [
            60.verticalSpace,
            ImageLibrary.activeAccountEntry.toImage
              ..width = 100.w
              ..height = 100.h,
            30.verticalSpace,
            StrLibrary.activeTips.toText..style = StylesLibrary.ts_333333_16sp,
            30.verticalSpace,
            Button(
              width: 1.sw - 80.w,
              text: StrLibrary.goActive,
              onTap: logic.activeAccount,
            )
          ]),
        ),
      ),
    );
  }
}
