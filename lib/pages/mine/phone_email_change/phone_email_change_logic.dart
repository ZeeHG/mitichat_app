import 'package:get/get.dart';
import 'package:miti/core/controller/im_controller.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

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
        return StrLibrary.phoneNumber;
      case PhoneEmailChangeType.email:
        return StrLibrary.email;
    }
  }

  String get hintText {
    switch (this) {
      case PhoneEmailChangeType.phone:
        return StrLibrary.newPhone;
      case PhoneEmailChangeType.email:
        return StrLibrary.newEmail;
    }
  }

  String get exclusiveName {
    switch (this) {
      case PhoneEmailChangeType.phone:
        return StrLibrary.email;
      case PhoneEmailChangeType.email:
        return StrLibrary.phoneNumber;
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
