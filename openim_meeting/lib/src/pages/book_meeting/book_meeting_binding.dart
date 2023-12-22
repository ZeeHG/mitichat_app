import 'package:get/get.dart';

import 'book_meeting_logic.dart';

class BookMeetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookMeetingLogic());
  }
}
