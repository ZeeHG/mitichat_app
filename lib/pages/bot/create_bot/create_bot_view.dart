import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'create_bot_logic.dart';

class CreateBotPage extends StatelessWidget {
  final logic = Get.find<CreateBotLogic>();

  CreateBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TitleBar.back(
          title: StrLibrary.createBot,
        ),
        backgroundColor: StylesLibrary.c_F7F8FA,
        body: IntrinsicHeight(
          child: Container(
            color: StylesLibrary.c_FFFFFF,
            margin: EdgeInsets.only(top: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                _buildItemView(
                    label: StrLibrary.nicknameAndAvatar,
                    showBorder: false,
                    onTap: logic.changeBotInfo,
                    rightWeight: ImageLibrary.appBot.toImage
                      ..width = 38.w
                      ..height = 38.h),
                _buildItemView(
                    label: StrLibrary.training, onTap: logic.trainBot),
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
                color: StylesLibrary.c_FFFFFF,
                border: Border(
                  top: BorderSide(
                    color: StylesLibrary.c_F1F2F6,
                    width: showBorder ? 1.h : 0,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  label.toText..style = StylesLibrary.ts_333333_14sp,
                  const Spacer(),
                  if (null != rightWeight) rightWeight,
                  if (showRightArrow)
                    ImageLibrary.appRightArrow.toImage
                      ..width = 24.w
                      ..height = 24.h,
                ],
              )));
}
