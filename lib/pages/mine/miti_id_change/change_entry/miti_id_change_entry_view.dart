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
      body: Obx(() => SingleChildScrollView(
            child: SizedBox(
              width: 1.sw,
              child: Column(
                children: [
                  if(logic.enable.value)
                  50.verticalSpace,
                  if(!logic.enable.value)
                  Container(
                    margin: EdgeInsets.only(left: 40.w, right: 40.w, top: 10.h),
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: StylesLibrary.c_8443F8,
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: logic.dateTips.toText..style=StylesLibrary.ts_FFFFFF_14sp..textAlign=TextAlign.center,
                  ),
                  ImageLibrary.mitiidBg.toImage
                    ..width = 224.w
                    ..height = 224.h,
                  15.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: StrLibrary.changeMitiIDTips.toText
                      ..style = StylesLibrary.ts_333333_14sp
                      ..textAlign = TextAlign.center,
                  ),
                  15.verticalSpace,
                  Button(
                    width: 1.sw - 80.w,
                    text: StrLibrary.changeMitiID,
                    onTap: logic.mitiIDChange,
                    enabled: logic.enable.value,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
