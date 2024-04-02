import 'package:get/get.dart';

import '../pages/detail/detail_binding.dart';
import '../pages/detail/detail_view.dart';
import '../pages/circle_message/circle_message_binding.dart';
import '../pages/circle_message/circle_message_view.dart';
import '../pages/publish/preview_selected_picture/preview_selected_picture_binding.dart';
import '../pages/publish/preview_selected_picture/preview_selected_picture_view.dart';
import '../pages/publish/preview_selected_video/preview_selected_video_binding.dart';
import '../pages/publish/preview_selected_video/preview_selected_video_view.dart';
import '../pages/publish/publish_binding.dart';
import '../pages/publish/publish_view.dart';
import '../pages/publish/who_can_watch/who_can_watch_binding.dart';
import '../pages/publish/who_can_watch/who_can_watch_view.dart';
import '../pages/user_work_moments_list/user_work_moments_list_binding.dart';
import '../pages/user_work_moments_list/user_work_moments_list_view.dart';
import '../pages/visible_users_list/visible_users_list_binding.dart';
import '../pages/visible_users_list/visible_users_list_view.dart';
import '../pages/work_moments_list/work_moments_list_binding.dart';
import '../pages/work_moments_list/work_moments_list_view.dart';
part 'circle_routes.dart';

class CirclePages {
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
        preventDuplicates: preventDuplicates,
      );

  static final pages = <GetPage>[
    _pageBuilder(
      name: CircleRoutes.circleMomentsList,
      page: () => WorkMomentsListPage(),
      binding: WorkMomentsListBinding(),
    ),
    _pageBuilder(
      name: CircleRoutes.userCircleMomentsList,
      page: () => UserWorkMomentsListPage(),
      binding: UserWorkMomentsListBinding(),
    ),
    _pageBuilder(
      name: CircleRoutes.publishCircleMoments,
      page: () => PublishPage(),
      binding: PublishBinding(),
    ),
    _pageBuilder(
      name: CircleRoutes.previewSelectedPicture,
      page: () => PreviewSelectedPicturePage(),
      binding: PreviewSelectedPictureBinding(),
    ),
    _pageBuilder(
      name: CircleRoutes.previewSelectedVideo,
      page: () => PreviewSelectedVideoPage(),
      binding: PreviewSelectedVideoBinding(),
    ),
    _pageBuilder(
      name: CircleRoutes.whoCanWatch,
      page: () => WhoCanWatchPage(),
      binding: WhoCanWatchBinding(),
    ),
    _pageBuilder(
      name: CircleRoutes.likeOrCommentMessage,
      page: () => CircleMessagePage(),
      binding: CircleMessageBinding(),
    ),
    _pageBuilder(
      name: CircleRoutes.circleMomentsDetail,
      page: () => MomentsDetailPage(),
      binding: MomentsDetailBinding(),
    ),
    _pageBuilder(
      name: CircleRoutes.visibleUsersList,
      page: () => VisibleUsersListPage(),
      binding: VisibleUsersListBinding(),
    ),
  ];
}
