import 'package:get/get.dart';
import 'package:miti/core/controller/im_controller.dart';
import 'package:miti/pages/mine/phone_email_change/phone_email_change_logic.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

class AccountAndSecurityLogic extends GetxController {
  late Rx<UserFullInfo> userInfo;
  final imLogic = Get.find<IMController>();

  void changePwd() => AppNavigator.startChangePassword();

  void phoneEmailChange({required PhoneEmailChangeType type}) =>
      AppNavigator.startPhoneEmailChange(type: type);

  void deleteUser() => AppNavigator.startDeleteUser();

  void accountManage() => AppNavigator.startAccountManage();
}
