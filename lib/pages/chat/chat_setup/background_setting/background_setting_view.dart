import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'background_setting_logic.dart';

class BackgroundSettingPage extends StatelessWidget {
  final logic = Get.find<BackgroundSettingLogic>();

  BackgroundSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrLibrary.setChatBackground,
        right: ImageRes.moreBlack.toImage
          ..width = 24.w
          ..height = 24.h
          ..onTap = logic.selectPicture,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => WaterMarkBgView(
            // text: OpenIM.iMManager.uInfo.nickname ?? '',
            path: logic.chatLogic.background.value,
            child: Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
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
                            child: StrLibrary.setChatBackground.toText
                              ..style = Styles.ts_FFFFFF_16sp,
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
              ],
            ),
          )),
    );
  }
}
