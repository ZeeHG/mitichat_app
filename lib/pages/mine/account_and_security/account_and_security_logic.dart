import 'package:get/get.dart';
import 'package:openim/core/controller/im_controller.dart';
import 'package:openim/pages/mine/phone_email_change/phone_email_change_logic.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

class AccountAndSecurityLogic extends GetxController {

  late Rx<UserFullInfo> userInfo;
  final imLogic = Get.find<IMController>();

  void changePwd() => AppNavigator.startChangePassword();

  void phoneEmailChange({required PhoneEmailChangeType type}) => AppNavigator.startPhoneEmailChange(type: type);

  void deleteUser() => AppNavigator.startDeleteUser();

}
