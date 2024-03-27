import 'package:get/get.dart';
import 'forget_pwd_logic.dart';

class ForgetPwdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgetPwdLogic());
  }
}
