import 'package:get/get.dart';
import 'package:openim/core/controller/im_controller.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

enum PhoneEmailChangeType {
  phone,
  email,
}

extension PhoneEmailChangeTypeExt on PhoneEmailChangeType {
  int get rawValue {
    switch (this) {
      case PhoneEmailChangeType.phone:
        return 0;
      case PhoneEmailChangeType.email:
        return 1;
    }
  }

  String get name {
    switch (this) {
      case PhoneEmailChangeType.phone:
        return StrRes.phoneNumber;
      case PhoneEmailChangeType.email:
        return StrRes.email;
    }
  }

  String get hintText {
    switch (this) {
      case PhoneEmailChangeType.phone:
        return StrRes.newPhone;
      case PhoneEmailChangeType.email:
        return StrRes.newEmail;
    }
  }

  String get exclusiveName {
    switch (this) {
      case PhoneEmailChangeType.phone:
        return StrRes.email;
      case PhoneEmailChangeType.email:
        return StrRes.phoneNumber;
    }
  }
}

class PhoneEmailChangeLogic extends GetxController {
  late Rx<UserFullInfo> userInfo;
  final imLogic = Get.find<IMController>();
  PhoneEmailChangeType type = PhoneEmailChangeType.phone;

  get isPhone => type == PhoneEmailChangeType.phone;

  void phoneEmailChangeDetail() {
    AppNavigator.startPhoneEmailChangeDetail(type: type);
  }

  @override
  void onInit() {
    type = Get.arguments['type'];
  }
}
