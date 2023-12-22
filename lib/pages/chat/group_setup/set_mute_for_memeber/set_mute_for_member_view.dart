import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'set_mute_for_member_logic.dart';

class SetMuteForGroupMemberPage extends StatelessWidget {
  final logic = Get.find<SetMuteForGroupMemberLogic>();

  SetMuteForGroupMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.setMute,
        right: StrRes.determine.toText
          ..style = Styles.ts_0C1C33_17sp
          ..onTap = logic.completed,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              12.verticalSpace,
              _buildItemView(
                label: StrRes.tenMinutes,
                index: 0,
                isTopRadius: true,
              ),
              _buildItemView(
                label: StrRes.oneHour,
                index: 1,
              ),
              _buildItemView(
                label: StrRes.twelveHours,
                index: 2,
              ),
              _buildItemView(
                label: StrRes.oneDay,
                index: 3,
              ),
              _buildItemView(
                label: StrRes.unmute,
                index: 4,
                isBottomRadius: true,
              ),
              10.verticalSpace,
              _buildCustomInputView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemView({
    required String label,
    required int index,
    bool isTopRadius = false,
    bool isBottomRadius = false,
  }) =>
      Obx(() => Ink(
            height: 46.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isTopRadius ? 6.r : 0),
                topRight: Radius.circular(isTopRadius ? 6.r : 0),
                bottomRight: Radius.circular(isBottomRadius ? 6.r : 0),
                bottomLeft: Radius.circular(isBottomRadius ? 6.r : 0),
              ),
              color: Styles.c_FFFFFF,
            ),
            child: InkWell(
              onTap: () => logic.checkedIndex(index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    label.toText..style = Styles.ts_0C1C33_17sp,
                    const Spacer(),
                    if (logic.index.value == index)
                      ImageRes.checked.toImage
                        ..width = 24.w
                        ..height = 24.h,
                  ],
                ),
              ),
            ),
          ));

  Widget _buildCustomInputView() => Container(
        height: 46.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StrRes.custom.toText..style = Styles.ts_0C1C33_17sp,
            Expanded(
              child: TextField(
                controller: logic.controller,
                focusNode: logic.focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                style: Styles.ts_0C1C33_17sp,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            10.horizontalSpace,
            StrRes.day.toText..style = Styles.ts_0C1C33_17sp,
          ],
        ),
      );
}
