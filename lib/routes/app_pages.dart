import 'package:get/get.dart';
import 'package:miti/pages/chat/chat_setting/chat_setting_binding.dart';
import 'package:miti/pages/chat/chat_setting/chat_setting_view.dart';
import 'package:miti/pages/chat/complaint/complaint_binding.dart';
import 'package:miti/pages/chat/complaint/complaint_view.dart';
import 'package:miti/pages/contacts/ai_friend_list/ai_friend_list_binding.dart';
import 'package:miti/pages/contacts/ai_friend_list/ai_friend_list_view.dart';
import 'package:miti/pages/contacts/ai_friend_list/search_ai_friend/search_ai_friend_binding.dart';
import 'package:miti/pages/contacts/ai_friend_list/search_ai_friend/search_ai_friend_view.dart';
import 'package:miti/pages/contacts/friend_permission_setting/friend_permission_setting_view.dart';
import 'package:miti/pages/contacts/my_ai/knowledgebase_files/knowledgebase_files_binding.dart';
import 'package:miti/pages/contacts/my_ai/knowledgebase_files/knowledgebase_files_view.dart';
import 'package:miti/pages/contacts/my_ai/my_ai_binding.dart';
import 'package:miti/pages/contacts/my_ai/my_ai_view.dart';
import 'package:miti/pages/contacts/my_ai/search_my_ai/search_my_ai_binding.dart';
import 'package:miti/pages/contacts/my_ai/search_my_ai/search_my_ai_view.dart';
import 'package:miti/pages/contacts/my_ai/train_ai/train_ai_binding.dart';
import 'package:miti/pages/contacts/my_ai/train_ai/train_ai_view.dart';
import 'package:miti/pages/contacts/request_records/request_records_binding.dart';
import 'package:miti/pages/contacts/request_records/request_records_view.dart';
import 'package:miti/pages/contacts/select_contacts/group_list/group_list_binding.dart';
import 'package:miti/pages/contacts/select_contacts/group_list/group_list_view.dart';
import 'package:miti/pages/contacts/select_contacts/group_list/search_group/search_group_binding.dart';
import 'package:miti/pages/contacts/select_contacts/group_list/search_group/search_group_view.dart';
// import 'package:miti/pages/contacts/friend_permission_setting_setting/friend_permission_setting_setting_binding.dart';
// import 'package:miti/pages/contacts/friend_permission_setting_setting/friend_permission_setting_setting_view.dart';
import 'package:miti/pages/mine/account_and_security/account_and_security_binding.dart';
import 'package:miti/pages/mine/account_and_security/account_and_security_view.dart';
import 'package:miti/pages/mine/account_manage/account_manage_binding.dart';
import 'package:miti/pages/mine/account_manage/account_manage_view.dart';
import 'package:miti/pages/mine/delete_user/delete_user_binding.dart';
import 'package:miti/pages/mine/delete_user/delete_user_view.dart';
import 'package:miti/pages/mine/my_points/invite/invite_binding.dart';
import 'package:miti/pages/mine/my_points/invite/invites_view.dart';
import 'package:miti/pages/mine/my_points/invite_records/invite_records_binding.dart';
import 'package:miti/pages/mine/my_points/invite_records/invite_records_view.dart';
import 'package:miti/pages/mine/my_points/my_points_binding.dart';
import 'package:miti/pages/mine/my_points/my_points_view.dart';
import 'package:miti/pages/mine/my_points/point_records/point_records_binding.dart';
import 'package:miti/pages/mine/my_points/point_records/point_records_view.dart';
import 'package:miti/pages/mine/my_points/point_rules/point_rules_binding.dart';
import 'package:miti/pages/mine/my_points/point_rules/point_rules_view.dart';
import 'package:miti/pages/mine/phone_email_change/phone_email_change_binding.dart';
import 'package:miti/pages/mine/phone_email_change/phone_email_change_view.dart';
import 'package:miti/pages/mine/phone_email_change_detail/phone_email_change_detail_binding.dart';
import 'package:miti/pages/mine/phone_email_change_detail/phone_email_change_detail_view.dart';
import 'package:miti/pages/preview_media/preview_media_binding.dart';
import 'package:miti/pages/preview_media/preview_media_view.dart';
import 'package:miti/pages/privacy_policy/privacy_policy_binding.dart';
import 'package:miti/pages/privacy_policy/privacy_policy_view.dart';
import 'package:miti/pages/terms_of_server/terms_of_server_binding.dart';
import 'package:miti/pages/terms_of_server/terms_of_server_view.dart';
import 'package:miti/pages/welcomePage/welcomePage_view.dart';
import 'package:miti/pages/xhs/xhs_binding.dart';
import 'package:miti/pages/xhs/xhs_moment_detail/xhs_moment_detail_binding.dart';
import 'package:miti/pages/xhs/xhs_moment_detail/xhs_moment_detail_view.dart';
import 'package:miti/pages/xhs/xhs_view.dart';
// import 'package:openim_meeting/openim_meeting.dart';
import 'package:miti_circle/miti_circle.dart';

import '../pages/bot/bot_binding.dart';
import '../pages/bot/bot_view.dart';
import '../pages/bot/change_bot_info/change_bot_info_binding.dart';
import '../pages/bot/change_bot_info/change_bot_info_view.dart';
import '../pages/bot/create_bot/create_bot_binding.dart';
import '../pages/bot/create_bot/create_bot_view.dart';
import '../pages/bot/training_bot/training_bot_binding.dart';
import '../pages/bot/training_bot/training_bot_view.dart';
import '../pages/chat/chat_binding.dart';
import '../pages/chat/chat_setting/emoji_favorite_manage/emoji_favorite_manage_binding.dart';
import '../pages/chat/chat_setting/emoji_favorite_manage/emoji_favorite_manage_view.dart';
import '../pages/chat/chat_setting/chat_history/file/file_binding.dart';
import '../pages/chat/chat_setting/chat_history/file/file_view.dart';
import '../pages/chat/chat_setting/chat_history/media/media_binding.dart';
import '../pages/chat/chat_setting/chat_history/media/media_view.dart';
import '../pages/chat/chat_setting/chat_history/preview_chat_history/preview_chat_history_binding.dart';
import '../pages/chat/chat_setting/chat_history/preview_chat_history/preview_chat_history_view.dart';
import '../pages/chat/chat_setting/chat_history/chat_history_binding.dart';
import '../pages/chat/chat_setting/chat_history/chat_history_view.dart';
import '../pages/chat/chat_setting/background_setting/background_setting_binding.dart';
import '../pages/chat/chat_setting/background_setting/background_setting_view.dart';
// import '../pages/chat/chat_setting/set_font_size/set_font_size_binding.dart';
// import '../pages/chat/chat_setting/set_font_size/set_font_size_view.dart';
import '../pages/chat/chat_view.dart';
import '../pages/chat/group_setting/edit_announcement/edit_announcement_binding.dart';
import '../pages/chat/group_setting/edit_announcement/edit_announcement_view.dart';
import '../pages/chat/group_setting/edit_name/edit_name_binding.dart';
import '../pages/chat/group_setting/edit_name/edit_name_view.dart';
import '../pages/chat/group_setting/group_manage/group_manage_binding.dart';
import '../pages/chat/group_setting/group_manage/group_manage_view.dart';
import '../pages/chat/group_setting/group_member_list/group_member_list_binding.dart';
import '../pages/chat/group_setting/group_member_list/group_member_list_view.dart';
import '../pages/chat/group_setting/group_member_list/search_group_member/search_group_member_binding.dart';
import '../pages/chat/group_setting/group_member_list/search_group_member/search_group_member_view.dart';
import '../pages/chat/group_setting/group_qrcode/group_qrcode_binding.dart';
import '../pages/chat/group_setting/group_qrcode/group_qrcode_view.dart';
import '../pages/chat/group_setting/group_read_list/group_read_list_binding.dart';
import '../pages/chat/group_setting/group_read_list/group_read_list_view.dart';
import '../pages/chat/group_setting/group_setting_binding.dart';
import '../pages/chat/group_setting/group_setting_view.dart';
import '../pages/chat/group_setting/set_mute_for_memeber/set_mute_for_member_binding.dart';
import '../pages/chat/group_setting/set_mute_for_memeber/set_mute_for_member_view.dart';
import '../pages/contacts/search_add_contacts/search_add_contacts_binding.dart';
import '../pages/contacts/search_add_contacts/search_add_contacts_view.dart';
// import '../pages/contacts/add_method/add_method_binding.dart';
// import '../pages/contacts/add_method/add_method_view.dart';
// import '../pages/contacts/call_records/call_records_binding.dart';
// import '../pages/contacts/call_records/call_records_view.dart';
import '../pages/contacts/create_group/create_group_binding.dart';
import '../pages/contacts/create_group/create_group_view.dart';
import '../pages/contacts/friend_list/friend_list_binding.dart';
import '../pages/contacts/friend_list/friend_list_view.dart';
import '../pages/contacts/friend_list/search_friend/search_friend_binding.dart';
import '../pages/contacts/friend_list/search_friend/search_friend_view.dart';
// import '../pages/contacts/friend_requests/friend_requests_binding.dart';
// import '../pages/contacts/friend_requests/friend_requests_view.dart';
import '../pages/contacts/friend_permission_setting/friend_permission_setting_binding.dart';
import '../pages/contacts/request_records/handle_friend_requests/handle_friend_requests_binding.dart';
import '../pages/contacts/request_records/handle_friend_requests/handle_friend_requests_view.dart';
import '../pages/contacts/my_group/my_group_binding.dart';
import '../pages/contacts/my_group/my_group_view.dart';
import '../pages/contacts/my_group/search_group/search_group_binding.dart';
import '../pages/contacts/my_group/search_group/search_group_view.dart';
import '../pages/contacts/group_profile/group_profile_binding.dart';
import '../pages/contacts/group_profile/group_profile_view.dart';
// import '../pages/contacts/group_requests/group_requests_binding.dart';
// import '../pages/contacts/group_requests/group_requests_view.dart';
import '../pages/contacts/request_records/handle_group_requests/handle_group_requests_binding.dart';
import '../pages/contacts/request_records/handle_group_requests/handle_group_requests_view.dart';
import '../pages/contacts/select_contacts/friend_list/friend_list_binding.dart';
import '../pages/contacts/select_contacts/friend_list/friend_list_view.dart';
import '../pages/contacts/select_contacts/friend_list/search_friend/search_friend_binding.dart';
import '../pages/contacts/select_contacts/friend_list/search_friend/search_friend_view.dart';
import '../pages/contacts/select_contacts/search_contacts/search_contacts_binding.dart';
import '../pages/contacts/select_contacts/search_contacts/search_contacts_view.dart';
import '../pages/contacts/select_contacts/select_contacts_binding.dart';
import '../pages/contacts/select_contacts/select_contacts_view.dart';
// import '../pages/contacts/select_contacts/tag_list/tag_list_binding.dart';
// import '../pages/contacts/select_contacts/tag_list/tag_list_view.dart';
import '../pages/contacts/send_application/send_application_binding.dart';
import '../pages/contacts/send_application/send_application_view.dart';
// import '../pages/contacts/tag_group/create_tag_group/create_tag_group_binding.dart';
// import '../pages/contacts/tag_group/create_tag_group/create_tag_group_view.dart';
// import '../pages/contacts/tag_group/tag_group_binding.dart';
// import '../pages/contacts/tag_group/tag_group_view.dart';
// import '../pages/contacts/tag_notification_issued/build_tag_notification/build_tag_notification_binding.dart';
// import '../pages/contacts/tag_notification_issued/build_tag_notification/build_tag_notification_view.dart';
// import '../pages/contacts/tag_notification_issued/tag_notification_detail/tag_notification_detail_binding.dart';
// import '../pages/contacts/tag_notification_issued/tag_notification_detail/tag_notification_detail_view.dart';
// import '../pages/contacts/tag_notification_issued/tag_notification_issued_binding.dart';
// import '../pages/contacts/tag_notification_issued/tag_notification_issued_view.dart';
import '../pages/contacts/user_profile/friend_setting/friend_setting_binding.dart';
import '../pages/contacts/user_profile/friend_setting/friend_setting_view.dart';
import '../pages/contacts/user_profile/personal_info/personal_info_binding.dart';
import '../pages/contacts/user_profile/personal_info/personal_info_view.dart';
import '../pages/contacts/user_profile/set_remark/set_remark_binding.dart';
import '../pages/contacts/user_profile/set_remark/set_remark_view.dart';
import '../pages/contacts/user_profile/user_profile_binding.dart';
import '../pages/contacts/user_profile/user_profile_view.dart';
import '../pages/login/forget_pwd/forget_pwd_binding.dart';
import '../pages/login/forget_pwd/forget_pwd_view.dart';
import '../pages/login/reset_pwd/reset_pwd_binding.dart';
import '../pages/login/reset_pwd/reset_pwd_view.dart';
import '../pages/global_search/global_search_chat_history/global_search_chat_history_binding.dart';
import '../pages/global_search/global_search_chat_history/global_search_chat_history_view.dart';
import '../pages/global_search/global_search_binding.dart';
import '../pages/global_search/global_search_view.dart';
import '../pages/home/home_binding.dart';
import '../pages/home/home_view.dart';
import '../pages/login/login_binding.dart';
import '../pages/login/login_view.dart';
import '../pages/mine/about_us/about_us_binding.dart';
import '../pages/mine/about_us/about_us_view.dart';
import '../pages/mine/account_setting/account_setting_binding.dart';
import '../pages/mine/account_setting/account_setting_view.dart';
import '../pages/mine/user_black_list/user_black_list_binding.dart';
import '../pages/mine/user_black_list/user_black_list_view.dart';
import '../pages/mine/change_pwd/change_pwd_binding.dart';
import '../pages/mine/change_pwd/change_pwd_view.dart';
import '../pages/mine/edit_my_profile/edit_my_profile_binding.dart';
import '../pages/mine/edit_my_profile/edit_my_profile_view.dart';
import '../pages/mine/language_setting/language_setting_binding.dart';
import '../pages/mine/language_setting/language_setting_view.dart';
import '../pages/mine/my_profile/my_profile_binding.dart';
import '../pages/mine/my_profile/my_profile_view.dart';
import '../pages/mine/my_qrcode/my_qrcode_binding.dart';
import '../pages/mine/my_qrcode/my_qrcode_view.dart';
import '../pages/mine/app_unlock_setting/app_unlock_setting_binding.dart';
import '../pages/mine/app_unlock_setting/app_unlock_setting_view.dart';
import '../pages/register/register_binding.dart';
import '../pages/register/register_view.dart';
import '../pages/app_splash/app_splash_binding.dart';
import '../pages/app_splash/app_splash_view.dart';
// import '../pages/chat/oa_notification/oa_notification_binding.dart';
// import '../pages/chat/oa_notification/oa_notification_view.dart';

part 'app_routes.dart';

class AppPages {
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
        preventDuplicates: preventDuplicates,
        transition: [AppRoutes.home, AppRoutes.accountManage].contains(name)
            ? Transition.noTransition
            : Transition.cupertino,
        popGesture: true,
      );

  static final routes = <GetPage>[
    _pageBuilder(
      name: AppRoutes.splash,
      page: () => AppSplashPage(),
      binding: AppSplashBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.chat,
      page: () => ChatPage(),
      binding: ChatBinding(),
      preventDuplicates: false,
    ),
    _pageBuilder(
      name: AppRoutes.myQrcode,
      page: () => MyQrcodePage(),
      binding: MyQrcodeBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.chatSetting,
      page: () => ChatSettingPage(),
      binding: ChatSettingBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.favoriteManage,
      page: () => EmojiFavoriteManagePage(),
      binding: EmojiFavoriteManageBinding(),
    ),
    // _pageBuilder(
    //   name: AppRoutes.addContactsMethod,
    //   page: () => AddContactsMethodPage(),
    //   binding: AddContactsMethodBinding(),
    // ),
    _pageBuilder(
      name: AppRoutes.addContactsBySearch,
      page: () => SearchAddContactsPage(),
      binding: SearchAddContactsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.userProfile,
      page: () => UserProfilePage(),
      binding: UserProfileBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.personalInfo,
      page: () => PersonalInfoPage(),
      binding: PersonalInfoBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.friendSetting,
      page: () => FriendSettingPage(),
      binding: FriendSettingBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.setFriendRemark,
      page: () => SetRemarkPage(),
      binding: SetRemarkBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.sendApplication,
      page: () => SendApplicationPage(),
      binding: SendApplicationBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupProfilePanel,
      page: () => GroupProfilePage(),
      binding: GroupProfileBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.setMuteForGroupMember,
      page: () => SetMuteForGroupMemberPage(),
      binding: SetMuteForGroupMemberBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.myInfo,
      page: () => MyProfilePage(),
      binding: MyProfileBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.editMyInfo,
      page: () => EditMyProfilePage(),
      binding: EditMyProfileBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.accountSetting,
      page: () => AccountSettingPage(),
      binding: AccountSettingBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.blacklist,
      page: () => UserBlacklistPage(),
      binding: UserBlacklistBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.languageSetting,
      page: () => LanguageSettingPage(),
      binding: LanguageSettingBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.unlockSetup,
      page: () => AppUnlockSettingPage(),
      binding: AppUnlockSettingBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.changePassword,
      page: () => ChangePwdPage(),
      binding: ChangePwdBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.aboutUs,
      page: () => AboutUsPage(),
      binding: AboutUsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.backgroundSetting,
      page: () => BackgroundSettingPage(),
      binding: BackgroundSettingBinding(),
    ),
    // _pageBuilder(
    //   name: AppRoutes.setFontSize,
    //   page: () => SetFontSizePage(),
    //   binding: SetFontSizeBinding(),
    // ),
    _pageBuilder(
      name: AppRoutes.chatHistory,
      page: () => ChatHistory(),
      binding: ChatHistoryBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.chatHistoryMedia,
      page: () => ChatHistoryMediaPage(),
      binding: ChatHistoryMediaBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.chatHistoryFile,
      page: () => ChatHistoryFilePage(),
      binding: ChatHistoryFileBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.previewChatHistory,
      page: () => PreviewChatHistoryPage(),
      binding: PreviewChatHistoryBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupChatSetting,
      page: () => GroupChatSettingPage(),
      binding: GroupChatSettingBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupManage,
      page: () => GroupManagePage(),
      binding: GroupManageBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.editGroupName,
      page: () => EditGroupNamePage(),
      binding: EditGroupNameBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.editGroupAnnouncement,
      page: () => EditGroupAnnouncementPage(),
      binding: EditGroupAnnouncementBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupMemberList,
      page: () => GroupMemberListPage(),
      binding: GroupMemberListBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.searchGroupMember,
      page: () => SearchGroupMemberPage(),
      binding: SearchGroupMemberBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupQrcode,
      page: () => GroupQrcodePage(),
      binding: GroupQrcodeBinding(),
    ),
    // _pageBuilder(
    //   name: AppRoutes.friendRequests,
    //   page: () => FriendRequestsPage(),
    //   binding: FriendRequestsBinding(),
    // ),
    _pageBuilder(
      name: AppRoutes.handleFriendRequests,
      page: () => HandleFriendRequestsPage(),
      binding: HandleFriendRequestsBinding(),
    ),
    // _pageBuilder(
    //   name: AppRoutes.groupRequests,
    //   page: () => GroupRequestsPage(),
    //   binding: GroupRequestsBinding(),
    // ),
    _pageBuilder(
      name: AppRoutes.handleGroupRequests,
      page: () => HandleGroupRequestsPage(),
      binding: HandleGroupRequestsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.myFriend,
      page: () => FriendListPage(),
      binding: FriendListBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.myGroup,
      page: () => MyGroupPage(),
      binding: MyGroupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupReadList,
      page: () => GroupReadListPage(),
      binding: GroupReadListBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.searchFriend,
      page: () => SearchFriendPage(),
      binding: SearchFriendBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.searchGroup,
      page: () => SearchGroupPage(),
      binding: SearchGroupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContacts,
      page: () => SelectContactsPage(),
      binding: SelectContactsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContactsFromFriends,
      page: () => SelectContactsFromFriendsPage(),
      binding: SelectContactsFromFriendsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContactsFromGroup,
      page: () => SelectContactsFromGroupPage(),
      binding: SelectContactsFromGroupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContactsFromSearchFriends,
      page: () => SelectContactsFromSearchFriendsPage(),
      binding: SelectContactsFromSearchFriendsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContactsFromSearchGroup,
      page: () => SelectContactsFromSearchGroupPage(),
      binding: SelectContactsFromSearchGroupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContactsFromSearch,
      page: () => SelectContactsFromSearchPage(),
      binding: SelectContactsFromSearchBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.createGroup,
      page: () => CreateGroupPage(),
      binding: CreateGroupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.globalSearch,
      page: () => GlobalSearchPage(),
      binding: GlobalSearchBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.gloablSearchChatHistory,
      page: () => GlobalSearchChatHistoryPage(),
      binding: GlobalSearchChatHistoryBinding(),
    ),
    // _pageBuilder(
    //   name: AppRoutes.callRecords,
    //   page: () => CallRecordsPage(),
    //   binding: CallRecordsBinding(),
    // ),
    _pageBuilder(
      name: AppRoutes.register,
      page: () => RegisterPage(),
      binding: RegisterBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.forgetPassword,
      page: () => ForgetPwdPage(),
      binding: ForgetPwdBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.resetPassword,
      page: () => ResetPwdPage(),
      binding: ResetPwdBinding(),
    ),
    // _pageBuilder(
    //   name: AppRoutes.tagGroup,
    //   page: () => TagGroupPage(),
    //   binding: TagGroupBinding(),
    // ),
    // _pageBuilder(
    //   name: AppRoutes.createTagGroup,
    //   page: () => CreateTagGroupPage(),
    //   binding: CreateTagGroupBinding(),
    // ),
    // _pageBuilder(
    //   name: AppRoutes.selectContactsFromTag,
    //   page: () => SelectContactsFromTagPage(),
    //   binding: SelectContactsFromTagBinding(),
    // ),
    // _pageBuilder(
    //   name: AppRoutes.tagNotificationIssued,
    //   page: () => TagNotificationIssuedPage(),
    //   binding: TagNotificationIssuedBinding(),
    // ),
    // _pageBuilder(
    //   name: AppRoutes.buildTagNotification,
    //   page: () => BuildTagNotificationPage(),
    //   binding: BuildTagNotificationBinding(),
    // ),
    // _pageBuilder(
    //   name: AppRoutes.tagNotificationDetail,
    //   page: () => TagNotificationDetailPage(),
    //   binding: TagNotificationDetailBinding(),
    // ),
    // _pageBuilder(
    //   name: AppRoutes.oaNotificationList,
    //   page: () => OANotificationPage(),
    //   binding: OANotificationBinding(),
    // ),
    _pageBuilder(
      name: AppRoutes.bot,
      page: () => BotPage(),
      binding: BotBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.createBot,
      page: () => CreateBotPage(),
      binding: CreateBotBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.changeBotInfo,
      page: () => ChangeBotInfoPage(),
      binding: ChangeBotInfoBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.trainingBot,
      page: () => TrainingBotPage(),
      binding: TrainingBotBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.accountAndSecurity,
      page: () => AccountAndSecurityPage(),
      binding: AccountAndSecurityBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.phoneEmailChange,
      page: () => PhoneEmailChangePage(),
      binding: PhoneEmailChangeBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.phoneEmailChangeDetail,
      page: () => PhoneEmailChangeDetailPage(),
      binding: PhoneEmailChangeDetailBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.deleteUser,
      page: () => DeleteUserPage(),
      binding: DeleteUserBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.complaint,
      page: () => ComplaintPage(),
      binding: ComplaintBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.previewMedia,
      page: () => PreviewMediaPage(),
      binding: PreviewMediaBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.termsOfServer,
      page: () => TermsOfServerPage(),
      binding: TermsOfServerBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.privacyPolicy,
      page: () => PrivacyPolicyPage(),
      binding: PrivacyPolicyBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.friendPermissionsSetting,
      page: () => FriendPermissionSettingPage(),
      binding: FriendPermissionSettingBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.requestRecords,
      page: () => RequestRecordsPage(),
      binding: RequestRecordsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.accountManage,
      page: () => AccountManagePage(),
      binding: AccountManageBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.aiFriendList,
      page: () => AiFriendListPage(),
      binding: AiFriendListBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.searchAiFriend,
      page: () => SearchAiFriendPage(),
      binding: SearchAiFriendBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.myPoints,
      page: () => MyPointsPage(),
      binding: MyPointsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.pointRules,
      page: () => PointRulesPage(),
      binding: PointRulesBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.pointRecords,
      page: () => PointRecordsPage(),
      binding: PointRecordsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.inviteRecords,
      page: () => InviteRecordsPage(),
      binding: InviteRecordsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.invite,
      page: () => InvitePage(),
      binding: InviteBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.xhs,
      page: () => XhsPage(),
      binding: XhsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.myAi,
      page: () => MyAiPage(),
      binding: MyAiBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.searchMyAi,
      page: () => SearchMyAiPage(),
      binding: SearchMyAiBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.trainAi,
      page: () => TrainAiPage(),
      binding: TrainAiBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.knowledgeFiles,
      page: () => KnowledgebaseFilesPage(),
      binding: KnowledgebaseFilesBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.xhsMomentDetail,
      page: () => XhsMomentDetailPage(),
      binding: XhsMomentDetailBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.welcomePage,
      page: () => WelcomePage(),
      // binding: WelcomePage(),
    ),
    // ...OPages.pages, // 组织架构
    ...CirclePages.pages, // 工作圈
    // ...MPages.pages, //
  ];
}
