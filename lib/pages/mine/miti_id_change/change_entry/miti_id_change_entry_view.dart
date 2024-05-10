import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'miti_id_change_entry_logic.dart';

class MitiIDChangeEntryPage extends StatelessWidget {
  final logic = Get.find<MitiIDChangeEntryLogic>();

  MitiIDChangeEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: ""),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          child: Column(
            children: [
              50.verticalSpace,
              ImageLibrary.miti.toImage
                ..height = 100.h
                ..width = 100.w,
              30.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: StrLibrary.changeMitiIDTips.toText..style = StylesLibrary.ts_333333_16sp
                ..textAlign = TextAlign.center,
              ),
              30.verticalSpace,
              Button(
                width: 1.sw - 86.w,
                text: StrLibrary.changeMitiID,
                onTap: logic.mitiIDChange,
              )
            ],
          ),
        ),
      ),
    );
  }
}
