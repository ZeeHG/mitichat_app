import 'package:get/get.dart';

import '../pages/book_meeting/book_meeting_binding.dart';
import '../pages/book_meeting/book_meeting_view.dart';
import '../pages/join_meeting/join_meeting_binding.dart';
import '../pages/join_meeting/join_meeting_view.dart';
import '../pages/meeting/meeting_binding.dart';
import '../pages/meeting/meeting_view.dart';
import '../pages/meeting_detail/meeting_detail_binding.dart';
import '../pages/meeting_detail/meeting_detail_view.dart';

part 'm_routes.dart';

class MPages {
  /// 左滑关闭页面用于android
  static _pageBuilder({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
    bool preventDuplicates = true,
  }) =>
      GetPage(
        name: name,
        page: page,
        binding: binding,
        transition: Transition.cupertino,
        popGesture: true,
        preventDuplicates: true,
      );

  static final pages = <GetPage>[
    _pageBuilder(
      name: MRoutes.meeting,
      page: () => MeetingPage(),
      binding: MeetingBinding(),
    ),
    _pageBuilder(
      name: MRoutes.joinMeeting,
      page: () => JoinMeetingPage(),
      binding: JoinMeetingBinding(),
    ),
    _pageBuilder(
      name: MRoutes.bookMeeting,
      page: () => BookMeetingPage(),
      binding: BookMeetingBinding(),
    ),
    _pageBuilder(
      name: MRoutes.meetingDetail,
      page: () => MeetingDetailPage(),
      binding: MeetingDetailBinding(),
    ),
  ];
}
