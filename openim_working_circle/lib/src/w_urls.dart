import 'package:openim_common/openim_common.dart';

class WUrls {
  static const path = "office/work_moment";
  static final createMoments = "${Config.appAuthUrl}/$path/add";
  static final deleteMoments = "${Config.appAuthUrl}/$path/del";
  static final getMomentsDetail = "${Config.appAuthUrl}/$path/get";
  static final getMomentsList = "${Config.appAuthUrl}/$path/find/recv";
  static final getUserMomentsList = "${Config.appAuthUrl}/$path/find/send";
  static final likeMoments = "${Config.appAuthUrl}/$path/like";
  static final commentMoments = "${Config.appAuthUrl}/$path/comment/add";
  static final deleteComment = "${Config.appAuthUrl}/$path/comment/del";
  static final getInteractiveLogs = '${Config.appAuthUrl}/$path/logs';
  static final clearUnreadCount = '${Config.appAuthUrl}/$path/unread/clear';
  static final getUnreadCount = '${Config.appAuthUrl}/$path/unread/count';
}
