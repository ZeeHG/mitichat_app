import 'package:get/get.dart';
import 'package:miti/pages/chat/complaint/complaint_binding.dart';
import 'package:miti/pages/chat/complaint/complaint_view.dart';
import 'package:miti/pages/contacts/ai_friend_list/ai_friend_list_binding.dart';
import 'package:miti/pages/contacts/ai_friend_list/ai_friend_list_view.dart';
import 'package:miti/pages/contacts/ai_friend_list/search_ai_friend/search_ai_friend_binding.dart';
import 'package:miti/pages/contacts/ai_friend_list/search_ai_friend/search_ai_friend_view.dart';
import 'package:miti/pages/contacts/my_ai/knowledgebase_files/knowledgebase_files_binding.dart';
import 'package:miti/pages/contacts/my_ai/knowledgebase_files/knowledgebase_files_view.dart';
import 'package:miti/pages/contacts/my_ai/my_ai_binding.dart';
import 'package:miti/pages/contacts/my_ai/my_ai_view.dart';
import 'package:miti/pages/contacts/my_ai/search_my_ai/search_my_ai_binding.dart';
import 'package:miti/pages/contacts/my_ai/search_my_ai/search_my_ai_view.dart';
import 'package:miti/pages/contacts/my_ai/train_ai/train_ai_binding.dart';
import 'package:miti/pages/contacts/my_ai/train_ai/train_ai_view.dart';
import 'package:miti/pages/contacts/recent_requests/recent_requests_binding.dart';
import 'package:miti/pages/contacts/recent_requests/recent_requests_view.dart';
import 'package:miti/pages/friend_permissions/friend_permissions_binding.dart';
import 'package:miti/pages/friend_permissions/friend_permissions_view.dart';
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
import 'package:miti/pages/preview_selected_assets/preview_selected_assets_binding.dart';
import 'package:miti/pages/preview_selected_assets/preview_selected_assets_view.dart';
import 'package:miti/pages/privacy_policy/privacy_policy_binding.dart';
import 'package:miti/pages/privacy_policy/privacy_policy_view.dart';
import 'package:miti/pages/terms_of_server/terms_of_server_binding.dart';
import 'package:miti/pages/terms_of_server/terms_of_server_view.dart';
import 'package:miti/pages/xhs/xhs_binding.dart';
import 'package:miti/pages/xhs/xhs_view.dart';
import 'package:openim_meeting/openim_meeting.dart';
import 'package:openim_working_circle/openim_working_circle.dart';

import '../pages/bot/bot_binding.dart';
import '../pages/bot/bot_view.dart';
import '../pages/bot/change_bot_info/change_bot_info_binding.dart';
import '../pages/bot/change_bot_info/change_bot_info_view.dart';
import '../pages/bot/create_bot/create_bot_binding.dart';
import '../pages/bot/create_bot/create_bot_view.dart';
import '../pages/bot/training_bot/training_bot_binding.dart';
import '../pages/bot/training_bot/training_bot_view.dart';
import '../pages/chat/chat_binding.dart';
import '../pages/chat/chat_setup/chat_setup_binding.dart';
import '../pages/chat/chat_setup/chat_setup_view.dart';
import '../pages/chat/chat_setup/favorite_manage/favorite_manage_binding.dart';
import '../pages/chat/chat_setup/favorite_manage/favorite_manage_view.dart';
import '../pages/chat/chat_setup/search_chat_history/file/file_binding.dart';
import '../pages/chat/chat_setup/search_chat_history/file/file_view.dart';
import '../pages/chat/chat_setup/search_chat_history/multimedia/multimedia_binding.dart';
import '../pages/chat/chat_setup/search_chat_history/multimedia/multimedia_view.dart';
import '../pages/chat/chat_setup/search_chat_history/preview_chat_history/preview_chat_history_binding.dart';
import '../pages/chat/chat_setup/search_chat_history/preview_chat_history/preview_chat_history_view.dart';
import '../pages/chat/chat_setup/search_chat_history/search_chat_history_binding.dart';
import '../pages/chat/chat_setup/search_chat_history/search_chat_history_view.dart';
import '../pages/chat/chat_setup/set_background/set_background_binding.dart';
import '../pages/chat/chat_setup/set_background/set_background_view.dart';
import '../pages/chat/chat_setup/set_font_size/set_font_size_binding.dart';
import '../pages/chat/chat_setup/set_font_size/set_font_size_view.dart';
import '../pages/chat/chat_view.dart';
import '../pages/chat/group_setup/edit_announcement/edit_announcement_binding.dart';
import '../pages/chat/group_setup/edit_announcement/edit_announcement_view.dart';
import '../pages/chat/group_setup/edit_name/edit_name_binding.dart';
import '../pages/chat/group_setup/edit_name/edit_name_view.dart';
import '../pages/chat/group_setup/group_manage/group_manage_binding.dart';
import '../pages/chat/group_setup/group_manage/group_manage_view.dart';
import '../pages/chat/group_setup/group_member_list/group_member_list_binding.dart';
import '../pages/chat/group_setup/group_member_list/group_member_list_view.dart';
import '../pages/chat/group_setup/group_member_list/search_group_member/search_group_member_binding.dart';
import '../pages/chat/group_setup/group_member_list/search_group_member/search_group_member_view.dart';
import '../pages/chat/group_setup/group_qrcode/group_qrcode_binding.dart';
import '../pages/chat/group_setup/group_qrcode/group_qrcode_view.dart';
import '../pages/chat/group_setup/group_read_list/group_read_list_binding.dart';
import '../pages/chat/group_setup/group_read_list/group_read_list_view.dart';
import '../pages/chat/group_setup/group_setup_binding.dart';
import '../pages/chat/group_setup/group_setup_view.dart';
import '../pages/chat/group_setup/set_mute_for_memeber/set_mute_for_member_binding.dart';
import '../pages/chat/group_setup/set_mute_for_memeber/set_mute_for_member_view.dart';
import '../pages/contacts/add_by_search/add_by_search_binding.dart';
import '../pages/contacts/add_by_search/add_by_search_view.dart';
import '../pages/contacts/add_method/add_method_binding.dart';
import '../pages/contacts/add_method/add_method_view.dart';
import '../pages/contacts/call_records/call_records_binding.dart';
import '../pages/contacts/call_records/call_records_view.dart';
import '../pages/contacts/create_group/create_group_binding.dart';
import '../pages/contacts/create_group/create_group_view.dart';
import '../pages/contacts/friend_list/friend_list_binding.dart';
import '../pages/contacts/friend_list/friend_list_view.dart';
import '../pages/contacts/friend_list/search_friend/search_friend_binding.dart';
import '../pages/contacts/friend_list/search_friend/search_friend_view.dart';
import '../pages/contacts/friend_requests/friend_requests_binding.dart';
import '../pages/contacts/friend_requests/friend_requests_view.dart';
import '../pages/contacts/friend_requests/process_friend_requests/process_friend_requests_binding.dart';
import '../pages/contacts/friend_requests/process_friend_requests/process_friend_requests_view.dart';
import '../pages/contacts/group_list/group_list_binding.dart';
import '../pages/contacts/group_list/group_list_view.dart';
import '../pages/contacts/group_list/search_group/search_group_binding.dart';
import '../pages/contacts/group_list/search_group/search_group_view.dart';
import '../pages/contacts/group_profile_panel/group_profile_panel_binding.dart';
import '../pages/contacts/group_profile_panel/group_profile_panel_view.dart';
import '../pages/contacts/group_requests/group_requests_binding.dart';
import '../pages/contacts/group_requests/group_requests_view.dart';
import '../pages/contacts/group_requests/process_group_requests/process_group_requests_binding.dart';
import '../pages/contacts/group_requests/process_group_requests/process_group_requests_view.dart';
import '../pages/contacts/select_contacts/friend_list/friend_list_binding.dart';
import '../pages/contacts/select_contacts/friend_list/friend_list_view.dart';
import '../pages/contacts/select_contacts/friend_list/search_friend/search_friend_binding.dart';
import '../pages/contacts/select_contacts/friend_list/search_friend/search_friend_view.dart';
import '../pages/contacts/select_contacts/group_list/group_list_binding.dart';
import '../pages/contacts/select_contacts/group_list/group_list_view.dart';
import '../pages/contacts/select_contacts/group_list/search_group/search_group_binding.dart';
import '../pages/contacts/select_contacts/group_list/search_group/search_group_view.dart';
import '../pages/contacts/select_contacts/search_contacts/search_contacts_binding.dart';
import '../pages/contacts/select_contacts/search_contacts/search_contacts_view.dart';
import '../pages/contacts/select_contacts/select_contacts_binding.dart';
import '../pages/contacts/select_contacts/select_contacts_view.dart';
import '../pages/contacts/select_contacts/tag_list/tag_list_binding.dart';
import '../pages/contacts/select_contacts/tag_list/tag_list_view.dart';
import '../pages/contacts/send_verification_application/send_verification_application_binding.dart';
import '../pages/contacts/send_verification_application/send_verification_application_view.dart';
import '../pages/contacts/tag_group/create_tag_group/create_tag_group_binding.dart';
import '../pages/contacts/tag_group/create_tag_group/create_tag_group_view.dart';
import '../pages/contacts/tag_group/tag_group_binding.dart';
import '../pages/contacts/tag_group/tag_group_view.dart';
import '../pages/contacts/tag_notification_issued/build_tag_notification/build_tag_notification_binding.dart';
import '../pages/contacts/tag_notification_issued/build_tag_notification/build_tag_notification_view.dart';
import '../pages/contacts/tag_notification_issued/tag_notification_detail/tag_notification_detail_binding.dart';
import '../pages/contacts/tag_notification_issued/tag_notification_detail/tag_notification_detail_view.dart';
import '../pages/contacts/tag_notification_issued/tag_notification_issued_binding.dart';
import '../pages/contacts/tag_notification_issued/tag_notification_issued_view.dart';
import '../pages/contacts/user_profile_panel/friend_setup/friend_setup_binding.dart';
import '../pages/contacts/user_profile_panel/friend_setup/friend_setup_view.dart';
import '../pages/contacts/user_profile_panel/personal_info/personal_info_binding.dart';
import '../pages/contacts/user_profile_panel/personal_info/personal_info_view.dart';
import '../pages/contacts/user_profile_panel/set_remark/set_remark_binding.dart';
import '../pages/contacts/user_profile_panel/set_remark/set_remark_view.dart';
import '../pages/contacts/user_profile_panel/user_profile _panel_binding.dart';
import '../pages/contacts/user_profile_panel/user_profile _panel_view.dart';
import '../pages/forget_password/forget_password_binding.dart';
import '../pages/forget_password/forget_password_view.dart';
import '../pages/forget_password/reset_password/reset_password_binding.dart';
import '../pages/forget_password/reset_password/reset_password_view.dart';
import '../pages/global_search/expand_chat_history/expand_chat_history_binding.dart';
import '../pages/global_search/expand_chat_history/expand_chat_history_view.dart';
import '../pages/global_search/global_search_binding.dart';
import '../pages/global_search/global_search_view.dart';
import '../pages/home/home_binding.dart';
import '../pages/home/home_view.dart';
import '../pages/login/login_binding.dart';
import '../pages/login/login_view.dart';
import '../pages/mine/about_us/about_us_binding.dart';
import '../pages/mine/about_us/about_us_view.dart';
import '../pages/mine/account_setup/account_setup_binding.dart';
import '../pages/mine/account_setup/account_setup_view.dart';
import '../pages/mine/blacklist/blacklist_binding.dart';
import '../pages/mine/blacklist/blacklist_view.dart';
import '../pages/mine/change_pwd/change_pwd_binding.dart';
import '../pages/mine/change_pwd/change_pwd_view.dart';
import '../pages/mine/edit_my_info/edit_my_info_binding.dart';
import '../pages/mine/edit_my_info/edit_my_info_view.dart';
import '../pages/mine/language_setup/language_setup_binding.dart';
import '../pages/mine/language_setup/language_setup_view.dart';
import '../pages/mine/my_info/my_info_binding.dart';
import '../pages/mine/my_info/my_info_view.dart';
import '../pages/mine/my_qrcode/my_qrcode_binding.dart';
import '../pages/mine/my_qrcode/my_qrcode_view.dart';
import '../pages/mine/unlock_setup/unlock_setup_binding.dart';
import '../pages/mine/unlock_setup/unlock_setup_view.dart';
import '../pages/register/register_binding.dart';
import '../pages/register/register_view.dart';
import '../pages/register/set_password/set_password_binding.dart';
import '../pages/register/set_password/set_password_view.dart';
import '../pages/register/set_self_info/set_self_info_binding.dart';
import '../pages/register/set_self_info/set_self_info_view.dart';
import '../pages/register/verify_phone/verify_phone_binding.dart';
import '../pages/register/verify_phone/verify_phone_view.dart';
import '../pages/splash/splash_binding.dart';
import '../pages/splash/splash_view.dart';
import '../pages/discover/discover_binding.dart';
import '../pages/discover/discover_view.dart';
import '../pages/chat/oa_notification/oa_notification_binding.dart';
import '../pages/chat/oa_notification/oa_notification_view.dart';

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
        transition: [AppRoutes.home, AppRoutes.accountManage].contains(name)? Transition.noTransition : Transition.cupertino,
        popGesture: true,
      );

  static final routes = <GetPage>[
    _pageBuilder(
      name: AppRoutes.splash,
      page: () => SplashPage(),
      binding: SplashBinding(),
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
      name: AppRoutes.chatSetup,
      page: () => ChatSetupPage(),
      binding: ChatSetupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.favoriteManage,
      page: () => FavoriteManagePage(),
      binding: FavoriteManageBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.addContactsMethod,
      page: () => AddContactsMethodPage(),
      binding: AddContactsMethodBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.addContactsBySearch,
      page: () => AddContactsBySearchPage(),
      binding: AddContactsBySearchBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.userProfilePanel,
      page: () => UserProfilePanelPage(),
      binding: UserProfilePanelBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.personalInfo,
      page: () => PersonalInfoPage(),
      binding: PersonalInfoBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.friendSetup,
      page: () => FriendSetupPage(),
      binding: FriendSetupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.setFriendRemark,
      page: () => SetFriendRemarkPage(),
      binding: SetFriendRemarkBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.sendVerificationApplication,
      page: () => SendVerificationApplicationPage(),
      binding: SendVerificationApplicationBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupProfilePanel,
      page: () => GroupProfilePanelPage(),
      binding: GroupProfilePanelBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.setMuteForGroupMember,
      page: () => SetMuteForGroupMemberPage(),
      binding: SetMuteForGroupMemberBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.myInfo,
      page: () => MyInfoPage(),
      binding: MyInfoBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.editMyInfo,
      page: () => EditMyInfoPage(),
      binding: EditMyInfoBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.accountSetup,
      page: () => AccountSetupPage(),
      binding: AccountSetupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.blacklist,
      page: () => BlacklistPage(),
      binding: BlacklistBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.languageSetup,
      page: () => LanguageSetupPage(),
      binding: LanguageSetupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.unlockSetup,
      page: () => UnlockSetupPage(),
      binding: UnlockSetupBinding(),
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
      name: AppRoutes.setBackgroundImage,
      page: () => SetBackgroundImagePage(),
      binding: SetBackgroundImageBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.setFontSize,
      page: () => SetFontSizePage(),
      binding: SetFontSizeBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.searchChatHistory,
      page: () => SearchChatHistoryPage(),
      binding: SearchChatHistoryBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.searchChatHistoryMultimedia,
      page: () => ChatHistoryMultimediaPage(),
      binding: ChatHistoryMultimediaBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.searchChatHistoryFile,
      page: () => ChatHistoryFilePage(),
      binding: ChatHistoryFileBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.previewChatHistory,
      page: () => PreviewChatHistoryPage(),
      binding: PreviewChatHistoryBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupChatSetup,
      page: () => GroupSetupPage(),
      binding: GroupSetupBinding(),
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
    _pageBuilder(
      name: AppRoutes.friendRequests,
      page: () => FriendRequestsPage(),
      binding: FriendRequestsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.processFriendRequests,
      page: () => ProcessFriendRequestsPage(),
      binding: ProcessFriendRequestsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupRequests,
      page: () => GroupRequestsPage(),
      binding: GroupRequestsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.processGroupRequests,
      page: () => ProcessGroupRequestsPage(),
      binding: ProcessGroupRequestsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.friendList,
      page: () => FriendListPage(),
      binding: FriendListBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupList,
      page: () => GroupListPage(),
      binding: GroupListBinding(),
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
      name: AppRoutes.expandChatHistory,
      page: () => ExpandChatHistoryPage(),
      binding: ExpandChatHistoryBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.callRecords,
      page: () => CallRecordsPage(),
      binding: CallRecordsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.register,
      page: () => RegisterPage(),
      binding: RegisterBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.verifyPhone,
      page: () => VerifyPhonePage(),
      binding: VerifyPhoneBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.setPassword,
      page: () => SetPasswordPage(),
      binding: SetPasswordBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.setSelfInfo,
      page: () => SetSelfInfoPage(),
      binding: SetSelfInfoBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.forgetPassword,
      page: () => ForgetPasswordPage(),
      binding: ForgetPasswordBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.resetPassword,
      page: () => ResetPasswordPage(),
      binding: ResetPasswordBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.tagGroup,
      page: () => TagGroupPage(),
      binding: TagGroupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.createTagGroup,
      page: () => CreateTagGroupPage(),
      binding: CreateTagGroupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContactsFromTag,
      page: () => SelectContactsFromTagPage(),
      binding: SelectContactsFromTagBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.tagNotificationIssued,
      page: () => TagNotificationIssuedPage(),
      binding: TagNotificationIssuedBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.buildTagNotification,
      page: () => BuildTagNotificationPage(),
      binding: BuildTagNotificationBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.tagNotificationDetail,
      page: () => TagNotificationDetailPage(),
      binding: TagNotificationDetailBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.oaNotificationList,
      page: () => OANotificationPage(),
      binding: OANotificationBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.discover,
      page: () => DiscoverPage(),
      binding: DiscoverBinding(),
    ),
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
      name: AppRoutes.previewSelectedAssets,
      page: () => PreviewSelectedAssetsPage(),
      binding: PreviewSelectedAssetsBinding(),
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
      name: AppRoutes.friendPermissions,
      page: () => FriendPermissionsPage(),
      binding: FriendPermissionsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.recentRequests,
      page: () => RecentRequestsPage(),
      binding: RecentRequestsBinding(),
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
    // ...OPages.pages, // 组织架构
    ...WPages.pages, // 工作圈
    ...MPages.pages, //
  ];
}
