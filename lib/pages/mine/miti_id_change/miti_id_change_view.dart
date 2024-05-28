import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'miti_id_change_logic.dart';

class MitiIDChangePage extends StatelessWidget {
  final logic = Get.find<MitiIDChangeLogic>();

  MitiIDChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: ""),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              30.verticalSpace,
              StrLibrary.enterMitiID.toText
                ..style = StylesLibrary.ts_333333_16sp
                ..textAlign = TextAlign.center,
              30.verticalSpace,
              StrLibrary.mitiIDRules.toText
                ..style = StylesLibrary.ts_333333_14sp
                ..textAlign = TextAlign.center,
              30.verticalSpace,
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  color: StylesLibrary.c_E8EAEF,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: TextField(
                  controller: logic.inputCtrl,
                  style: StylesLibrary.ts_333333_14sp,
                  autofocus: true,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 12.w,
                    ),
                  ),
                ),
              ),
              30.verticalSpace,
              Button(
                width: 1.sw - 86.w,
                text: StrLibrary.submit,
                onTap: logic.confirm,
              )
            ],
          ),
        ),
      ),
    );
  }
}
