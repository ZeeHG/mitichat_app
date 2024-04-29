import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'training_bot_logic.dart';

class TrainingBotPage extends StatelessWidget {
  final logic = Get.find<TrainingBotLogic>();

  TrainingBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TitleBar.back(
          title: StrLibrary.training,
        ),
        backgroundColor: StylesLibrary.c_F7F8FA,
        body: Stack(
          children: [
            SizedBox(
              height: 1.sh,
              child: Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    child: Row(
                      children: [
                        ImageLibrary.appRefresh.toImage
                          ..width = 16.w
                          ..height = 16.h,
                        10.horizontalSpace,
                        StrLibrary.temp1.toText
                          ..style = StylesLibrary.ts_8443F8_12sp,
                      ],
                    ),
                  ),
                  Container(
                    color: StylesLibrary.c_FFFFFF,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ("${StrLibrary.question}：").toText
                          ..style = StylesLibrary.ts_303137_14sp_medium,
                        TextFormField(
                          maxLines: 7,
                          style: StylesLibrary.ts_303137_14sp_medium,
                          decoration: InputDecoration(
                              fillColor: StylesLibrary.c_FFFFFF,
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              border: InputBorder.none),
                        )
                      ],
                    ),
                  ),
                  12.verticalSpace,
                  Container(
                    color: StylesLibrary.c_FFFFFF,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ("${StrLibrary.answer}：").toText
                          ..style = StylesLibrary.ts_303137_14sp_medium,
                        TextFormField(
                          maxLines: 7,
                          style: StylesLibrary.ts_303137_14sp_medium,
                          decoration: InputDecoration(
                              fillColor: StylesLibrary.c_FFFFFF,
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              border: InputBorder.none),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 30.h,
                child: Container(
                  height: 42.h,
                  width: 1.sw,
                  alignment: Alignment.center,
                  child: Button(
                    text: StrLibrary.startTrain,
                    textStyle: StylesLibrary.ts_FFFFFF_16sp,
                    radius: 21.r,
                    enabledColor: StylesLibrary.c_8443F8,
                    height: 42.h,
                    width: 289.w,
                  ),
                ))
          ],
        ));
  }
}
