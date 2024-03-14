import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'set_mute_for_member_logic.dart';

class SetMuteForGroupMemberPage extends StatelessWidget {
  final logic = Get.find<SetMuteForGroupMemberLogic>();

  SetMuteForGroupMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrLibrary.setMute,
        right: StrLibrary.determine.toText
          ..style = Styles.ts_333333_17sp
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
                label: StrLibrary.tenMinutes,
                index: 0,
                isTopRadius: true,
              ),
              _buildItemView(
                label: StrLibrary.oneHour,
                index: 1,
              ),
              _buildItemView(
                label: StrLibrary.twelveHours,
                index: 2,
              ),
              _buildItemView(
                label: StrLibrary.oneDay,
                index: 3,
              ),
              _buildItemView(
                label: StrLibrary.unmute,
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
                    label.toText..style = Styles.ts_333333_17sp,
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
            StrLibrary.custom.toText..style = Styles.ts_333333_17sp,
            Expanded(
              child: TextField(
                controller: logic.controller,
                focusNode: logic.focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                style: Styles.ts_333333_17sp,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            10.horizontalSpace,
            StrLibrary.day.toText..style = Styles.ts_333333_17sp,
          ],
        ),
      );
}
