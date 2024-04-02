import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../pages/publish/publish_logic.dart';
import 'circle_pages.dart';

class CircleNavigator {
  static Future<T?>? startWorkMomentsList<T>({
    String? userID,
    String? nickname,
    String? faceURL,
  }) async {
    GetTags.createMomentsTag();
    return Get.toNamed(
      CircleRoutes.circleMomentsList,
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
      CircleRoutes.userCircleMomentsList,
      arguments: {'userID': userID, 'nickname': nickname, 'faceURL': faceURL},
      preventDuplicates: false,
    );
  }

  static Future<T?>? startPublishWorkMoments<T>({required PublishType type}) =>
      Get.toNamed(CircleRoutes.publishCircleMoments, arguments: {
        'type': type,
      });

  static Future<T?>? startPreviewSelectedPicture<T>({
    required int currentIndex,
  }) =>
      Get.toNamed(CircleRoutes.previewSelectedPicture, arguments: {
        'currentIndex': currentIndex,
      });

  static Future<T?>? startPreviewSelectedVideo<T>() =>
      Get.toNamed(CircleRoutes.previewSelectedVideo, arguments: {});

  static Future<T?>? startWhoCanWatch<T>({
    int permission = 0,
    List<dynamic> checkedList = const [],
  }) =>
      Get.toNamed(CircleRoutes.whoCanWatch, arguments: {
        'permission': permission,
        'checkedList': checkedList,
      });

  static Future<T?>? startLikeOrCommentMessage<T>() =>
      Get.toNamed(CircleRoutes.likeOrCommentMessage, arguments: {});

  static Future<T?>? startMomentsDetail<T>({
    required String workMomentID,
  }) {
    GetTags.createMomentsDetailTag();
    return Get.toNamed(
      CircleRoutes.circleMomentsDetail,
      arguments: {'workMomentID': workMomentID},
      preventDuplicates: false,
    );
  }

  static Future<T?>? startVisibleUsersList<T>({
    required WorkMoments workMoments,
  }) =>
      Get.toNamed(CircleRoutes.visibleUsersList, arguments: {
        'workMoments': workMoments,
      });
}
