import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'train_ai_logic.dart';

class TrainAiPage extends StatelessWidget {
  final logic = Get.find<TrainAiLogic>();

  TrainAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => KeyboardDismissOnTap(
        child: Scaffold(
            appBar: TitleBar.trainAi(
              backgroundColor: StylesLibrary.c_F7F8FA,
              left: Expanded(
                  child: Row(children: [
                ImageLibrary.appBackBlack.toImage
                  ..width = 24.w
                  ..height = 24.h
                  ..onTap = (() => Get.back()),
                SizedBox(width: 12.w),
                AvatarView(
                  url: logic.faceURL.value,
                  text: logic.showName.value,
                  width: 36.w,
                  height: 36.h,
                ),
                9.horizontalSpace,
                logic.showName.value.toText
                  ..style = StylesLibrary.ts_333333_18sp_medium
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis
                  ..textAlign = TextAlign.center,
              ])),
              right: logic.canSeeFiles
                  ? SizedBox(
                      width: 40.w,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ImageLibrary.files.toImage
                            ..width = 40.w
                            ..height = 40.h
                            ..onTap = logic.startKnowledgeFiles,
                        ],
                      ))
                  : const SizedBox(),
            ),
            backgroundColor: StylesLibrary.c_F7F8FA,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: StylesLibrary.c_FFFFFF,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 350.h,
                            child: TextField(
                              controller: logic.inputCtrl,
                              keyboardType: TextInputType.multiline,
                              minLines: null,
                              maxLines: null,
                              expands: true,
                              style: StylesLibrary.ts_333333_16sp,
                              maxLength: logic.maxLength.value,
                              decoration: InputDecoration(
                                hintText: StrLibrary.trainInputTips,
                                helperStyle: StylesLibrary.ts_999999_16sp,
                                counterText: '',
                                counterStyle: StylesLibrary.ts_999999_12sp,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 15.h,
                                ),
                                isDense: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
                                    height: 58.h,
                                    width: 58.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.r),
                                      color: StylesLibrary.c_F7F7F7,
                                    ),
                                    child: Center(
                                      child: ImageLibrary.add.toImage
                                        ..width = 26.w
                                        ..height = 26.h
                                        ..onTap = logic.selectFile,
                                    ),
                                  ),
                                ),
                                logic.count.toText
                                  ..style = StylesLibrary.ts_999999_12sp
                              ],
                            ),
                          ),
                          15.verticalSpace
                        ],
                      ),
                    ),
                    11.verticalSpace,
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: logic.selectKnowledgebase,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: StylesLibrary.c_FFFFFF,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 15.h),
                        child: Row(
                          children: [
                            StrLibrary.knowledgebase.toText
                              ..style = StylesLibrary.ts_2C2C2C_16sp,
                            const Spacer(),
                            (logic.selectedKnowledgebase.value
                                        ?.knowledgebaseName ??
                                    StrLibrary.select)
                                .toText
                              ..style = StylesLibrary.ts_999999_16sp,
                            ImageLibrary.appRightArrow.toImage
                              ..width = 20.w
                              ..height = 20.h
                          ],
                        ),
                      ),
                    ),
                    11.verticalSpace,
                    if (logic.fileNames.isEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StrLibrary.trainFileTips1.toText
                            ..style = StylesLibrary.ts_999999_14sp,
                          3.verticalSpace,
                          StrLibrary.trainFileTips2.toText
                            ..style = StylesLibrary.ts_999999_14sp,
                        ],
                      ),
                    if (logic.fileNames.isNotEmpty)
                      ...List.generate(
                          logic.fileNames.length,
                          (index) => Container(
                                margin: EdgeInsets.only(bottom: 15.h),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: StylesLibrary.c_FFFFFF,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ImageLibrary.files.toImage
                                      ..width = 40.w
                                      ..height = 40.h,
                                    10.horizontalSpace,
                                    Expanded(
                                      child: logic.fileNames[index].toText
                                        ..style = StylesLibrary.ts_666666_16sp
                                        ..maxLines = 1
                                        ..overflow = TextOverflow.ellipsis,
                                    ),
                                    10.horizontalSpace
                                  ],
                                ),
                              )),
                    50.verticalSpace,
                    Button(
                        text: StrLibrary.startTrain,
                        textStyle: StylesLibrary.ts_FFFFFF_16sp,
                        disabledTextStyle: StylesLibrary.ts_FFFFFF_16sp,
                        disabledColor: StylesLibrary.c_8443F8_opacity40,
                        height: 42.h,
                        width: 289.w,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        onTap: logic.train,
                        enabled: logic.canTain)
                  ],
                ),
              ),
            ))));
  }
}
