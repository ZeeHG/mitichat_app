import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'language_setup_logic.dart';

class LanguageSetupPage extends StatelessWidget {
  final logic = Get.find<LanguageSetupLogic>();

  LanguageSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.languageSetup),
      backgroundColor: Styles.c_F7F8FA,
      body: Obx(() => Column(
            children: [
              12.verticalSpace,
              // _buildItemView(
              //   label: StrRes.followSystem,
              //   isChecked: logic.isFollowSystem.value,
              //   onTap: () => logic.switchLanguage(0),
              //   isTopRadius: true,
              //   showBorder: false
              // ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: Styles.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrRes.chinese,
                isChecked: logic.onOff["isChinese"]!.value,
                onTap: () => logic.switchLanguage(1),
              ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: Styles.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrRes.english,
                isChecked: logic.onOff["isEnglish"]!.value,
                onTap: () => logic.switchLanguage(2),
                isBottomRadius: true,
              ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: Styles.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrRes.japanese,
                isChecked: logic.onOff["isJapanese"]!.value,
                onTap: () => logic.switchLanguage(3),
                isBottomRadius: true,
              ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: Styles.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrRes.korean,
                isChecked: logic.onOff["isKorean"]!.value,
                onTap: () => logic.switchLanguage(4),
                isBottomRadius: true,
              ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: Styles.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrRes.spanish,
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
    bool isTopRadius = false,
    bool isBottomRadius = false,
    bool showBorder = true,
    Function()? onTap,
  }) =>
      Container(
        child: Ink(
          height: 52.h,
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Styles.c_F1F2F6,
                        width: showBorder ? 1.h : 0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      label.toText..style = Styles.ts_333333_16sp,
                      const Spacer(),
                      if (isChecked)
                        ImageRes.checked.toImage
                          ..width = 20.w
                          ..height = 15.h,
                    ],
                  ),
                )),
          ),
        ),
      );
}
