import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miti_common/miti_common.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../../../routes/app_navigator.dart';
import 'about_us_logic.dart';

class AboutUsPage extends StatelessWidget {
  final logic = Get.find<AboutUsLogic>();
  final translateLogic = Get.find<TranslateLogic>();
  final ttsLogic = Get.find<TtsLogic>();
  final betaTestLogic = Get.find<BetaTestLogic>();
  static final ImagePicker picker = ImagePicker();

  AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(title: StrLibrary.aboutUs),
          backgroundColor: Styles.c_F8F9FA,
          body: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Styles.c_FFFFFF,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 10.h,
                ),
                child: Column(
                  children: [
                    ImageRes.splashLogo.toImage
                      ..width = 78.w
                      ..height = 78.h
                      ..onDoubleTap = logic.startDev,
                    10.verticalSpace,
                    '${logic.version.value}(${logic.buildNumber.value})'.toText
                      ..style = Styles.ts_333333_14sp,
                    16.verticalSpace,
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      color: Styles.c_E8EAEF,
                      height: .5,
                    ),
                    if (Platform.isAndroid)
                      // GestureDetector(
                      //   behavior: HitTestBehavior.translucent,
                      //   onTap: logic.checkUpdate,
                      //   child: Container(
                      //     height: 57.h,
                      //     padding: EdgeInsets.symmetric(horizontal: 16.w),
                      //     child: Row(
                      //       children: [
                      //         StrLibrary .checkNewVersion.toText
                      //           ..style = Styles.ts_333333_16sp,
                      //         const Spacer(),
                      //         ImageRes.appRightArrow.toImage
                      //           ..width = 24.w
                      //           ..height = 24.h,
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: logic.uploadLogs,
                        child: Container(
                          height: 57.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              StrLibrary.uploadImLog.toText
                                ..style = Styles.ts_333333_16sp,
                              const Spacer(),
                              ImageRes.appRightArrow.toImage
                                ..width = 24.w
                                ..height = 24.h,
                            ],
                          ),
                        ),
                      ),
                    ...(logic.showDev.value
                        ? [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => logic.uploadLogsByDate(),
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    (StrLibrary.uploadImLogByDate).toText
                                      ..style = Styles.ts_333333_16sp,
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: logic.uploadAppLogs,
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    StrLibrary.uploadAppLog.toText
                                      ..style = Styles.ts_333333_16sp,
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: logic.uploadAppLogsByDate,
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    StrLibrary.uploadAppLogByDate.toText
                                      ..style = Styles.ts_333333_16sp,
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                IMUtils.copy(
                                    text: logic.cid.value == ""
                                        ? "cid"
                                        : logic.cid.value);
                              },
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "cid",
                                      style: Styles.ts_333333_16sp,
                                    ),
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => Permissions.requestBasePermissions(),
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "权限(安卓)",
                                      style: Styles.ts_333333_16sp,
                                    ),
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => getAutoStartPermission(),
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "权限2(安卓)",
                                      style: Styles.ts_333333_16sp,
                                    ),
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => DisableBatteryOptimization
                                  .showEnableAutoStartSettings(
                                      "启用自动启动", "按照步骤操作并禁用优化以使该应用程序顺利运行"),
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "权限3(安卓)",
                                      style: Styles.ts_333333_16sp,
                                    ),
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => DisableBatteryOptimization
                                  .showDisableAllOptimizationsSettings(
                                      "启用自动启动",
                                      "按照步骤操作并启用此应用程序的自动启动",
                                      "您的设备有额外的电池优化",
                                      "按照步骤操作并禁用优化以使该应用程序顺利运行"),
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "权限4(安卓)",
                                      style: Styles.ts_333333_16sp,
                                    ),
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => Permissions.openSettings(),
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "手动自启动,电池,后台,后台弹出(安卓)",
                                      style: Styles.ts_333333_16sp,
                                    ),
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => AppNavigator.startMain(index: 4),
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "xhs",
                                      style: Styles.ts_333333_16sp,
                                    ),
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () =>
                                  translateLogic.clearAllTranslateMsgCache(),
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "清除翻译缓存",
                                      style: Styles.ts_333333_16sp,
                                    ),
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                translateLogic.clearAllTranslateConfig();
                              },
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "重置全部翻译配置",
                                      style: Styles.ts_333333_16sp,
                                    ),
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 57.h,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                children: [
                                  Text(
                                    "开启md",
                                    style: Styles.ts_333333_16sp,
                                  ),
                                  const Spacer(),
                                  CupertinoSwitch(
                                    value: betaTestLogic.openChatMd.value,
                                    activeColor: Styles.c_07C160,
                                    onChanged: (open) =>
                                        betaTestLogic.setOpenChatMd(open),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                await Permissions.batchRequestPermissions([
                                  Permission.photos,
                                  Permission.audio,
                                  Permission.videos
                                ]);
                                final status =
                                    await Permissions.getPermissionsStatus([
                                  Permission.photos,
                                  Permission.audio,
                                  Permission.videos
                                ]);
                                final str = status
                                    .map((item) => item.toString())
                                    .toList()
                                    .join(",");
                                IMViews.showToast(str);
                              },
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "照片/音频/视频(特殊机型/13+)",
                                      style: Styles.ts_333333_16sp,
                                    ),
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                await Permissions.storage(
                                  null,
                                  permissions: [
                                    Permission.photos,
                                    Permission.videos,
                                    Permission.audio
                                  ],
                                );
                                final status =
                                    await Permissions.getPermissionsStatus([
                                  Permission.photos,
                                  Permission.audio,
                                  Permission.videos,
                                  Permission.storage
                                ]);
                                final str = status
                                    .map((item) => item.toString())
                                    .toList()
                                    .join(",");
                                IMViews.showToast(str);
                              },
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "全机型媒体权限",
                                      style: Styles.ts_333333_16sp,
                                    ),
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                              },
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "打开相册",
                                      style: Styles.ts_333333_16sp,
                                    ),
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => ttsLogic.clearAllTtsMsgCache(),
                              child: Container(
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "清除tts缓存",
                                      style: Styles.ts_333333_16sp,
                                    ),
                                    const Spacer(),
                                    ImageRes.appRightArrow.toImage
                                      ..width = 24.w
                                      ..height = 24.h,
                                  ],
                                ),
                              ),
                            ),
                          ]
                        : [])
                  ],
                ),
              ),
            ],
          )),
        ));
  }
}
