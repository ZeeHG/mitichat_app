import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'miti_id_change_rule_logic.dart';

class MitiIDChangeRulePage extends StatelessWidget {
  final logic = Get.find<MitiIDChangeRuleLogic>();

  MitiIDChangeRulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: ""),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: DefaultTextStyle(
              style: StylesLibrary.ts_333333_14sp,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: StrLibrary.changeMitiRule1.toText..style= StylesLibrary.ts_333333_16sp
                    ),
                    10.verticalSpace,
                    StrLibrary.changeMitiRule2.toText,
                    10.verticalSpace,
                    StrLibrary.changeMitiRule3.toText,
                    10.verticalSpace,
                    StrLibrary.changeMitiRule4.toText,
                    10.verticalSpace,
                    StrLibrary.changeMitiRule5.toText,
                    10.verticalSpace,
                    Align(
                      alignment: Alignment.centerRight,
                      child: StrLibrary.changeMitiRule6.toText
                    ),
                    10.verticalSpace,
                    Align(
                      alignment: Alignment.centerRight,
                      child: StrLibrary.changeMitiRule7.toText,
                    ),
                  ])),
        ),
      ),
    );
  }
}
