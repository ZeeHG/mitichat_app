import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'language_setting_logic.dart';

class LanguageSettingPage extends StatelessWidget {
  final logic = Get.find<LanguageSettingLogic>();

  LanguageSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.languageSetting),
      backgroundColor: StylesLibrary.c_F7F8FA,
      body: Obx(() => Column(
            children: [
              12.verticalSpace,
              // _buildItemView(
              //   label: StrLibrary .followSystem,
              //   isChecked: logic.isFollowSystem.value,
              //   onTap: () => logic.switchLanguage(0),
              //   showBorder: false
              // ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: StylesLibrary.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrLibrary.english,
                isChecked: logic.onOff["isEnglish"]!.value,
                onTap: () => logic.switchLanguage(2),
                isBottomRadius: true,
              ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: StylesLibrary.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrLibrary.chinese,
                isChecked: logic.onOff["isChinese"]!.value,
                onTap: () => logic.switchLanguage(1),
              ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: StylesLibrary.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrLibrary.japanese,
                isChecked: logic.onOff["isJapanese"]!.value,
                onTap: () => logic.switchLanguage(3),
                isBottomRadius: true,
              ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: StylesLibrary.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrLibrary.korean,
                isChecked: logic.onOff["isKorean"]!.value,
                onTap: () => logic.switchLanguage(4),
                isBottomRadius: true,
              ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: StylesLibrary.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrLibrary.spanish,
                isChecked: logic.onOff["isSpanish"]!.value,
                onTap: () => logic.switchLanguage(5),
                isBottomRadius: true,
              ),
            ],
          )),
    );
  }

  Widget _buildItemView({
    required String label,
    bool isChecked = false,
    bool isBottomRadius = false,
    bool showBorder = true,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 52.h,
          decoration: BoxDecoration(
            color: StylesLibrary.c_FFFFFF,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: StylesLibrary.c_F1F2F6,
                  width: showBorder ? 1.h : 0,
                ),
              ),
            ),
            child: Row(
              children: [
                label.toText..style = StylesLibrary.ts_333333_16sp,
                const Spacer(),
                if (isChecked)
                  ImageLibrary.checked.toImage
                    ..width = 20.w
                    ..height = 15.h,
              ],
            ),
          ),
        ),
      );
}
