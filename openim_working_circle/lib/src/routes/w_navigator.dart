import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../pages/publish/publish_logic.dart';
import 'w_pages.dart';

class WNavigator {
  static Future<T?>? startWorkMomentsList<T>({
    String? userID,
    String? nickname,
    String? faceURL,
  }) async {
    GetTags.createMomentsTag();
    // return Get.to(
    //   () => WorkMomentsListPage(),
    //   binding: WorkMomentsListBinding(),
    //   preventDuplicates: false,
    //   arguments: {
    //     'userID': userID,
    //     'nickname': nickname,
    //     'faceURL': faceURL,
    //   },
    //   transition: Transition.cupertino,
    //   popGesture: true,
    // );
    return Get.toNamed(
      WRoutes.workMomentsList,
      arguments: {'userID': userID, 'nickname': nickname, 'faceURL': faceURL},
      preventDuplicates: false,
    );
  }

  static Future<T?>? startUserWorkMomentsList<T>({
    String? userID,
    String? nickname,
    String? faceURL,
  }) async {
    GetTags.createUserMomentsTag();
    return Get.toNamed(
      WRoutes.userWorkMomentsList,
      arguments: {'userID': userID, 'nickname': nickname, 'faceURL': faceURL},
      preventDuplicates: false,
    );
  }

  static Future<T?>? startPublishWorkMoments<T>({required PublishType type}) =>
      Get.toNamed(WRoutes.publishWorkMoments, arguments: {
        'type': type,
      });

  static Future<T?>? startPreviewSelectedPicture<T>({
    required int currentIndex,
  }) =>
      Get.toNamed(WRoutes.previewSelectedPicture, arguments: {
        'currentIndex': currentIndex,
      });

  static Future<T?>? startPreviewSelectedVideo<T>() =>
      Get.toNamed(WRoutes.previewSelectedVideo, arguments: {});

  static Future<T?>? startWhoCanWatch<T>({
    int permission = 0,
    List<dynamic> checkedList = const [],
  }) =>
      Get.toNamed(WRoutes.whoCanWatch, arguments: {
        'permission': permission,
        'checkedList': checkedList,
      });

  static Future<T?>? startLikeOrCommentMessage<T>() =>
      Get.toNamed(WRoutes.likeOrCommentMessage, arguments: {});

  static Future<T?>? startWorkMomentsDetail<T>({
    required String workMomentID,
  }) {
    GetTags.createMomentsDetailTag();
    return Get.toNamed(
      WRoutes.workMomentsDetail,
      arguments: {'workMomentID': workMomentID},
      preventDuplicates: false,
    );
  }

  static Future<T?>? startVisibleUsersList<T>({
    required WorkMoments workMoments,
  }) =>
      Get.toNamed(WRoutes.visibleUsersList, arguments: {
        'workMoments': workMoments,
      });
}
