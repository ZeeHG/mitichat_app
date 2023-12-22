import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'book_meeting_logic.dart';

class BookMeetingPage extends StatelessWidget {
  final logic = Get.find<BookMeetingLogic>();

  BookMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.back(
          title: logic.meetingInfo != null
              ? StrRes.updateMeetingInfo
              : StrRes.bookAMeeting,
        ),
        backgroundColor: Styles.c_F8F9FA,
        body: SingleChildScrollView(
          child: Column(
            children: [
              12.verticalSpace,
              Container(
                height: 58.h,
                color: Styles.c_FFFFFF,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.centerLeft,
                child: TextField(
                  style: Styles.ts_0C1C33_17sp,
                  controller: logic.meetingSubjectCtrl,
                  focusNode: logic.focusNode,
                  decoration: InputDecoration(
                    hintStyle: Styles.ts_8E9AB0_17sp,
                    hintText: StrRes.plsInputMeetingSubject,
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Obx(() => _buildItemView(
                    label: StrRes.meetingStartTime,
                    onTap: logic.selectMeetingStartTime,
                    value: logic.startTime.value,
                  )),
              Obx(() => _buildItemView(
                    label: StrRes.meetingDuration,
                    onTap: logic.selectMeetingDuration,
                    value: logic.duration.value,
                  )),
              Obx(() => Button(
                    text: logic.meetingInfo != null
                        ? StrRes.confirmTheChanges
                        : StrRes.bookAMeeting,
                    onTap: logic.meetingInfo != null
                        ? logic.modifyMeeting
                        : logic.bookMeeting,
                    enabled: logic.enabled.value,
                    margin: EdgeInsets.symmetric(
                      horizontal: 72.w,
                      vertical: 90.h,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemView({
    required String label,
    String? value,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          height: 58.h,
          color: Styles.c_FFFFFF,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              label.toText..style = Styles.ts_0C1C33_17sp,
              Expanded(
                child: (value ?? "").toText
                  ..style = Styles.ts_8E9AB0_17sp
                  ..textAlign = TextAlign.right,
              ),
              5.horizontalSpace,
              ImageRes.rightArrow.toImage
                ..width = 24.w
                ..height = 24.h,
            ],
          ),
        ),
      );
}
