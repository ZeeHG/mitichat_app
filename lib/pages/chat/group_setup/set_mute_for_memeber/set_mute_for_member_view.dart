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
          ..style = Styles.ts_333333_16sp
          ..onTap = logic.completed,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              12.verticalSpace,
              _itemView(
                label: StrLibrary.tenMinutes,
                index: 0,
                isTopRadius: true,
              ),
              _itemView(
                label: StrLibrary.oneHour,
                index: 1,
              ),
              _itemView(
                label: StrLibrary.twelveHours,
                index: 2,
              ),
              _itemView(
                label: StrLibrary.oneDay,
                index: 3,
              ),
              _itemView(
                label: StrLibrary.unmute,
                index: 4,
                isBottomRadius: true,
              ),
              10.verticalSpace,
              _customInputView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemView({
    required String label,
    required int index,
    bool isTopRadius = false,
    bool isBottomRadius = false,
  }) =>
      Obx(() => GestureDetector(
        onTap: () => logic.checkedIndex(index),
        behavior: HitTestBehavior.translucent,
        child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isTopRadius ? 6.r : 0),
                  topRight: Radius.circular(isTopRadius ? 6.r : 0),
                  bottomRight: Radius.circular(isBottomRadius ? 6.r : 0),
                  bottomLeft: Radius.circular(isBottomRadius ? 6.r : 0),
                ),
                color: Styles.c_FFFFFF,
              ),
              child: Row(
                children: [
                  label.toText..style = Styles.ts_333333_16sp,
                  const Spacer(),
                  if (logic.index.value == index)
                    ImageRes.checked.toImage
                      ..width = 22.w
                      ..height = 22.h,
                ],
              ),
            ),
      ));

  Widget _customInputView() => Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StrLibrary.custom.toText..style = Styles.ts_333333_16sp,
            Expanded(
              child: TextField(
                controller: logic.controller,
                focusNode: logic.focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                style: Styles.ts_333333_16sp,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            10.horizontalSpace,
            StrLibrary.day.toText..style = Styles.ts_333333_16sp,
          ],
        ),
      );
}
