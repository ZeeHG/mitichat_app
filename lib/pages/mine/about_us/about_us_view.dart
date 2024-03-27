import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miti_common/miti_common.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
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
                      ..onDoubleTap = logic.showDebug,
                    10.verticalSpace,
                    '${logic.version.value}(${logic.buildNumber.value})'.toText
                      ..style = Styles.ts_333333_14sp,
                    16.verticalSpace,
                    buildItem(
                        label: StrLibrary.uploadImLog, onTap: logic.uploadLogs),
                    ...(logic.debugMode.value
                        ? [
                            buildItem(
                                label: StrLibrary.uploadImLogByDate,
                                onTap: logic.uploadLogsByDate),
                            buildItem(
                                label: StrLibrary.uploadAppLog,
                                onTap: logic.uploadAppLogs),
                            buildItem(
                                label: StrLibrary.uploadAppLogByDate,
                                onTap: logic.uploadAppLogsByDate),
                            buildItem(
                                label: "cid",
                                onTap: () {
                                  MitiUtils.copy(
                                      text: logic.cid.value.isEmpty
                                          ? "cid"
                                          : logic.cid.value);
                                }),
                            buildItem(
                                label: "自启动设置1(安卓)",
                                onTap: () => DisableBatteryOptimization
                                    .showEnableAutoStartSettings(
                                        "启用自动启动", "按照步骤操作并禁用优化以使该应用程序顺利运行")),
                            buildItem(
                                label: "自启动设置2(安卓)",
                                onTap: () => DisableBatteryOptimization
                                    .showDisableAllOptimizationsSettings(
                                        "启用自动启动",
                                        "按照步骤操作并启用此应用程序的自动启动",
                                        "您的设备有额外的电池优化",
                                        "按照步骤操作并禁用优化以使该应用程序顺利运行")),
                            buildItem(
                                label: "自启动设置3(安卓)",
                                onTap: () => getAutoStartPermission()),
                            buildItem(
                                label: "跳转应用设置",
                                onTap: () => Permissions.openSettings()),
                            buildItem(
                                label: "媒体权限",
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
                                  showToast(str);
                                }),
                            buildItem(
                                label: "媒体权限+存储(13-)",
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
                                  showToast(str);
                                }),
                            buildItem(
                                label: "打开相册",
                                onTap: () async {
                                  picker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                }),
                            buildItem(
                                label: "清除翻译缓存",
                                onTap: () =>
                                    translateLogic.clearAllTranslateMsgCache()),
                            buildItem(
                                label: "重置所有翻译配置",
                                onTap: () {
                                  translateLogic.clearAllTranslateConfig();
                                }),
                            buildItem(
                                label: "清除tts缓存",
                                onTap: () => ttsLogic.clearAllTtsMsgCache()),
                            buildItem(
                                label: "聊天md",
                                showArrow: false,
                                showSwitch: true,
                                switchValue: betaTestLogic.openChatMd.value,
                                onChange: (bool) =>
                                    betaTestLogic.setOpenChatMd(bool)),
                          ]
                        : [])
                  ],
                ),
              ),
            ],
          )),
        ));
  }

  Widget buildItem({
    required String label,
    bool showArrow = true,
    Function()? onTap,
    bool showSwitch = false,
    bool switchValue = false,
    Function(bool)? onChange,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap?.call(),
      child: Container(
        height: 57.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          decoration: BoxDecoration(
              border: BorderDirectional(
                  top: BorderSide(width: 0.5.h, color: Styles.c_E8EAEF))),
          child: Row(
            children: [
              label.toText..style = Styles.ts_333333_16sp,
              const Spacer(),
              if (showArrow)
                ImageRes.appRightArrow.toImage
                  ..width = 24.w
                  ..height = 24.h,
              if (showSwitch)
                CupertinoSwitch(
                  value: switchValue,
                  activeColor: Styles.c_07C160,
                  onChanged: (bool) => onChange?.call(bool),
                )
            ],
          ),
        ),
      ),
    );
  }
}
