import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'join_meeting_logic.dart';

class JoinMeetingPage extends StatelessWidget {
  final logic = Get.find<JoinMeetingLogic>();

  JoinMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.back(title: StrRes.joinMeeting),
        backgroundColor: Styles.c_F8F9FA,
        body: SingleChildScrollView(
          child: Column(
            children: [
              12.verticalSpace,
              _buildItemView(
                label: StrRes.meetingNo,
                hintText: StrRes.plsInputMeetingNo,
                controller: logic.meetingNumberCtrl,
              ),
              // _buildItemView(
              //   label: StrRes.yourMeetingName,
              //   hintText: StrRes.plsInputYouMeetingName,
              //   controller: logic.yourNameCtrl,
              // ),
              Obx(() => Button(
                    text: StrRes.enterMeeting,
                    onTap: logic.joinMeeting,
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
    TextEditingController? controller,
    String? hintText,
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
              Container(
                constraints: BoxConstraints(minWidth: 80.w),
                child: label.toText..style = Styles.ts_0C1C33_17sp_medium,
              ),
              10.horizontalSpace,
              Expanded(
                child: TextField(
                  style: Styles.ts_0C1C33_17sp,
                  controller: controller,
                  decoration: InputDecoration(
                    hintStyle: Styles.ts_8E9AB0_17sp,
                    hintText: hintText,
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
