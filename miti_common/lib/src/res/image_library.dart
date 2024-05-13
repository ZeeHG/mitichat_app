/// 使用方法
/// ```
/// ImageLibrary.splashLogo
///   .toImage
///   ..width = 55.61.w
///   ..height = 78.91.h,
/// ```
class ImageLibrary {
  ImageLibrary._();

  static const _dir = "assets/images";

  static const _animDir = "assets/anim";

  static const voiceWhiteAnim = "$_animDir/voice_white.json";
  static const voiceBlueAnim = "$_animDir/voice_blue.json";
  static const voiceBlackAnim = "$_animDir/voice_black.json";

  static const eyeOpen = "$_dir/ic_eye_open.png";
  static const eyeClose = "$_dir/ic_eye_close.png";
  static const clearText = "$_dir/ic_clear_text.png";
  static const searchGrey = "$_dir/ic_search_gery.png";
  static const callBack = "$_dir/ic_call_black.png";
  static const addBlack = "$_dir/ic_add_black.png";
  static const syncFailed = "$_dir/ic_sync_failed.png";
  static const notDisturb = "$_dir/ic_not_disturb.png";
  static const backBlack = "$_dir/ic_back_black.png";
  static const moreBlack = "$_dir/ic_more_black.png";
  static const openEmoji = "$_dir/ic_open_emoji.png";
  static const openKeyboard = "$_dir/ic_open_keyboard.png";
  static const openToolbox = "$_dir/ic_open_toolbox.png";
  static const openVoice = "$_dir/ic_open_voice.png";
  static const delQuote = "$_dir/ic_del_quote.png";
  static const favoriteTab = "$_dir/ic_favorite_tab.png";
  static const emojiTab = "$_dir/ic_emoji_tab.png";
  static const addFavorite = "$_dir/ic_add_favorite.png";
  static const videoCallMsg = "$_dir/ic_video_call_msg.png";
  static const voiceCallMsg = "$_dir/ic_voice_call_msg.png";
  static const fileExcel = "$_dir/ic_file_excel.png";
  static const filePdf = "$_dir/ic_file_pdf.png";
  static const filePpt = "$_dir/ic_file_ppt.png";
  static const fileUnknown = "$_dir/ic_file_unknown.png";
  static const fileWord = "$_dir/ic_file_word.png";
  static const fileZip = "$_dir/ic_file_zip.png";
  static const fileMask = "$_dir/ic_file_mask.png";
  static const progressGoing = "$_dir/ic_progress_going.png";
  static const progressPause = "$_dir/ic_progress_pause.png";
  static const progressPlay = "$_dir/ic_progress_play.png";
  static const videoPause = "$_dir/ic_video_pause.png";
  static const voiceWhite = "$_dir/ic_voice_white.png";
  static const voiceBlue = "$_dir/ic_voice_blue.png";
  static const voiceBlack = "$_dir/ic_voice_black.png";
  static const notice = "$_dir/ic_notice.png";
  static const radioNor = "$_dir/ic_radio_nor.png";
  static const radioSel = "$_dir/ic_radio_sel.png";
  static const failedToResend = "$_dir/ic_failed_resend.png";
  static const menuAddFace = "$_dir/ic_menu_add_face.png";
  static const menuCopy = "$_dir/ic_menu_copy.png";
  static const menuDel = "$_dir/ic_menu_del.png";
  static const menuForward = "$_dir/ic_menu_forward.png";
  static const menuMulti = "$_dir/ic_menu_multi.png";
  static const menuReply = "$_dir/ic_menu_reply.png";
  static const menuRevoke = "$_dir/ic_menu_revoke.png";
  static const scrollDown = "$_dir/ic_scroll_down.png";
  static const sendMessage = "$_dir/ic_send_message.png";
  static const multiBoxDel = "$_dir/ic_multi_box_del.png";
  static const multiBoxForward = "$_dir/ic_multi_box_forward.png";
  static const groupCallHitArrow = "$_dir/ic_group_call_hint_arrow.png";
  static const moreCallMember = "$_dir/ic_more_call_member.png";
  static const closeGroupNotice = "$_dir/ic_close_notice.png";
  static const videoMeeting = "$_dir/ic_video_meeting.png";
  static const nextBlue = "$_dir/ic_next_blue.png";
  static const callVoice = "$_dir/ic_call_voice.png";
  static const callVideo = "$_dir/ic_call_video.png";
  static const mineHeaderBg = "$_dir/ic_mine_header_bg.png";
  static const mineCopy = "$_dir/ic_mine_copy.png";
  static const mineQr = "$_dir/ic_mine_qr.png";
  static const rightArrow = "$_dir/ic_right_arrow.png";
  static const myInfo = "$_dir/ic_mine_my_info.png";
  static const workingCircle = "$_dir/ic_working_circle.png";
  static const accountSetting = "$_dir/ic_mine_account_setting.png";
  static const aboutUs = "$_dir/ic_mine_about_us.png";
  static const logout = "$_dir/ic_mine_logout.png";
  static const myFriend = "$_dir/ic_my_friend.png";
  static const myGroup = "$_dir/ic_my_group.png";
  static const newFriend = "$_dir/ic_new_friend.png";
  static const newGroup = "$_dir/ic_new_group.png";
  static const searchBlack = "$_dir/ic_search_black.png";
  static const addContacts = "$_dir/ic_add_contacts.png";
  static const tree = "$_dir/ic_tree.png";
  static const scanBlue = "$_dir/ic_scan_blue.png";
  static const addFriendBlue = "$_dir/ic_add_friend_blue.png";
  static const createGroupBlue = "$_dir/ic_create_group_blue.png";
  static const addGroupBLue = "$_dir/ic_add_group_blue.png";
  static const createGroupTime = "$_dir/ic_create_group_time.png";
  static const moreMembers = "$_dir/ic_more_members.png";
  static const searchPersonIcon = "$_dir/ic_search_person.png";
  static const searchGroupIcon = "$_dir/ic_search_group.png";
  static const audioAndVideoCall = "$_dir/ic_voice_video_call.png";
  static const message = "$_dir/ic_message.png";
  // static const checked = "$_dir/ic_checked.png";
  static const blacklistEmpty = "$_dir/ic_blacklist_empty.png";
  static const chatSearch = "$_dir/ic_chat_search.png";
  static const chatSearchPic = "$_dir/ic_chat_pic.png";
  static const chatSearchVideo = "$_dir/ic_chat_video.png";
  static const chatSearchFile = "$_dir/ic_chat_file.png";
  static const addFriendTobeGroup = "$_dir/ic_add_friend_tobe_group.png";
  static const editName = "$_dir/ic_edit_name.png";
  static const addMember = "$_dir/ic_member_add.png";
  static const delMember = "$_dir/ic_member_del.png";
  static const expandUpArrow = "$_dir/ic_expand.png";
  static const indexBarBg = "$_dir/ic_index_bar_bubble_white.png";
  static const sendRequests = "$_dir/ic_send_requests.png";
  static const cameraGray = "$_dir/ic_camera_gray.png";
  static const searchNotFound = "$_dir/ic_search_not_found.png";
  // static const workingCircleHeaderBg = "$_dir/ic_working_circle_header_bg.png";
  static const workingCircleMessage = "$_dir/ic_working_circle_message.png";
  static const workingCirclePublish = "$_dir/ic_working_circle_publish.png";
  static const workingCircleEmpty = "$_dir/ic_working_circle_empty.png";
  static const visibleUser = "$_dir/ic_visible_user.png";
  static const moreOp = "$_dir/ic_more_op.png";
  static const whoCanWatch = "$_dir/ic_who_can_watch.png";
  static const remindWhoToWatch = "$_dir/ic_remind_who_to_watch.png";
  static const circle = "$_dir/ic_circle.png";
  static const liveClose = "$_dir/ic_live_close.png";
  static const liveHangUp = "$_dir/ic_live_hang_up.png";
  static const liveMicOff = "$_dir/ic_live_mic_off.png";
  static const liveMicOn = "$_dir/ic_live_mic_on.png";
  static const livePicUp = "$_dir/ic_live_pick_up.png";
  static const liveSpeakerOff = "$_dir/ic_live_speaker_off.png";
  static const liveSpeakerOn = "$_dir/ic_live_speaker_on.png";
  static const liveCameraOn = "$_dir/ic_live_camera_on.png";
  static const liveCameraOff = "$_dir/ic_live_camera_off.png";
  static const liveSwitchCamera = "$_dir/ic_live_switch_camera.png";
  static const liveBg = "$_dir/ic_live_bg.png";
  static const meetingBook = "$_dir/ic_meeting_book.png";
  static const meetingJoin = "$_dir/ic_meeting_join.png";
  static const meetingQuickStart = "$_dir/ic_meeting_quick_start.png";
  static const meetingForward = "$_dir/ic_meeting_forward.png";
  static const meetingPerson = "$_dir/ic_meeting_person.png";
  static const meetingTrumpet = "$_dir/ic_meeting_trumpet.png";
  static const meetingScreenShareOn = "$_dir/ic_meeting_screen_share_on.png";
  static const meetingScreenShareOff = "$_dir/ic_meeting_screen_share_off.png";
  static const meetingSetting = "$_dir/ic_meeting_setting.png";
  static const meetingMore = "$_dir/ic_meeting_more.png";
  static const meetingMembers = "$_dir/ic_meeting_members.png";
  static const meetingExpandArrow = "$_dir/ic_meeting_expand_arrow.png";
  static const meetingEar = "$_dir/ic_meeting_ear.png";
  static const meetingCameraOffGray = "$_dir/ic_meeting_camera_off_gray.png";
  static const meetingCameraOffWhite = "$_dir/ic_meeting_camera_off_white.png";
  static const meetingCameraOnGray = "$_dir/ic_meeting_camera_on_gray.png";
  static const meetingCameraOnWhite = "$_dir/ic_meeting_camera_on_white.png";
  static const meetingMicOffGray = "$_dir/ic_meeting_mic_off_gray.png";
  static const meetingMicOffWhite = "$_dir/ic_meeting_mic_off_white.png";
  static const meetingMicOnGray = "$_dir/ic_meeting_mic_on_gray.png";
  static const meetingMicOnWhite = "$_dir/ic_meeting_mic_on_white.png";
  static const meetingMembersPin = "$_dir/ic_meeting_members_pin.png";
  static const meetingVideo = "$_dir/ic_meeting_video.png";
  static const meetingAllSeeHim = "$_dir/ic_meeting_see_him.png";
  static const meetingRotateScreen = "$_dir/ic_meeting_rotate_screen.png";
  static const pictureError = "$_dir/ic_picture_error.png";
  static const downArrow = "$_dir/ic_down_arrow.png";
  static const warn = "$_dir/ic_warn.png";
  static const issueNotice = "$_dir/ic_issue_notice.png";
  static const tagGroup = "$_dir/ic_tag_group.png";
  static const addTagMember = "$_dir/ic_add_tag_member.png";
  static const tagIcon = "$_dir/ic_tag_icon.png";
  static const momentsIcon = "$_dir/ic_moments.png";
  static const forwardIcon = '$_dir/ic_forward_icon.png';
  static const saveIcon = '$_dir/ic_save_icon.png';

  // 新增
  static const splashLogo = "$_dir/app_logo.png";
  static const loginLogo = "$_dir/app_logo.png";
  static const checked = "$_dir/app_checked.png";
  static const workingCircleHeaderBg = "$_dir/ic_working_circle_header_bg.png";
  static const workingCircleHeaderBg2 =
      "$_dir/ic_working_circle_header_bg2.png";
  static const workingCircleHeaderBg3 =
      "$_dir/ic_working_circle_header_bg3.png";
  static const splash = "$_dir/splash.png";
  static const logo2 = "$_dir/logo2.png";
  static const logo3 = "$_dir/logo3.png";
  static const botBtn = "$_dir/bot_btn.png";
  static const appHomeTab1Nor = "$_dir/app_home_tab1_nor.png";
  static const appHomeTab2Nor = "$_dir/app_home_tab2_nor.png";
  static const appHomeTab3Nor = "$_dir/app_home_tab3_nor.png";
  static const appHomeTab3NorOld = "$_dir/app_home_tab3_nor_old.png";
  static const appHomeTab3Nor2 = "$_dir/app_home_tab3_nor2.png";
  static const appHomeTab3Sel2 = "$_dir/app_home_tab3_sel2.png";
  static const appHomeTab3Nor3 = "$_dir/app_home_tab3_nor3.png";
  static const appHomeTab4Nor = "$_dir/app_home_tab4_nor.png";
  static const appHomeTab4Nor2 = "$_dir/app_home_tab4_nor2.png";
  static const appHomeTab1Sel = "$_dir/app_home_tab1_sel.png";
  static const appHomeTab2Sel = "$_dir/app_home_tab2_sel.png";
  static const appHomeTab3Sel = "$_dir/app_home_tab3_sel.png";
  static const appHomeTab4Sel = "$_dir/app_home_tab4_sel.png";
  static const appHomeTab4Sel2 = "$_dir/app_home_tab4_sel2.png";
  static const appHomeTab4Sel3 = "$_dir/app_home_tab4_sel3.png";
  static const appHomeTab4Nor3 = "$_dir/app_home_tab4_nor3.png";
  static const appAddContacts = "$_dir/app_add_contacts.png";
  static const appRightArrow = "$_dir/app_right_arrow.png";
  static const appNewFriend = "$_dir/app_new_friend.png";
  static const appNewGroup = "$_dir/app_new_group.png";
  static const appMyFriend = "$_dir/app_my_friend.png";
  static const appMyGroup = "$_dir/app_my_group.png";
  static const appTagGroup = "$_dir/app_tag_group.png";
  static const appIssueNotice = "$_dir/app_issue_notice.png";
  static const appAboutUs = "$_dir/app_mine_about_us.png";
  static const appLogout = "$_dir/app_mine_logout.png";
  static const appMyInfo = "$_dir/app_mine_my_info.png";
  static const appAccountSetting = "$_dir/app_mine_account_setting.png";
  static const appHeaderBg = "$_dir/app_header_bg.png";
  static const appHeaderBg2 = "$_dir/app_header_bg2.png";
  static const appHeaderBg3 = "$_dir/app_header_bg3.png";
  static const appMineQr = "$_dir/app_mine_qr.png";
  static const appPopMenuAddFriend = "$_dir/app_popmenu_add_friend.png";
  static const appPopMenuAddGroup = "$_dir/app_popmenu_add_group.png";
  static const appPopMenuCreateGroup = "$_dir/app_popmenu_create_group.png";
  static const appPopMenuScan = "$_dir/app_popmenu_scan.png";
  static const appPopMenuVideoMeeting = "$_dir/app_popmenu_video_meeting.png";
  static const appMoreBlack = "$_dir/app_more_black.png";
  static const appBackBlack = "$_dir/app_back_black.png";
  static const appBackWhite = "$_dir/app_back_white.png";
  static const appToolboxAlbum = "$_dir/app_toolbox_album.png";
  static const appToolboxCall = "$_dir/app_toolbox_call.png";
  static const appToolboxCamera = "$_dir/app_toolbox_camera.png";
  static const appToolboxCard = "$_dir/app_toolbox_card.png";
  static const appToolboxFile = "$_dir/app_toolbox_file.png";
  static const appTranslate = "$_dir/app_translate.png";
  static const appToolboxLocation = "$_dir/app_toolbox_location.png";
  static const appToolboxSnapchat = "$_dir/app_toolbox_snapchat.png";
  static const appToolboxGroupNote = "$_dir/app_toolbox_group_note.png";
  static const appToolboxVote = "$_dir/app_toolbox_vote.png";
  static const appUpArrow = "$_dir/app_up_arrow.png";
  static const appBot = "$_dir/app_bot.png";
  static const appDiscoverOperation = "$_dir/app_discover_operation.png";
  static const appLike = "$_dir/app_like.png";
  static const appWorkingCircleMessage = "$_dir/app_working_circle_message.png";
  static const appWorkingCirclePublish = "$_dir/app_working_circle_publish.png";
  static const appPublishPic = "$_dir/app_publish_pic.png";
  static const appPublishVideo = "$_dir/app_publish_video.png";
  static const appSearch = "$_dir/app_search.png";
  static const appAudioAndVideoCall = "$_dir/app_voice_video_call.png";
  static const appSendMessage = "$_dir/app_send_message.png";
  static const appRefresh = "$_dir/app_refresh.png";
  static const appLocation = "$_dir/app_location.png";
  static const appWhoCanWatch = "$_dir/app_who_can_watch.png";
  static const appRemindWhoToWatch = "$_dir/app_remind_who_to_watch.png";
  static const appProductView = "$_dir/app_product_view.png";
  static const appFanGroup = "$_dir/app_fan_group.png";
  static const appMan = "$_dir/app_man.png";
  static const appWoman = "$_dir/app_woman.png";
  static const appChat2 = "$_dir/app_chat2.png";
  static const appAddBlack = "$_dir/app_add_black.png";
  static const appAddBlack2 = "$_dir/app_add_black2.png";
  static const appEncrypt = "$_dir/app_encrypt.png";
  static const appRadioSel = "$_dir/app_radio_sel.png";
  static const appSendMessage2 = "$_dir/app_send_message2.png";
  static const appMenuTranslate = "$_dir/app_menu_translate.png";
  static const appMenuUnTranslate = "$_dir/app_menu_untranslate.png";
  static const appTranslateLoading = "$_dir/app_translate_loading.gif";
  static const appAdd = "$_dir/app_add.png";
  static const appNotification = "$_dir/app_notification.png";
  static const appSuccess = "$_dir/app_success.png";
  static const appMenuTts = "$_dir/app_menu_tts.png";
  static const appMenuUnTts = "$_dir/app_menu_untts.png";
  static const appWarn = "$_dir/app_warn.png";
  static const appAdd2 = "$_dir/app_add2.png";
  static const appSwitch = "$_dir/app_switch.png";
  static const appChecked2 = "$_dir/app_checked2.png";
  static const appAdd3 = "$_dir/app_add3.png";
  static const appAiMarker = "$_dir/app_ai_marker.png";
  static const appMyPoints = "$_dir/app_my_points.png";
  static const appMyPointsBg = "$_dir/app_my_points_bg.png";
  static const appSemicircle = "$_dir/app_semicircle.png";
  static const appSignInTask = "$_dir/app_sign_in_task.png";
  static const appInviteTask = "$_dir/app_invite_task.png";
  static const appChatTask = "$_dir/app_chat_task.png";
  static const appUnfold = "$_dir/app_unfold.png";
  static const appToolboxSearch = "$_dir/app_toolbox_search.png";
  static const files = "$_dir/files.png";
  static const add = "$_dir/add.png";
  static const dialogSuccess = "$_dir/dialog_success.png";
  static const like = "$_dir/like.png";
  static const like2 = "$_dir/like2.png";
  static const likeActive = "$_dir/like_active.png";
  static const collect = "$_dir/collect.png";
  static const comment = "$_dir/comment.png";
  static const editComment = "$_dir/edit_comment.png";
  static const reprintArticle = "$_dir/reprint_article.png";
  static const loading = "$_dir/loading.gif";
  static const addFriendTobeGroup2 = "$_dir/ic_add_friend_tobe_group2.png";
  static const callVoice2 = "$_dir/ic_call_voice2.png";
  static const callVideo2 = "$_dir/ic_call_video2.png";
  static const miti = "$_dir/miti.jpg";
  static const invite = "$_dir/invite.png";
  static const inviteBg = "$_dir/invite_bg.png";
  static const iDinvite = "$_dir/id_invite.png";
  static const qrcodeInvite = "$_dir/qrcode_invite.png";
  static const urlInvite = "$_dir/url_invite.png";
  static const inviteEmpty = "$_dir/invite_empty.png";
  static const mitiidBg = "$_dir/mitiid_bg.png";
}
