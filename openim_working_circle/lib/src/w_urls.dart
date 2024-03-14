import 'package:miti_common/miti_common.dart';

class WUrls {
  static String get path => "office/work_moment";
  static String get createMoments => "${Config.appAuthUrl}/$path/add";
  static String get deleteMoments => "${Config.appAuthUrl}/$path/del";
  static String get getMomentsDetail => "${Config.appAuthUrl}/$path/get";
  static String get getMomentsList => "${Config.appAuthUrl}/$path/find/recv";
  static String get getUserMomentsList =>
      "${Config.appAuthUrl}/$path/find/send";
  static String get likeMoments => "${Config.appAuthUrl}/$path/like";
  static String get commentMoments => "${Config.appAuthUrl}/$path/comment/add";
  static String get deleteComment => "${Config.appAuthUrl}/$path/comment/del";
  static String get getInteractiveLogs => '${Config.appAuthUrl}/$path/logs';
  static String get clearUnreadCount =>
      '${Config.appAuthUrl}/$path/unread/clear';
  static String get getUnreadCount => '${Config.appAuthUrl}/$path/unread/count';
}
