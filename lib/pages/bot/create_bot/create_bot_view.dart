import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'create_bot_logic.dart';

class CreateBotPage extends StatelessWidget {
  final logic = Get.find<CreateBotLogic>();

  CreateBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TitleBar.back(
          title: StrRes.createBot,
        ),
        backgroundColor: Styles.c_F7F8FA,
        body: IntrinsicHeight(
          child: Container(
            color: Styles.c_FFFFFF,
            margin: EdgeInsets.only(top: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                _buildItemView(
                    label: StrRes.nicknameAndAvatar,
                    showBorder: false,
                    onTap: logic.changeBotInfo,
                    rightWeight: ImageRes.appBot.toImage
                      ..width = 38.w
                      ..height = 38.h),
                _buildItemView(label: StrRes.training, onTap: logic.trainBot),
              ],
            ),
          ),
        ));
  }

  Widget _buildItemView({
    required String label,
    bool showRightArrow = true,
    bool showBorder = true,
    Widget? rightWeight,
    Function()? onTap,
  }) =>
      GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.translucent,
          child: Container(
              constraints: BoxConstraints(minHeight: 50.h),
              decoration: BoxDecoration(
                color: Styles.c_FFFFFF,
                border: Border(
                  top: BorderSide(
                    color: Styles.c_F1F2F6,
                    width: showBorder ? 1.h : 0,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  label.toText..style = Styles.ts_333333_14sp,
                  Spacer(),
                  if (null != rightWeight) rightWeight,
                  if (showRightArrow)
                    ImageRes.appRightArrow.toImage
                      ..width = 24.w
                      ..height = 24.h,
                ],
              )));
}
