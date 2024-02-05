import 'config.dart';

class Urls {
  static String get onlineStatus =>
      "${Config.imApiUrl}/manager/get_users_online_status";
  static String get userOnlineStatus =>
      "${Config.imApiUrl}/user/get_users_online_status";
  static String get queryAllUsers => "${Config.imApiUrl}/manager/get_all_users_uid";
  static String get updateUserInfo => "${Config.appAuthUrl}/user/update";
  static String get searchFriendInfo => "${Config.appAuthUrl}/friend/search";
  static String get getUsersFullInfo => "${Config.appAuthUrl}/user/find/full";
  static String get searchUserFullInfo => "${Config.appAuthUrl}/user/search/full";
  static String get updateEmail => "${Config.appAuthUrl}/account/update_email";
  static String get updatePhone => "${Config.appAuthUrl}/account/update_phone";

  static String get getVerificationCode => "${Config.appAuthUrl}/account/code/send";
  static String get checkVerificationCode =>
      "${Config.appAuthUrl}/account/code/verify";
  static String get register => "${Config.appAuthUrl}/account/register";

  static String get resetPwd => "${Config.appAuthUrl}/account/password/reset";
  static String get changePwd => "${Config.appAuthUrl}/account/password/change";
  static String get login => "${Config.appAuthUrl}/account/login";

  static String get upgrade => "${Config.appAuthUrl}/app/check";

  /// office
  static String get tag => "${Config.appAuthUrl}/office/tag";
  static String get getUserTags => "$tag/find/user";
  static String get createTag => "$tag/add";
  static String get deleteTag => "$tag/del";
  static String get updateTag => "$tag/set";
  static String get sendTagNotification => "$tag/send";
  static String get getTagNotificationLog => "$tag/send/log";
  static String get delTagNotificationLog => "$tag/send/log/del";

  /// 全局配置
  static String get getClientConfig => '${Config.appAuthUrl}/client_config/get';

  /// 小程序
  static String get uniMPUrl => '${Config.appAuthUrl}/applet/list';

  // 翻译
  static String get translate => "${Config.appAuthUrl}/translate/do";

  static String get findTranslate => "${Config.appAuthUrl}/translate/find";

  static String get getTranslateConfig => "${Config.appAuthUrl}/translate/config/get";

  static String get setTranslateConfig => "${Config.appAuthUrl}/translate/config/set";

  // tts
  static String get tts => "${Config.appAuthUrl}/transcribe/url";

  // 删除用户
  static String get deleteUser => "${Config.appAuthUrl}/account/delete";

  static String get complain => "${Config.appAuthUrl}/user/report";

  static String get blockMoment =>
      "${Config.appAuthUrl}/office/work_moment/block_moment";

  static String get getBlockMoment =>
      "${Config.appAuthUrl}/office/work_moment/get_block_moment";

  static String get checkServerValid => '/client_config/get';

  static String get getBots => '${Config.appAuthUrl}/bot/find/public';

  static String get getMyAi => '${Config.appAuthUrl}/bot/find/mine';

  static String get getKnowledgeFiles => '${Config.appAuthUrl}/bot/get_knowledge_files';

  static String get addKnowledge =>
      '${Config.appAuthUrl}/bot/add_knowledge';

  static String get getMyAiTask =>
      '${Config.appAuthUrl}/bot/task/get/mine';
}
