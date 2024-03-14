import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'unlock_setup_logic.dart';

class UnlockSetupPage extends StatelessWidget {
  final logic = Get.find<UnlockSetupLogic>();

  UnlockSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.unlockSettings),
      backgroundColor: Styles.c_F7F8FA,
      body: Obx(() => Column(
            children: [
              12.verticalSpace,
              _buildItemView(
                  label: StrLibrary.password,
                  switchOn: logic.passwordEnabled.value,
                  onChanged: (_) => logic.togglePwdLock(),
                  isTopRadius: true,
                  showBorder: false),
              // _buildItemView(
              //     label: StrLibrary .faceRecognition,
              //     switchOn: logic.faceRecognitionEnabled.value,
              //     onChanged: (_) => showDeveloping(),
              //     isTopRadius: true),
              if (logic.passwordEnabled.value &&
                  (logic.isSupportedBiometric.value &&
                      logic.canCheckBiometrics.value))
                Container(
                  margin: EdgeInsets.only(left: 26.w, right: 10.w),
                  color: Styles.c_E8EAEF,
                  height: .5,
                ),
              if (logic.passwordEnabled.value &&
                  (logic.isSupportedBiometric.value &&
                      logic.canCheckBiometrics.value))
                _buildItemView(
                  label: StrLibrary.biometrics,
                  switchOn: logic.biometricsEnabled.value,
                  onChanged: (_) => logic.toggleBiometricLock(),
                  isBottomRadius: true,
                ),
            ],
          )),
    );
  }

  Widget _buildItemView({
    required String label,
    bool isTopRadius = false,
    bool isBottomRadius = false,
    bool switchOn = false,
    bool showBorder = true,
    ValueChanged<bool>? onChanged,
  }) =>
      Container(
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            height: 52.h,
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
              children: [
                label.toText..style = Styles.ts_333333_16sp,
                const Spacer(),
                CupertinoSwitch(
                  value: switchOn,
                  activeColor: Styles.c_07C160,
                  onChanged: onChanged,
                ),
              ],
            ),
          ));
}
