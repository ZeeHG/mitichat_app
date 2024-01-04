import 'config.dart';

class Urls {
  static final onlineStatus = "${Config.imApiUrl}/manager/get_users_online_status";
  static final userOnlineStatus = "${Config.imApiUrl}/user/get_users_online_status";
  static final queryAllUsers = "${Config.imApiUrl}/manager/get_all_users_uid";
  static final updateUserInfo = "${Config.appAuthUrl}/user/update";
  static final searchFriendInfo = "${Config.appAuthUrl}/friend/search";
  static final getUsersFullInfo = "${Config.appAuthUrl}/user/find/full";
  static final searchUserFullInfo = "${Config.appAuthUrl}/user/search/full";
  static final updateEmail = "${Config.appAuthUrl}/account/update_email";
  static final updatePhone = "${Config.appAuthUrl}/account/update_phone";
  

  static final getVerificationCode = "${Config.appAuthUrl}/account/code/send";
  static final checkVerificationCode = "${Config.appAuthUrl}/account/code/verify";
  static final register = "${Config.appAuthUrl}/account/register";

  static final resetPwd = "${Config.appAuthUrl}/account/password/reset";
  static final changePwd = "${Config.appAuthUrl}/account/password/change";
  static final login = "${Config.appAuthUrl}/account/login";

  static final upgrade = "${Config.appAuthUrl}/app/check";

  /// office
  static final tag = "${Config.appAuthUrl}/office/tag";
  static final getUserTags = "$tag/find/user";
  static final createTag = "$tag/add";
  static final deleteTag = "$tag/del";
  static final updateTag = "$tag/set";
  static final sendTagNotification = "$tag/send";
  static final getTagNotificationLog = "$tag/send/log";
  static final delTagNotificationLog = "$tag/send/log/del";

  /// 全局配置
  static final getClientConfig = '${Config.appAuthUrl}/client_config/get';

  /// 小程序
  static final uniMPUrl = '${Config.appAuthUrl}/applet/list';


  // 翻译
  static final translate = "${Config.appAuthUrl}/translate/do";

  static final findTranslate = "${Config.appAuthUrl}/translate/find";

  static final getTranslateConfig = "${Config.appAuthUrl}/translate/config/get";

  static final setTranslateConfig = "${Config.appAuthUrl}/translate/config/set";

  // tts
  static final tts = "${Config.appAuthUrl}/transcribe/url";

  // 删除用户
  static final deleteUser = "${Config.appAuthUrl}/account/delete";

  static final complain = "${Config.appAuthUrl}/user/report";

  static final blockMoment = "${Config.appAuthUrl}/office/work_moment/block_moment";

  static final getBlockMoment = "${Config.appAuthUrl}/office/work_moment/get_block_moment";
}
