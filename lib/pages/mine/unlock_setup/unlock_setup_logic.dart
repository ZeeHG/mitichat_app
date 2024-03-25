import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:miti_common/miti_common.dart';

class UnlockSetupLogic extends GetxController {
  final passwordEnabled = false.obs;
  final faceRecognitionEnabled = false.obs;
  final fingerprintEnabled = false.obs;
  final gestureEnabled = false.obs;
  final biometricsEnabled = false.obs;
  final isSupportedBiometric = false.obs;
  final canCheckBiometrics = false.obs;
  String? lockScreenPwd;
  final auth = LocalAuthentication();
  late List<BiometricType> availableBiometrics;

  @override
  void onInit() {
    checkingSupported();
    lockScreenPwd = DataSp.getLockScreenPassword();
    biometricsEnabled.value = DataSp.isEnabledBiometric() == true;
    passwordEnabled.value = lockScreenPwd != null;
    super.onInit();
  }

  void checkingSupported() async {
    isSupportedBiometric.value = await auth.isDeviceSupported();
    canCheckBiometrics.value = await auth.canCheckBiometrics;
    availableBiometrics = await auth.getAvailableBiometrics();

    if (availableBiometrics.isNotEmpty) {
      // Some biometrics are enrolled.
    }

    if (availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.weak)) {
      // Specific types of biometrics are available.
      // Use checks like this with caution!
    }
  }

  void toggleBiometricLock() async {
    if (biometricsEnabled.value) {
      await DataSp.closeBiometric();
      biometricsEnabled.value = false;
    } else {
      final didAuthenticate = await MitiUtils.checkingBiometric(auth);
      if (didAuthenticate) {
        await DataSp.openBiometric();
        biometricsEnabled.value = true;
      }
    }
  }

  void togglePwdLock() {
    if (passwordEnabled.value) {
      closePwdLock();
    } else {
      openPwdLock();
    }
  }

  void toggleFaceLock() {
    faceRecognitionEnabled.value = !faceRecognitionEnabled.value;
  }

  void closePwdLock() {
    screenLock(
      context: Get.context!,
      correctString: lockScreenPwd!,
      title: StrLibrary.plsEnterPwd.toText..style = Styles.ts_FFFFFF_17sp,
      onUnlocked: () async {
        await DataSp.clearLockScreenPassword();
        await DataSp.closeBiometric();
        passwordEnabled.value = false;
        biometricsEnabled.value = false;
        Get.back();
      },
    );
  }

  void openPwdLock() {
    final controller = InputController();
    screenLockCreate(
      context: Get.context!,
      inputController: controller,
      title: StrLibrary.plsEnterNewPwd.toText..style = Styles.ts_FFFFFF_17sp,
      confirmTitle: StrLibrary.plsConfirmNewPwd.toText
        ..style = Styles.ts_FFFFFF_17sp,
      cancelButton: StrLibrary.cancel.toText..style = Styles.ts_FFFFFF_17sp,
      onConfirmed: (matchedText) async {
        lockScreenPwd = matchedText;
        await DataSp.putLockScreenPassword(matchedText);
        passwordEnabled.value = true;
        Get.back();
      },
      footer: TextButton(
        onPressed: () {
          // Release the confirmation state and return to the initial input state.
          controller.unsetConfirmed();
        },
        child: StrLibrary.reset.toText..style = Styles.ts_8443F8_17sp,
      ),
    );
  }
}
