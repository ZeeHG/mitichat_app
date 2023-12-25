import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'set_font_size_logic.dart';

class SetFontSizePage extends StatelessWidget {
  final logic = Get.find<SetFontSizeLogic>();

  SetFontSizePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.fontSize,
        right: StrRes.save.toText..onTap = logic.saveFactor,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 42.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ChatBubble(
                      bubbleType: BubbleType.send,
                      alignment: null,
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Obx(() => '预览字体大小'.toText
                        ..style = Styles.ts_FFFFFF_16sp
                        ..textScaleFactor = logic.factor.value),
                    )
                  ],
                ),
                10.horizontalSpace,
                AvatarView(
                  text: OpenIM.iMManager.userInfo.nickname,
                  url: OpenIM.iMManager.userInfo.faceURL ?? "",
                  width: 42.w,
                  height: 42.h,
                ),
              ],
            ),
          ),
          const Spacer(),
          Obx(() => FontSizeSlider(
                value: logic.factor.value,
                onChanged: logic.changed,
              )),
        ],
      ),
    );
  }
}
