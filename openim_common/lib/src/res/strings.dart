import 'dart:ui';

import 'package:get/get.dart';

import 'lang/en_US.dart';
import 'lang/zh_CN.dart';
import 'lang/ja_JP.dart';
import 'lang/ko_KR.dart';
import 'lang/es_ES.dart';

class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static const fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'zh_CN': zh_CN,
        'ja_JP': ja_JP,
        'ko_KR': ko_KR,
        'es_ES': es_ES,
      };
}

class StrRes {
  StrRes._();

  static String get welcome => 'welcome'.tr;

  static String get phoneNumber => 'phoneNumber'.tr;

  static String get plsEnterPhoneNumber => 'plsEnterPhoneNumber'.tr;

  static String get password => 'password'.tr;

  static String get plsEnterPassword => 'plsEnterPassword'.tr;

  static String get account => 'account'.tr;

  static String get plsEnterAccount => 'plsEnterAccount'.tr;

  // static String get plsEnterEmail => 'plsEnterEmail'.tr;

  static String get forgetPassword => 'forgetPassword'.tr;

  static String get verificationCodeLogin => 'verificationCodeLogin'.tr;

  static String get login => 'login'.tr;

  static String get noAccountYet => 'noAccountYet'.tr;

  static String get loginNow => 'loginNow'.tr;

  static String get registerNow => 'registerNow'.tr;

  static String get lockPwdErrorHint => 'lockPwdErrorHint'.tr;

  static String get newUserRegister => 'newUserRegister'.tr;

  static String get verificationCode => 'verificationCode'.tr;

  static String get sendVerificationCode => 'sendVerificationCode'.tr;

  static String get resendVerificationCode => 'resendVerificationCode'.tr;

  static String get verificationCodeTimingReminder =>
      'verificationCodeTimingReminder'.tr;

  static String get defaultVerificationCode => 'defaultVerificationCode'.tr;

  static String get plsEnterVerificationCode => 'plsEnterVerificationCode'.tr;

  static String get invitationCode => 'invitationCode'.tr;

  static String get plsEnterInvitationCode => 'plsEnterInvitationCode'.tr;

  static String get optional => 'optional'.tr;

  static String get nextStep => 'nextStep'.tr;

  static String get plsEnterRightPhone => 'plsEnterRightPhone'.tr;

  static String get plsEnterRightPhoneOrEmail => 'plsEnterRightPhoneOrEmail'.tr;

  static String get enterVerificationCode => 'enterVerificationCode'.tr;

  static String get setPassword => 'setPassword'.tr;

  static String get plsConfirmPasswordAgain => 'plsConfirmPasswordAgain'.tr;

  static String get confirmPassword => 'confirmPassword'.tr;

  static String get wrongPasswordFormat => 'wrongPasswordFormat'.tr;

  static String get plsCompleteInfo => 'plsCompleteInfo'.tr;

  static String get plsEnterYourNickname => 'plsEnterYourNickname'.tr;

  static String get setInfo => 'setInfo'.tr;

  static String get loginPwdFormat => 'loginPwdFormat'.tr;

  static String get passwordLogin => 'passwordLogin'.tr;

  static String get through => 'through'.tr;

  static String get home => 'home'.tr;

  static String get contacts => 'contacts'.tr;

  static String get workbench => 'workbench'.tr;

  static String get mine => 'mine'.tr;

  static String get draftText => 'draftText'.tr;

  static String get everyone => 'everyone'.tr;

  static String get you => 'you'.tr;

  static String get groupAc => 'groupAc'.tr;

  static String get createGroupNtf => 'createGroupNtf'.tr;

  static String get editGroupInfoNtf => 'editGroupInfoNtf'.tr;

  static String get quitGroupNtf => 'quitGroupNtf'.tr;

  static String get invitedJoinGroupNtf => 'invitedJoinGroupNtf'.tr;

  static String get kickedGroupNtf => 'kickedGroupNtf'.tr;

  static String get joinGroupNtf => 'joinGroupNtf'.tr;

  static String get dismissGroupNtf => 'dismissGroupNtf'.tr;

  static String get transferredGroupNtf => 'transferredGroupNtf'.tr;

  static String get muteMemberNtf => 'muteMemberNtf'.tr;

  static String get muteCancelMemberNtf => 'muteCancelMemberNtf'.tr;

  static String get muteGroupNtf => 'muteGroupNtf'.tr;

  static String get muteCancelGroupNtf => 'muteCancelGroupNtf'.tr;

  static String get friendAddedNtf => 'friendAddedNtf'.tr;

  static String get openPrivateChatNtf => 'openPrivateChatNtf'.tr;

  static String get closePrivateChatNtf => 'closePrivateChatNtf'.tr;

  static String get memberInfoChangedNtf => 'memberInfoChangedNtf'.tr;

  static String get unsupportedMessage => 'unsupportedMessage'.tr;

  static String get picture => 'picture'.tr;

  static String get video => 'video'.tr;

  static String get voice => 'voice'.tr;

  static String get location => 'location'.tr;

  static String get file => 'file'.tr;

  static String get carte => 'carte'.tr;

  static String get emoji => 'emoji'.tr;

  static String get chatRecord => 'chatRecord'.tr;

  static String get revokeMsg => 'revokeMsg'.tr;

  static String get aRevokeBMsg => 'aRevokeBMsg'.tr;

  static String get blockedByFriendHint => 'blockedByFriendHint'.tr;

  static String get deletedByFriendHint => 'deletedByFriendHint'.tr;

  static String get sendFriendVerification => 'sendFriendVerification'.tr;

  static String get removedFromGroupHint => 'removedFromGroupHint'.tr;

  static String get groupDisbanded => 'groupDisbanded'.tr;

  static String get search => 'search'.tr;

  static String get synchronizing => 'synchronizing'.tr;

  static String get syncFailed => 'syncFailed'.tr;

  static String get connecting => 'connecting'.tr;

  static String get connectionFailed => 'connectionFailed'.tr;

  static String get top => 'top'.tr;

  static String get cancelTop => 'cancelTop'.tr;

  static String get markHasRead => 'markHasRead'.tr;

  static String get delete => 'delete'.tr;

  static String get nPieces => 'nPieces'.tr;

  static String get online => 'online'.tr;

  static String get offline => 'offline'.tr;

  static String get phoneOnline => 'phoneOnline'.tr;

  static String get pcOnline => 'pcOnline'.tr;

  static String get webOnline => 'webOnline'.tr;

  static String get webMiniOnline => 'webMiniOnline'.tr;

  static String get upgradeFind => 'upgradeFind'.tr;

  static String get upgradeVersion => 'upgradeVersion'.tr;

  static String get upgradeDescription => 'upgradeDescription'.tr;

  static String get upgradeIgnore => 'upgradeIgnore'.tr;

  static String get upgradeLater => 'upgradeLater'.tr;

  static String get upgradeNow => 'upgradeNow'.tr;

  static String get upgradePermissionTips => 'upgradePermissionTips'.tr;

  static String get inviteYouCall => 'inviteYouCall'.tr;

  static String get rejectCall => 'rejectCall'.tr;

  static String get acceptCall => 'acceptCall'.tr;

  static String get callVoice => 'callVoice'.tr;

  static String get callVideo => 'callVideo'.tr;

  static String get sentSuccessfully => 'sentSuccessfully'.tr;

  static String get copySuccessfully => 'copySuccessfully'.tr;

  static String get day => 'day'.tr;

  static String get hour => 'hour'.tr;

  static String get hours => 'hours'.tr;

  static String get minute => 'minute'.tr;

  static String get seconds => 'seconds'.tr;

  static String get cancel => 'cancel'.tr;

  static String get determine => 'determine'.tr;

  static String get toolboxAlbum => 'toolboxAlbum'.tr;

  static String get toolboxCall => 'toolboxCall'.tr;

  static String get toolboxCamera => 'toolboxCamera'.tr;

  static String get toolboxCard => 'toolboxCard'.tr;

  static String get toolboxFile => 'toolboxFile'.tr;

  static String get toolboxLocation => 'toolboxLocation'.tr;

  static String get send => 'send'.tr;

  static String get holdTalk => 'holdTalk'.tr;

  static String get releaseToSend => 'releaseToSend'.tr;

  static String get releaseToSendSwipeUpToCancel =>
      'releaseToSendSwipeUpToCancel'.tr;

  static String get liftFingerToCancelSend => 'liftFingerToCancelSend'.tr;

  static String get callDuration => 'callDuration'.tr;

  static String get cancelled => 'cancelled'.tr;

  static String get cancelledByCaller => 'cancelledByCaller'.tr;

  static String get rejectedByCaller => 'rejectedByCaller'.tr;

  static String get callTimeout => 'callTimeout'.tr;

  static String get rejected => 'rejected'.tr;

  static String get networkAnomaly => 'networkAnomaly'.tr;

  static String get forwardMaxCountHint => 'forwardMaxCountHint'.tr;

  static String get typing => 'typing'.tr;

  static String get addSuccessfully => 'addSuccessfully'.tr;

  static String get addFailed => 'addFailed'.tr;

  static String get setSuccessfully => 'setSuccessfully'.tr;

  static String get callingBusy => 'callingBusy'.tr;

  static String get groupCallHint => 'groupCallHint'.tr;

  static String get joinIn => 'joinIn'.tr;

  static String get menuCopy => 'menuCopy'.tr;

  static String get menuDel => 'menuDel'.tr;

  static String get menuForward => 'menuForward'.tr;

  static String get menuReply => 'menuReply'.tr;

  static String get menuMulti => 'menuMulti'.tr;

  static String get menuRevoke => 'menuRevoke'.tr;

  static String get menuAdd => 'menuAdd'.tr;

  static String get nMessage => 'nMessage'.tr;

  static String get plsSelectLocation => 'plsSelectLocation'.tr;

  static String get groupAudioCallHint => 'groupAudioCallHint'.tr;

  static String get groupVideoCallHint => 'groupVideoCallHint'.tr;

  static String get reEdit => 'reEdit'.tr;

  static String get download => 'download'.tr;

  static String get playSpeed => 'playSpeed'.tr;

  static String get googleMap => 'googleMap'.tr;

  static String get appleMap => 'appleMap'.tr;

  static String get baiduMap => 'baiduMap'.tr;

  static String get amapMap => 'amapMap'.tr;

  static String get tencentMap => 'tencentMap'.tr;

  static String get offlineMeetingMessage => 'offlineMeetingMessage'.tr;

  static String get offlineMessage => 'offlineMessage'.tr;

  static String get offlineCallMessage => 'offlineCallMessage'.tr;

  static String get logoutHint => 'logoutHint'.tr;

  static String get myInfo => 'myInfo'.tr;

  static String get workingCircle => 'workingCircle'.tr;

  static String get accountSetup => 'accountSetup'.tr;

  static String get aboutUs => 'aboutUs'.tr;

  static String get logout => 'logout'.tr;

  static String get qrcode => 'qrcode'.tr;

  static String get qrcodeHint => 'qrcodeHint'.tr;

  static String get favoriteFace => 'favoriteFace'.tr;

  static String get favoriteManage => 'favoriteManage'.tr;

  static String get favoriteCount => 'favoriteCount'.tr;

  static String get favoriteDel => 'favoriteDel'.tr;

  static String get hasRead => 'hasRead'.tr;

  static String get unread => 'unread'.tr;

  static String get nPersonUnRead => 'nPersonUnRead'.tr;

  static String get allRead => 'allRead'.tr;

  static String get messageRecipientList => 'messageRecipientList'.tr;

  static String get hasReadCount => 'hasReadCount'.tr;

  static String get unreadCount => 'unreadCount'.tr;

  static String get newFriend => 'newFriend'.tr;

  static String get newGroup => 'newGroup'.tr;

  static String get newGroupRequest => 'newGroupRequest'.tr;

  static String get myFriend => 'myFriend'.tr;

  static String get myGroup => 'myGroup'.tr;

  static String get add => 'add'.tr;

  static String get scan => 'scan'.tr;

  static String get scanHint => 'scanHint'.tr;

  static String get addFriend => 'addFriend'.tr;

  static String get addFriendHint => 'addFriendHint'.tr;

  static String get createGroup => 'createGroup'.tr;

  static String get createGroupHint => 'createGroupHint'.tr;

  static String get addGroup => 'addGroup'.tr;

  static String get addGroupHint => 'addGroupHint'.tr;

  static String get searchIDAddFriend => 'searchIDAddFriend'.tr;

  static String get searchIDAddGroup => 'searchIDAddGroup'.tr;

  static String get searchIDIs => 'searchIDIs'.tr;

  static String get searchPhoneIs => 'searchPhoneIs'.tr;

  static String get searchEmailIs => 'searchEmailIs'.tr;

  static String get searchNicknameIs => 'searchNicknameIs'.tr;

  static String get searchGroupNicknameIs => 'searchGroupNicknameIs'.tr;

  static String get noFoundUser => 'noFoundUser'.tr;

  static String get noFoundGroup => 'noFoundGroup'.tr;

  static String get joinGroupMethod => 'joinGroupMethod'.tr;

  static String get joinGroupDate => 'joinGroupDate'.tr;

  static String get byInviteJoinGroup => 'byInviteJoinGroup'.tr;

  static String get byIDJoinGroup => 'byIDJoinGroup'.tr;

  static String get byQrcodeJoinGroup => 'byQrcodeJoinGroup'.tr;

  static String get groupID => 'groupID'.tr;

  static String get setAsAdmin => 'setAsAdmin'.tr;

  static String get setMute => 'setMute'.tr;

  static String get organizationInfo => 'organizationInfo'.tr;

  static String get organization => 'organization'.tr;

  static String get department => 'department'.tr;

  static String get position => 'position'.tr;

  static String get personalInfo => 'personalInfo'.tr;

  static String get audioAndVideoCall => 'audioAndVideoCall'.tr;

  static String get sendMessage => 'sendMessage'.tr;

  static String get viewDynamics => 'viewDynamics'.tr;

  static String get avatar => 'avatar'.tr;

  static String get name => 'name'.tr;

  static String get nickname => 'nickname'.tr;

  static String get gender => 'gender'.tr;

  static String get englishName => 'englishName'.tr;

  static String get birthDay => 'birthDay'.tr;

  static String get tel => 'tel'.tr;

  static String get mobile => 'mobile'.tr;

  static String get email => 'email'.tr;

  static String get man => 'man'.tr;

  static String get woman => 'woman'.tr;

  static String get friendSetup => 'friendSetup'.tr;

  static String get setupRemark => 'setupRemark'.tr;

  static String get recommendToFriend => 'recommendToFriend'.tr;

  static String get addToBlacklist => 'addToBlacklist'.tr;

  static String get unfriend => 'unfriend'.tr;

  static String get areYouSureDelFriend => 'areYouSureDelFriend'.tr;

  static String get areYouSureAddBlacklist => 'areYouSureAddBlacklist'.tr;

  static String get remark => 'remark'.tr;

  static String get save => 'save'.tr;

  static String get saveSuccessfully => 'saveSuccessfully'.tr;

  static String get saveFailed => 'saveFailed'.tr;

  static String get groupVerification => 'groupVerification'.tr;

  static String get friendVerification => 'friendVerification'.tr;

  static String get sendEnterGroupApplication => 'sendEnterGroupApplication'.tr;

  static String get sendToBeFriendApplication => 'sendToBeFriendApplication'.tr;

  static String get sendSuccessfully => 'sendSuccessfully'.tr;

  static String get sendFailed => 'sendFailed'.tr;

  static String get canNotAddFriends => 'canNotAddFriends'.tr;

  static String get mutedAll => 'mutedAll'.tr;

  static String get tenMinutes => 'tenMinutes'.tr;

  static String get oneHour => 'oneHour'.tr;

  static String get twelveHours => 'twelveHours'.tr;

  static String get oneDay => 'oneDay'.tr;

  static String get custom => 'custom'.tr;

  static String get unmute => 'unmute'.tr;

  static String get youMuted => 'youMuted'.tr;

  static String get groupMuted => 'groupMuted'.tr;

  static String get notDisturbMode => 'notDisturbMode'.tr;

  static String get allowRing => 'allowRing'.tr;

  static String get allowVibrate => 'allowVibrate'.tr;

  static String get forbidAddMeToFriend => 'forbidAddMeToFriend'.tr;

  static String get blacklist => 'blacklist'.tr;

  static String get unlockSettings => 'unlockSettings'.tr;

  static String get changePassword => 'changePassword'.tr;

  static String get clearChatHistory => 'clearChatHistory'.tr;

  static String get confirmClearChatHistory => 'confirmClearChatHistory'.tr;

  static String get languageSetup => 'languageSetup'.tr;

  static String get language => 'language'.tr;

  static String get english => 'english'.tr;

  static String get chinese => 'chinese'.tr;

  static String get followSystem => 'followSystem'.tr;

  static String get blacklistEmpty => 'blacklistEmpty'.tr;

  static String get remove => 'remove'.tr;

  static String get fingerprint => 'fingerprint'.tr;

  static String get gesture => 'gesture'.tr;

  static String get biometrics => 'biometrics'.tr;

  static String get plsEnterPwd => 'plsEnterPwd'.tr;

  static String get plsEnterOldPwd => 'plsEnterOldPwd'.tr;

  static String get plsEnterNewPwd => 'plsEnterNewPwd'.tr;

  static String get plsConfirmNewPwd => 'plsConfirmNewPwd'.tr;

  static String get reset => 'reset'.tr;

  static String get oldPwd => 'oldPwd'.tr;

  static String get newPwd => 'newPwd'.tr;

  static String get confirmNewPwd => 'confirmNewPwd'.tr;

  static String get plsEnterConfirmPwd => 'plsEnterConfirmPwd'.tr;

  static String get twicePwdNoSame => 'twicePwdNoSame'.tr;

  static String get changedSuccessfully => 'changedSuccessfully'.tr;

  static String get checkNewVersion => 'checkNewVersion'.tr;

  static String get chatContent => 'chatContent'.tr;

  static String get topContacts => 'topContacts'.tr;

  static String get messageNotDisturb => 'messageNotDisturb'.tr;

  static String get messageNotDisturbHint => 'messageNotDisturbHint'.tr;

  static String get burnAfterReading => 'burnAfterReading'.tr;

  static String get timeSet => 'timeSet'.tr;

  static String get setChatBackground => 'setChatBackground'.tr;

  static String get fontSize => 'fontSize'.tr;

  static String get little => 'little'.tr;

  static String get standard => 'standard'.tr;

  static String get big => 'big'.tr;

  static String get thirtySeconds => 'thirtySeconds'.tr;

  static String get fiveMinutes => 'fiveMinutes'.tr;

  static String get clearAll => 'clearAll'.tr;

  static String get clearSuccessfully => 'clearSuccessfully'.tr;

  static String get groupChatSetup => 'groupChatSetup'.tr;

  static String get viewAllGroupMembers => 'viewAllGroupMembers'.tr;

  static String get groupManage => 'groupManage'.tr;

  static String get myGroupMemberNickname => 'myGroupMemberNickname'.tr;

  static String get topChat => 'topChat'.tr;

  static String get muteAllMember => 'muteAllMember'.tr;

  static String get exitGroup => 'exitGroup'.tr;

  static String get dismissGroup => 'dismissGroup'.tr;

  static String get dismissGroupHint => 'dismissGroupHint'.tr;

  static String get quitGroupHint => 'quitGroupHint'.tr;

  static String get joinGroupSet => 'joinGroupSet'.tr;

  static String get allowAnyoneJoinGroup => 'allowAnyoneJoinGroup'.tr;

  static String get inviteNotVerification => 'inviteNotVerification'.tr;

  static String get needVerification => 'needVerification'.tr;

  static String get addMember => 'addMember'.tr;

  static String get delMember => 'delMember'.tr;

  static String get groupOwner => 'groupOwner'.tr;

  static String get groupAdmin => 'groupAdmin'.tr;

  static String get notAllowSeeMemberProfile => 'notAllowSeeMemberProfile'.tr;

  static String get notAllAddMemberToBeFriend => 'notAllAddMemberToBeFriend'.tr;

  static String get transferGroupOwnerRight => 'transferGroupOwnerRight'.tr;

  // static String get plsEnterRightEmail => 'plsEnterRightEmail'.tr;

  static String get groupName => 'groupName'.tr;

  static String get groupAcPermissionTips => 'groupAcPermissionTips'.tr;

  static String get plsEnterGroupAc => 'plsEnterGroupAc'.tr;

  static String get edit => 'edit'.tr;

  static String get publish => 'publish'.tr;

  static String get groupMember => 'groupMember'.tr;

  static String get selectedPeopleCount => 'selectedPeopleCount'.tr;

  static String get confirmSelectedPeople => 'confirmSelectedPeople'.tr;

  static String get confirm => 'confirm'.tr;

  static String get confirmTransferGroupToUser =>
      'confirmTransferGroupToUser'.tr;

  static String get removeGroupMember => 'removeGroupMember'.tr;

  static String get searchNotResult => 'searchNotResult'.tr;

  static String get groupQrcode => 'groupQrcode'.tr;

  static String get groupQrcodeHint => 'groupQrcodeHint'.tr;

  static String get approved => 'approved'.tr;

  static String get accept => 'accept'.tr;

  static String get reject => 'reject'.tr;

  static String get waitingForVerification => 'waitingForVerification'.tr;

  static String get rejectSuccessfully => 'rejectSuccessfully'.tr;

  static String get rejectFailed => 'rejectFailed'.tr;

  static String get applyJoin => 'applyJoin'.tr;

  static String get enterGroup => 'enterGroup'.tr;

  static String get applyReason => 'applyReason'.tr;

  static String get invite => 'invite'.tr;

  static String get sourceFrom => 'sourceFrom'.tr;

  static String get byMemberInvite => 'byMemberInvite'.tr;

  static String get bySearch => 'bySearch'.tr;

  static String get byScanQrcode => 'byScanQrcode'.tr;

  static String get iCreatedGroup => 'iCreatedGroup'.tr;

  static String get iJoinedGroup => 'iJoinedGroup'.tr;

  static String get nPerson => 'nPerson'.tr;

  static String get searchNotFound => 'searchNotFound'.tr;

  static String get organizationStructure => 'organizationStructure'.tr;

  static String get recentConversations => 'recentConversations'.tr;

  static String get selectAll => 'selectAll'.tr;

  static String get plsEnterGroupNameHint => 'plsEnterGroupNameHint'.tr;

  static String get completeCreation => 'completeCreation'.tr;

  static String get sendCarteConfirmHint => 'sendCarteConfirmHint'.tr;

  static String get sentSeparatelyTo => 'sentSeparatelyTo'.tr;

  static String get sentTo => 'sentTo'.tr;

  static String get leaveMessage => 'leaveMessage'.tr;

  static String get mergeForwardHint => 'mergeForwardHint'.tr;

  static String get mergeForward => 'mergeForward'.tr;

  static String get quicklyFindChatHistory => 'quicklyFindChatHistory'.tr;

  static String get notFoundChatHistory => 'notFoundChatHistory'.tr;

  static String get globalSearchAll => 'globalSearchAll'.tr;

  static String get globalSearchContacts => 'globalSearchContacts'.tr;

  static String get globalSearchGroup => 'globalSearchGroup'.tr;

  static String get globalSearchChatHistory => 'globalSearchChatHistory'.tr;

  static String get globalSearchChatFile => 'globalSearchChatFile'.tr;

  static String get relatedChatHistory => 'relatedChatHistory'.tr;

  static String get seeMoreRelatedContacts => 'seeMoreRelatedContacts'.tr;

  static String get seeMoreRelatedGroup => 'seeMoreRelatedGroup'.tr;

  static String get seeMoreRelatedChatHistory => 'seeMoreRelatedChatHistory'.tr;

  static String get seeMoreRelatedFile => 'seeMoreRelatedFile'.tr;

  static String get publishPicture => 'publishPicture'.tr;

  static String get publishVideo => 'publishVideo'.tr;

  static String get mentioned => 'mentioned'.tr;

  static String get comment => 'comment'.tr;

  static String get like => 'like'.tr;

  static String get reply => 'reply'.tr;

  static String get rollUp => 'rollUp'.tr;

  static String get fullText => 'fullText'.tr;

  static String get selectAssetsFromCamera => 'selectAssetsFromCamera'.tr;

  static String get selectAssetsFromAlbum => 'selectAssetsFromAlbum'.tr;

  static String get whoCanWatch => 'whoCanWatch'.tr;

  static String get remindWhoToWatch => 'remindWhoToWatch'.tr;

  static String get public => 'public'.tr;

  static String get everyoneCanSee => 'everyoneCanSee'.tr;

  static String get partiallyVisible => 'partiallyVisible'.tr;

  static String get visibleToTheSelected => 'visibleToTheSelected'.tr;

  static String get partiallyInvisible => 'partiallyInvisible'.tr;

  static String get invisibleToTheSelected => 'invisibleToTheSelected'.tr;

  static String get private => 'private'.tr;

  static String get onlyVisibleToMe => 'onlyVisibleToMe'.tr;

  static String get selectVideoLimit => 'selectVideoLimit'.tr;

  static String get selectContactsLimit => 'selectContactsLimit'.tr;

  static String get message => 'message'.tr;

  static String get commentedYou => 'commentedYou'.tr;
  static String get commentedWho => 'commentedWho'.tr;

  static String get likedYou => 'likedYou'.tr;

  static String get mentionedYou => 'mentionedYou'.tr;
  static String get mentionedWho => 'mentionedWho'.tr;

  static String get replied => 'replied'.tr;

  static String get detail => 'detail'.tr;

  static String get totalNPicture => 'totalNPicture'.tr;

  static String get noDynamic => 'noDynamic'.tr;

  static String get callRecords => 'callRecords'.tr;

  static String get allCall => 'allCall'.tr;

  static String get missedCall => 'missedCall'.tr;

  static String get incomingCall => 'incomingCall'.tr;

  static String get outgoingCall => 'outgoingCall'.tr;

  static String get microphone => 'microphone'.tr;

  static String get speaker => 'speaker'.tr;

  static String get hangUp => 'hangUp'.tr;

  static String get pickUp => 'pickUp'.tr;

  static String get waitingCallHint => 'waitingCallHint'.tr;

  static String get waitingVoiceCallHint => 'waitingVoiceCallHint'.tr;

  static String get invitedVoiceCallHint => 'invitedVoiceCallHint'.tr;

  static String get waitingVideoCallHint => 'waitingVideoCallHint'.tr;

  static String get invitedVideoCallHint => 'invitedVideoCallHint'.tr;

  static String get waitingToAnswer => 'waitingToAnswer'.tr;

  static String get invitedYouToCall => 'invitedYouToCall'.tr;

  static String get calling => 'calling'.tr;

  static String get nPeopleCalling => 'nPeopleCalling'.tr;

  static String get busyVideoCallHint => 'busyVideoCallHint'.tr;

  static String get whoInvitedVoiceCallHint => 'whoInvitedVoiceCallHint'.tr;

  static String get whoInvitedVideoCallHint => 'whoInvitedVideoCallHint'.tr;

  static String get plsInputMeetingSubject => 'plsInputMeetingSubject'.tr;

  static String get meetingStartTime => 'meetingStartTime'.tr;

  static String get meetingDuration => 'meetingDuration'.tr;

  static String get enterMeeting => 'enterMeeting'.tr;

  static String get meetingNo => 'meetingNo'.tr;

  static String get yourMeetingName => 'yourMeetingName'.tr;

  static String get plsInputMeetingNo => 'plsInputMeetingNo'.tr;

  static String get plsInputYouMeetingName => 'plsInputYouMeetingName'.tr;

  static String get meetingSubjectIs => 'meetingSubjectIs'.tr;

  static String get meetingStartTimeIs => 'meetingStartTimeIs'.tr;

  static String get meetingDurationIs => 'meetingDurationIs'.tr;

  static String get meetingHostIs => 'meetingHostIs'.tr;

  static String get meetingNoIs => 'meetingNoIs'.tr;

  static String get meetingMessageClickHint => 'meetingMessageClickHint'.tr;

  static String get meetingMessage => 'meetingMessage'.tr;

  static String get openMeeting => 'openMeeting'.tr;

  static String get didNotStart => 'didNotStart'.tr;

  static String get started => 'started'.tr;

  static String get meetingInitiatorIs => 'meetingInitiatorIs'.tr;

  static String get meetingDetail => 'meetingDetail'.tr;

  static String get meetingOrganizerIs => 'meetingOrganizerIs'.tr;

  static String get updateMeetingInfo => 'updateMeetingInfo'.tr;

  static String get cancelMeeting => 'cancelMeeting'.tr;

  static String get videoMeeting => 'videoMeeting'.tr;

  static String get joinMeeting => 'joinMeeting'.tr;

  static String get bookAMeeting => 'bookAMeeting'.tr;

  static String get quickMeeting => 'quickMeeting'.tr;

  static String get confirmTheChanges => 'confirmTheChanges'.tr;

  static String get invitesYouToVideoConference =>
      'invitesYouToVideoConference'.tr;

  static String get over => 'over'.tr;

  static String get meetingMute => 'meetingMute'.tr;

  static String get meetingUnmute => 'meetingUnmute'.tr;

  static String get meetingCloseVideo => 'meetingCloseVideo'.tr;

  static String get meetingOpenVideo => 'meetingOpenVideo'.tr;

  static String get meetingEndSharing => 'meetingEndSharing'.tr;

  static String get meetingShareScreen => 'meetingShareScreen'.tr;

  static String get meetingMembers => 'meetingMembers'.tr;

  static String get settings => 'settings'.tr;

  static String get leaveMeeting => 'leaveMeeting'.tr;

  static String get endMeeting => 'endMeeting'.tr;

  static String get leaveMeetingConfirmHint => 'leaveMeetingConfirmHint'.tr;

  static String get endMeetingConfirmHit => 'endMeetingConfirmHit'.tr;

  static String get meetingSettings => 'meetingSettings'.tr;

  static String get allowMembersOpenMic => 'allowMembersOpenMic'.tr;

  static String get allowMembersOpenVideo => 'allowMembersOpenVideo'.tr;

  static String get onlyHostShareScreen => 'onlyHostShareScreen'.tr;

  static String get onlyHostInviteMember => 'onlyHostInviteMember'.tr;

  static String get defaultMuteMembers => 'defaultMuteMembers'.tr;

  static String get pinThisMember => 'pinThisMember'.tr;

  static String get unpinThisMember => 'unpinThisMember'.tr;

  static String get allSeeHim => 'allSeeHim'.tr;

  static String get cancelAllSeeHim => 'cancelAllSeeHim'.tr;

  static String get muteAll => 'muteAll'.tr;

  static String get unmuteAll => 'unmuteAll'.tr;

  static String get members => 'members'.tr;

  static String get screenShare => 'screenShare'.tr;

  static String get screenShareHint => 'screenShareHint'.tr;

  static String get meetingClosedHint => 'meetingClosedHint'.tr;

  static String get meetingIsOver => 'meetingIsOver'.tr;

  static String get networkError => 'networkError'.tr;

  static String get shareSuccessfully => 'shareSuccessfully'.tr;

  static String get notFoundMinP => 'notFoundMinP'.tr;

  static String get notSendMessageNotInGroup => 'notSendMessageNotInGroup'.tr;

  static String get whoModifyGroupName => 'whoModifyGroupName'.tr;

  static String get accountWarn => 'accountWarn'.tr;

  static String get accountException => 'accountException'.tr;

  static String get tagGroup => 'tagGroup'.tr;

  static String get issueNotice => 'issueNotice'.tr;

  static String get createTagGroup => 'createTagGroup'.tr;

  static String get plsEnterTagGroupName => 'plsEnterTagGroupName'.tr;

  static String get tagGroupMember => 'tagGroupMember'.tr;

  static String get completeEdit => 'completeEdit'.tr;

  static String get emptyTagGroup => 'emptyTagGroup'.tr;

  static String get confirmDelTagGroupHint => 'confirmDelTagGroupHint'.tr;

  static String get editTagGroup => 'editTagGroup'.tr;

  static String get newBuild => 'newBuild'.tr;

  static String get receiveMember => 'receiveMember'.tr;

  static String get emptyNotification => 'emptyNotification'.tr;

  static String get notificationReceiver => 'notificationReceiver'.tr;

  static String get sendAnother => 'sendAnother'.tr;

  static String get confirmDelTagNotificationHint =>
      'confirmDelTagNotificationHint'.tr;

  static String get contentNotBlank => 'contentNotBlank'.tr;

  static String get plsEnterDescription => 'plsEnterDescription'.tr;

  static String get gifNotSupported => 'gifNotSupported'.tr;

  static String get lookOver => 'lookOver'.tr;

  static String get groupRequestHandled => 'groupRequestHandled'.tr;

  static String get burnAfterReadingDescription =>
      'burnAfterReadingDescription'.tr;

  static String get periodicallyDeleteMessage => 'periodicallyDeleteMessage'.tr;

  static String get periodicallyDeleteMessageDescription =>
      'periodicallyDeleteMessageDescription'.tr;

  static String get nDay => 'nDay'.tr;

  static String get nWeek => 'nWeek'.tr;

  static String get nMonth => 'nMonth'.tr;

  static String get talkTooShort => 'talkTooShort'.tr;

  static String get quoteContentBeRevoked => 'quoteContentBeRevoked'.tr;

  static String get tapTooShort => 'tapTooShort'.tr;
  static String get createGroupTips => 'createGroupTips'.tr;
  static String get likedWho => 'likedWho'.tr;
  static String get otherCallHandle => 'otherCallHandle'.tr;
  static String get uploadErrorLog => 'uploadErrorLog'.tr;
  static String get uploaded => 'uploaded'.tr;

  static String get sdkApiAddress => 'sdkApiAddress'.tr;
  static String get sdkWsAddress => 'sdkWsAddress'.tr;
  static String get appAddress => 'appAddress'.tr;
  static String get serverAddress => 'serverAddress'.tr;
  static String get switchToIP => 'switchToIP'.tr;
  static String get switchToDomain => 'switchToDomain'.tr;
  static String get serverSettingTips => 'serverSettingTips'.tr;
  static String get callFail => 'callFail'.tr;

  // 新增
  static String get privacyPolicyDescription => 'privacyPolicyDescription'.tr;
  static String get moments => 'moments'.tr;
  static String get changeStyle => 'changeStyle'.tr;
  static String get saveImg => 'saveImg'.tr;
  static String get toolboxSnapchat => 'toolboxSnapchat'.tr;
  static String get faceRecognition => 'faceRecognition'.tr;
  static String get pwdTips => 'pwdTips'.tr;
  static String get chat => 'chat'.tr;
  static String get changeGroupName => 'changeGroupName'.tr;
  static String get groupSearch => 'groupSearch'.tr;
  static String get saveToContact => 'saveToContact'.tr;
  static String get chatEncryption => 'chatEncryption'.tr;
  static String get showGroupMemberNickname => 'showGroupMemberNickname'.tr;
  static String get complaint => 'complaint'.tr;
  static String get privacyPolicyDescriptionP1 =>
      'privacyPolicyDescriptionP1'.tr;
  static String get privacyPolicyDescriptionP2 =>
      'privacyPolicyDescriptionP2'.tr;
  static String get privacyPolicyDescriptionP3 =>
      'privacyPolicyDescriptionP3'.tr;
  static String get privacyPolicyDescriptionP4 =>
      'privacyPolicyDescriptionP4'.tr;
  static String get createBot => 'createBot'.tr;
  static String get toolboxGroupNote => 'toolboxGroupNote'.tr;
  static String get toolboxVote => 'toolboxVote'.tr;
  static String get chatSearch => 'chatSearch'.tr;
  static String get encryption => 'encryption'.tr;
  static String get remind => 'remind'.tr;
  static String get discover => 'discover'.tr;
  static String get tips => 'tips'.tr;
  static String get momentsDraftTips => 'momentsDraftTips'.tr;
  static String get saveAlias => 'saveAlias'.tr;
  static String get noSaveAlias => 'noSaveAlias'.tr;
  static String get commentedWho2 => 'commentedWho2'.tr;
  static String get likedWho2 => 'likedWho2'.tr;
  static String get productView => 'productView'.tr;
  static String get fanGroup => 'fanGroup'.tr;
  static String get countOfProduct => 'countOfProduct'.tr;
  static String get countOfFanGroup => 'countOfFanGroup'.tr;
  static String get remarkAndLabel => 'remarkAndLabel'.tr;
  static String get friendPermissions => 'friendPermissions'.tr;
  static String get moreInfo => 'moreInfo'.tr;
  static String get nicknameAndAvatar => 'nicknameAndAvatar'.tr;
  static String get training => 'training'.tr;
  static String get changeAvatar => 'changeAvatar'.tr;
  static String get startTrain => 'startTrain'.tr;
  static String get question => 'question'.tr;
  static String get answer => 'answer'.tr;
  static String get temp1 => 'temp1'.tr;
  static String get myLocation => 'myLocation'.tr;
  static String get audio => 'audio'.tr;
  static String get link => 'link'.tr;
  static String get follow => 'follow'.tr;
  static String get upgradeDefaultDescription => 'upgradeDefaultDescription'.tr;
  static String get copyFail => 'copyFail'.tr;
  static String get uploadMyLogs => 'uploadMyLogs'.tr;
  static String get uploadFail => 'uploadFail'.tr;
  static String get developing => 'developing'.tr;
  static String get encryptTips => 'encryptTips'.tr;
  static String get translate => 'translate'.tr;
  static String get unTranslate => 'unTranslate'.tr;
  static String get noWorking => 'noWorking'.tr;
  static String get autoTranslate => 'autoTranslate'.tr;
  static String get targetLang => 'targetLang'.tr;
  static String get translateFail => 'translateFail'.tr;
  static String get zh_CN => 'zh_CN'.tr;
  static String get ja_JP => 'ja_JP'.tr;
  static String get en_US => 'en_US'.tr;
  static String get auto => 'auto'.tr;
  static String get ko_KR => 'ko_KR'.tr;
  static String get fr_FR => 'fr_FR'.tr;
  static String get pt_PT => 'pt_PT'.tr;
  static String get zh_TW => 'zh_TW'.tr;
  static String get zh_HK => 'zh_HK'.tr;
  static String get it_IT => 'it_IT'.tr;
  static String get ru_RU => 'ru_RU'.tr;
  static String get de_DE => 'de_DE'.tr;
  static String get es_ES => 'es_ES'.tr;
  static String get th_TH => 'th_TH'.tr;
  static String get English => 'English'.tr;
  static String get Spanish => 'Spanish'.tr;
  static String get French => 'French'.tr;
  static String get German => 'German'.tr;
  static String get Italian => 'Italian'.tr;
  static String get Portuguese => 'Portuguese'.tr;
  static String get Dutch => 'Dutch'.tr;
  static String get Russian => 'Russian'.tr;
  static String get Swedish => 'Swedish'.tr;
  static String get Polish => 'Polish'.tr;
  static String get Danish => 'Danish'.tr;
  static String get Norwegian => 'Norwegian'.tr;
  static String get Irish => 'Irish'.tr;
  static String get Greek => 'Greek'.tr;
  static String get Finnish => 'Finnish'.tr;
  static String get Czech => 'Czech'.tr;
  static String get Hungarian => 'Hungarian'.tr;
  static String get Romanian => 'Romanian'.tr;
  static String get Bulgarian => 'Bulgarian'.tr;
  static String get Slovak => 'Slovak'.tr;
  static String get Slovenian => 'Slovenian'.tr;
  static String get Estonian => 'Estonian'.tr;
  static String get Latvian => 'Latvian'.tr;
  static String get Lithuanian => 'Lithuanian'.tr;
  static String get Maltese => 'Maltese'.tr;
  static String get Icelandic => 'Icelandic'.tr;
  static String get Albanian => 'Albanian'.tr;
  static String get Croatian => 'Croatian'.tr;
  static String get Serbian => 'Serbian'.tr;
  static String get SimplifiedChinese => 'SimplifiedChinese'.tr;
  static String get TraditionalChinese => 'TraditionalChinese'.tr;
  static String get Japanese => 'Japanese'.tr;
  static String get Korean => 'Korean'.tr;
  static String get Arabic => 'Arabic'.tr;
  static String get Hindi => 'Hindi'.tr;
  static String get Bengali => 'Bengali'.tr;
  static String get Thai => 'Thai'.tr;
  static String get Vietnamese => 'Vietnamese'.tr;
  static String get Indonesian => 'Indonesian'.tr;
  static String get Malay => 'Malay'.tr;
  static String get Tamil => 'Tamil'.tr;
  static String get Urdu => 'Urdu'.tr;
  static String get Filipino => 'Filipino'.tr;
  static String get Persian => 'Persian'.tr;
  static String get Hebrew => 'Hebrew'.tr;
  static String get Turkish => 'Turkish'.tr;
  static String get Kannada => 'Kannada'.tr;
  static String get Malayalam => 'Malayalam'.tr;
  static String get Sindhi => 'Sindhi'.tr;
  static String get Punjabi => 'Punjabi'.tr;
  static String get Nepali => 'Nepali'.tr;
  static String get Swahili => 'Swahili'.tr;
  static String get Amharic => 'Amharic'.tr;
  static String get Zulu => 'Zulu'.tr;
  static String get Somali => 'Somali'.tr;
  static String get Hausa => 'Hausa'.tr;
  static String get Igbo => 'Igbo'.tr;
  static String get Yoruba => 'Yoruba'.tr;
  static String get Quechua => 'Quechua'.tr;
  static String get Guarani => 'Guarani'.tr;
  static String get Maori => 'Maori'.tr;
  static String get Esperanto => 'Esperanto'.tr;
  static String get Latin => 'Latin'.tr;
  static String get success => 'success'.tr;
  static String get someFail => 'someFail'.tr;
  static String get allSuccess => 'allSuccess'.tr;
  static String get plsEnterEmail => 'plsEnterEmail'.tr;
  static String get plsEnterRightEmail => 'plsEnterRightEmail'.tr;
  static String get register => 'register'.tr;
  static String get downloading => 'downloading'.tr;
  static String get downloadFail => 'downloadFail'.tr;
  static String get uploadImLog => 'uploadImLog'.tr;
  static String get uploadImLogByDate => 'uploadImLogByDate'.tr;
  static String get uploadAppLog => 'uploadAppLog'.tr;
  static String get uploadAppLogByDate => 'uploadAppLogByDate'.tr;
  static String get updateOn => 'updateOn'.tr;
  static String get japanese => 'japanese'.tr;
  static String get korean => 'korean'.tr;
  static String get spanish => 'spanish'.tr;
  static String get discoverTab => 'discoverTab'.tr;
  static String get friend => 'friend'.tr;
  static String get publishMoment => 'publishMoment'.tr;
  static String get phoneRegister => 'phoneRegister'.tr;
  static String get emailRegister => 'emailRegister'.tr;
  static String get useEmailRegister => 'useEmailRegister'.tr;
  static String get usePhoneRegister => 'usePhoneRegister'.tr;
  static String get accountAndSecurity => 'accountAndSecurity'.tr;
  static String get noBind => 'noBind'.tr;
  static String get curBindPhone => 'curBindPhone'.tr;
  static String get curBindEmail => 'curBindEmail'.tr;
  static String get changePhone => 'changePhone'.tr;
  static String get changeEmail => 'changeEmail'.tr;
  static String get confirmChange => 'confirmChange'.tr;
  static String get changeSuccessTips => 'changeSuccessTips'.tr;
  static String get backLogin => 'backLogin'.tr;
  static String get tts => 'tts'.tr;
  static String get hide => 'hide'.tr;
  static String get bindPhone => 'bindPhone'.tr;
  static String get bindEmail => 'bindEmail'.tr;
  static String get deleteUser => 'deleteUser'.tr;
  static String get deleteUserTips1 => 'deleteUserTips1'.tr;
  static String get deleteUserTips2 => 'deleteUserTips2'.tr;
  static String get deleteUserTips3 => 'deleteUserTips3'.tr;
  static String get deleteUserTips4 => 'deleteUserTips4'.tr;
  static String get deleteUserModalTitle => 'deleteUserModalTitle'.tr;
  static String get deleteUserModalTips => 'deleteUserModalTips'.tr;
  static String get deleteUserModalBtn1 => 'deleteUserModalBtn1'.tr;
  static String get deleteUserModalBtn2 => 'deleteUserModalBtn2'.tr;
  static String get deleteUserSuccess => 'deleteUserSuccess'.tr;
  static String get deleteUserSuccessTips => 'deleteUserSuccessTips'.tr;
  static String get finishAndLogout => 'finishAndLogout'.tr;
  static String get complaintReason => 'complaintReason'.tr;
  static String get harassmentContent => 'harassmentContent'.tr;
  static String get accountHacked => 'accountHacked'.tr;
  static String get infringement => 'infringement'.tr;
  static String get impersonation => 'impersonation'.tr;
  static String get minorRightsViolation => 'minorRightsViolation'.tr;
  static String get imageEvidence => 'imageEvidence'.tr;
  static String get complaintDetails => 'complaintDetails'.tr;
  static String get submit => 'submit'.tr;
  static String get submitSuccess => 'submitSuccess'.tr;
  static String get promiseResponse => 'promiseResponse'.tr;
  static String get backHome => 'backHome'.tr;
  static String get userAgreement => 'userAgreement'.tr;
  static String get privacyPolicy => 'privacyPolicy'.tr;
  static String get userAgreement1 => 'userAgreement1'.tr;
static String get userAgreement2 => 'userAgreement2'.tr;
static String get userAgreement3 => 'userAgreement3'.tr;
static String get userAgreement4 => 'userAgreement4'.tr;
static String get userAgreement5 => 'userAgreement5'.tr;
static String get userAgreement6 => 'userAgreement6'.tr;
static String get userAgreement7 => 'userAgreement7'.tr;
static String get userAgreement8 => 'userAgreement8'.tr;
static String get userAgreement9 => 'userAgreement9'.tr;
static String get userAgreement10 => 'userAgreement10'.tr;
static String get userAgreement11 => 'userAgreement11'.tr;
static String get userAgreement12 => 'userAgreement12'.tr;
static String get userAgreement13 => 'userAgreement13'.tr;
static String get userAgreement14 => 'userAgreement14'.tr;
static String get userAgreement15 => 'userAgreement15'.tr;
static String get userAgreement16 => 'userAgreement16'.tr;
static String get userAgreement17 => 'userAgreement17'.tr;
static String get userAgreement18 => 'userAgreement18'.tr;
static String get userAgreement19 => 'userAgreement19'.tr;
static String get userAgreement20 => 'userAgreement20'.tr;
static String get userAgreement21 => 'userAgreement21'.tr;
static String get userAgreement22 => 'userAgreement22'.tr;
static String get userAgreement23 => 'userAgreement23'.tr;
static String get userAgreement24 => 'userAgreement24'.tr;
static String get userAgreement25 => 'userAgreement25'.tr;
static String get userAgreement26 => 'userAgreement26'.tr;
static String get userAgreement27 => 'userAgreement27'.tr;
static String get userAgreement28 => 'userAgreement28'.tr;
static String get userAgreement29 => 'userAgreement29'.tr;
static String get userAgreement30 => 'userAgreement30'.tr;
static String get userAgreement31 => 'userAgreement31'.tr;
static String get userAgreement32 => 'userAgreement32'.tr;
static String get userAgreement33 => 'userAgreement33'.tr;
static String get userAgreement34 => 'userAgreement34'.tr;
static String get userAgreement35 => 'userAgreement35'.tr;
static String get userAgreement36 => 'userAgreement36'.tr;
static String get userAgreement37 => 'userAgreement37'.tr;
static String get userAgreement38 => 'userAgreement38'.tr;
static String get userAgreement39 => 'userAgreement39'.tr;
static String get userAgreement40 => 'userAgreement40'.tr;
static String get userAgreement41 => 'userAgreement41'.tr;
static String get userAgreement42 => 'userAgreement42'.tr;
static String get userAgreement43 => 'userAgreement43'.tr;
static String get userAgreement44 => 'userAgreement44'.tr;
static String get userAgreement45 => 'userAgreement45'.tr;
static String get userAgreement46 => 'userAgreement46'.tr;
static String get userAgreement47 => 'userAgreement47'.tr;
static String get userAgreement48 => 'userAgreement48'.tr;
static String get userAgreement49 => 'userAgreement49'.tr;
static String get userAgreement50 => 'userAgreement50'.tr;
static String get userAgreement51 => 'userAgreement51'.tr;
static String get userAgreement52 => 'userAgreement52'.tr;
static String get userAgreement53 => 'userAgreement53'.tr;
static String get userAgreement54 => 'userAgreement54'.tr;
static String get privacyPolicy1 => 'privacyPolicy1'.tr;
static String get privacyPolicy2 => 'privacyPolicy2'.tr;
static String get privacyPolicy3 => 'privacyPolicy3'.tr;
static String get privacyPolicy4 => 'privacyPolicy4'.tr;
static String get privacyPolicy5 => 'privacyPolicy5'.tr;
static String get privacyPolicy6 => 'privacyPolicy6'.tr;
static String get privacyPolicy7 => 'privacyPolicy7'.tr;
static String get privacyPolicy8 => 'privacyPolicy8'.tr;
static String get privacyPolicy9 => 'privacyPolicy9'.tr;
static String get privacyPolicy10 => 'privacyPolicy10'.tr;
static String get privacyPolicy11 => 'privacyPolicy11'.tr;
static String get privacyPolicy12 => 'privacyPolicy12'.tr;
static String get privacyPolicy13 => 'privacyPolicy13'.tr;
static String get privacyPolicy14 => 'privacyPolicy14'.tr;
static String get privacyPolicy15 => 'privacyPolicy15'.tr;
static String get privacyPolicy16 => 'privacyPolicy16'.tr;
static String get privacyPolicy17 => 'privacyPolicy17'.tr;
static String get privacyPolicy18 => 'privacyPolicy18'.tr;
static String get privacyPolicy19 => 'privacyPolicy19'.tr;
static String get privacyPolicy20 => 'privacyPolicy20'.tr;
static String get privacyPolicy21 => 'privacyPolicy21'.tr;
static String get privacyPolicy22 => 'privacyPolicy22'.tr;
static String get privacyPolicy23 => 'privacyPolicy23'.tr;
static String get privacyPolicy24 => 'privacyPolicy24'.tr;
static String get privacyPolicy25 => 'privacyPolicy25'.tr;
static String get privacyPolicy26 => 'privacyPolicy26'.tr;
static String get privacyPolicy27 => 'privacyPolicy27'.tr;
static String get privacyPolicy28 => 'privacyPolicy28'.tr;
static String get privacyPolicy29 => 'privacyPolicy29'.tr;
static String get privacyPolicy30 => 'privacyPolicy30'.tr;
static String get privacyPolicy31 => 'privacyPolicy31'.tr;
static String get privacyPolicy32 => 'privacyPolicy32'.tr;
static String get privacyPolicy33 => 'privacyPolicy33'.tr;
static String get privacyPolicy34 => 'privacyPolicy34'.tr;
static String get privacyPolicy35 => 'privacyPolicy35'.tr;
static String get privacyPolicy36 => 'privacyPolicy36'.tr;
static String get privacyPolicy37 => 'privacyPolicy37'.tr;
static String get privacyPolicy38 => 'privacyPolicy38'.tr;
static String get privacyPolicy39 => 'privacyPolicy39'.tr;
static String get privacyPolicy40 => 'privacyPolicy40'.tr;
static String get privacyPolicy41 => 'privacyPolicy41'.tr;
static String get privacyPolicy42 => 'privacyPolicy42'.tr;
static String get privacyPolicy43 => 'privacyPolicy43'.tr;
static String get privacyPolicy44 => 'privacyPolicy44'.tr;
static String get privacyPolicy45 => 'privacyPolicy45'.tr;
static String get privacyPolicy46 => 'privacyPolicy46'.tr;
static String get privacyPolicy47 => 'privacyPolicy47'.tr;
static String get privacyPolicy48 => 'privacyPolicy48'.tr;
static String get privacyPolicy49 => 'privacyPolicy49'.tr;
static String get privacyPolicy50 => 'privacyPolicy50'.tr;
static String get privacyPolicy51 => 'privacyPolicy51'.tr;
static String get privacyPolicy52 => 'privacyPolicy52'.tr;
static String get privacyPolicy53 => 'privacyPolicy53'.tr;
static String get privacyPolicy54 => 'privacyPolicy54'.tr;
static String get privacyPolicy55 => 'privacyPolicy55'.tr;
static String get privacyPolicy56 => 'privacyPolicy56'.tr;
static String get privacyPolicy57 => 'privacyPolicy57'.tr;
static String get privacyPolicy58 => 'privacyPolicy58'.tr;
static String get privacyPolicy59 => 'privacyPolicy59'.tr;
static String get privacyPolicy60 => 'privacyPolicy60'.tr;
static String get privacyPolicy61 => 'privacyPolicy61'.tr;
static String get privacyPolicy62 => 'privacyPolicy62'.tr;
static String get privacyPolicy63 => 'privacyPolicy63'.tr;
static String get privacyPolicy64 => 'privacyPolicy64'.tr;
static String get privacyPolicy65 => 'privacyPolicy65'.tr;
static String get privacyPolicy66 => 'privacyPolicy66'.tr;
static String get privacyPolicy67 => 'privacyPolicy67'.tr;
static String get privacyPolicy68 => 'privacyPolicy68'.tr;
static String get privacyPolicy69 => 'privacyPolicy69'.tr;
static String get privacyPolicy70 => 'privacyPolicy70'.tr;
static String get privacyPolicy71 => 'privacyPolicy71'.tr;
static String get privacyPolicy72 => 'privacyPolicy72'.tr;
static String get privacyPolicy73 => 'privacyPolicy73'.tr;
static String get privacyPolicy74 => 'privacyPolicy74'.tr;
static String get privacyPolicy75 => 'privacyPolicy75'.tr;
static String get privacyPolicy76 => 'privacyPolicy76'.tr;
static String get privacyPolicy77 => 'privacyPolicy77'.tr;
static String get privacyPolicy78 => 'privacyPolicy78'.tr;
static String get privacyPolicy79 => 'privacyPolicy79'.tr;
static String get privacyPolicy80 => 'privacyPolicy80'.tr;
static String get privacyPolicy81 => 'privacyPolicy81'.tr;
static String get privacyPolicy82 => 'privacyPolicy82'.tr;
static String get privacyPolicy83 => 'privacyPolicy83'.tr;
static String get privacyPolicy84 => 'privacyPolicy84'.tr;
static String get privacyPolicy85 => 'privacyPolicy85'.tr;
static String get privacyPolicy86 => 'privacyPolicy86'.tr;
static String get privacyPolicy87 => 'privacyPolicy87'.tr;
static String get privacyPolicy88 => 'privacyPolicy88'.tr;
static String get privacyPolicy89 => 'privacyPolicy89'.tr;
static String get privacyPolicy90 => 'privacyPolicy90'.tr;
static String get privacyPolicy91 => 'privacyPolicy91'.tr;
static String get privacyPolicy92 => 'privacyPolicy92'.tr;
static String get privacyPolicy93 => 'privacyPolicy93'.tr;
static String get privacyPolicy94 => 'privacyPolicy94'.tr;
static String get privacyPolicy95 => 'privacyPolicy95'.tr;
static String get privacyPolicy96 => 'privacyPolicy96'.tr;
static String get privacyPolicy97 => 'privacyPolicy97'.tr;
static String get privacyPolicy98 => 'privacyPolicy98'.tr;
static String get privacyPolicy99 => 'privacyPolicy99'.tr;
static String get privacyPolicy100 => 'privacyPolicy100'.tr;
static String get privacyPolicy101 => 'privacyPolicy101'.tr;
static String get privacyPolicy102 => 'privacyPolicy102'.tr;
static String get privacyPolicy103 => 'privacyPolicy103'.tr;
static String get privacyPolicy104 => 'privacyPolicy104'.tr;
static String get privacyPolicy105 => 'privacyPolicy105'.tr;
static String get privacyPolicy106 => 'privacyPolicy106'.tr;
static String get privacyPolicy107 => 'privacyPolicy107'.tr;
static String get privacyPolicy108 => 'privacyPolicy108'.tr;
static String get privacyPolicy109 => 'privacyPolicy109'.tr;
static String get privacyPolicy110 => 'privacyPolicy110'.tr;
static String get privacyPolicy111 => 'privacyPolicy111'.tr;
static String get privacyPolicy112 => 'privacyPolicy112'.tr;
static String get privacyPolicy113 => 'privacyPolicy113'.tr;
static String get privacyPolicy114 => 'privacyPolicy114'.tr;
static String get privacyPolicy115 => 'privacyPolicy115'.tr;
static String get privacyPolicy116 => 'privacyPolicy116'.tr;
static String get privacyPolicy117 => 'privacyPolicy117'.tr;
static String get privacyPolicy118 => 'privacyPolicy118'.tr;
static String get privacyPolicy33_1 => 'privacyPolicy33_1'.tr;
static String get privacyPolicy33_2 => 'privacyPolicy33_2'.tr;
static String get privacyPolicy36_1 => 'privacyPolicy36_1'.tr;
static String get privacyPolicy36_2 => 'privacyPolicy36_2'.tr;
static String get privacyPolicy37_1 => 'privacyPolicy37_1'.tr;
static String get privacyPolicy37_2 => 'privacyPolicy37_2'.tr;
static String get privacyPolicy41_1 => 'privacyPolicy41_1'.tr;
static String get privacyPolicy41_2 => 'privacyPolicy41_2'.tr;
static String get privacyPolicy42_1 => 'privacyPolicy42_1'.tr;
static String get privacyPolicy42_2 => 'privacyPolicy42_2'.tr;
static String get privacyPolicy43_1 => 'privacyPolicy43_1'.tr;
static String get privacyPolicy43_2 => 'privacyPolicy43_2'.tr;
static String get privacyPolicy44_1 => 'privacyPolicy44_1'.tr;
static String get privacyPolicy44_2 => 'privacyPolicy44_2'.tr;
static String get privacyPolicy52_1 => 'privacyPolicy52_1'.tr;
static String get privacyPolicy52_2 => 'privacyPolicy52_2'.tr;
static String get privacyPolicy75_1 => 'privacyPolicy75_1'.tr;
static String get privacyPolicy75_2 => 'privacyPolicy75_2'.tr;
static String get privacyPolicy84_1 => 'privacyPolicy84_1'.tr;
static String get privacyPolicy84_2 => 'privacyPolicy84_2'.tr;
static String get privacyPolicy95_1 => 'privacyPolicy95_1'.tr;
static String get privacyPolicy95_2 => 'privacyPolicy95_2'.tr;

static String get recentlyAdd => 'recentlyAdd'.tr;
static String get aiFriends => 'aiFriends'.tr;
static String get momentsAndStatus => 'momentsAndStatus'.tr;
static String get confirmDelMoment => 'confirmDelMoment'.tr;
static String get plsAgree => 'plsAgree'.tr;
static String get curPwd => 'curPwd'.tr;
static String get newPhone => 'newPhone'.tr;
static String get newEmail => 'newEmail'.tr;
static String get required => 'required'.tr;
static String get plsEnterInvitationCode2 => 'plsEnterInvitationCode2'.tr;
static String get recentRequests => 'recentRequests'.tr;
static String get accountManage => 'accountManage'.tr;
static String get addOrRegisterAccount => 'addOrRegisterAccount'.tr;
static String get fail => 'fail'.tr;
static String get addAccountServer => 'addAccountServer'.tr;
static String get addAccountServerTips => 'addAccountServerTips'.tr;
static String get serverFormatErr => 'serverFormatErr'.tr;
static String get serverErr => 'serverErr'.tr;
static String get accountErr => 'accountErr'.tr;
static String get switchSuccess => 'switchSuccess'.tr;
static String get registerSuccess => 'registerSuccess'.tr;
static String get loginSuccess => 'loginSuccess'.tr;
static String get loading => 'loading'.tr;
static String get confirmDelAccount => 'confirmDelAccount'.tr;
static String get switchServer => 'switchServer'.tr;
static String get defaultNotification => 'defaultNotification'.tr;
static String get defaultImgNotification => 'defaultImgNotification'.tr;
static String get defaultVideoNotification => 'defaultVideoNotification'.tr;
static String get defaultVoiceNotification => 'defaultVoiceNotification'.tr;
static String get defaultFileNotification => 'defaultFileNotification'.tr;
static String get defaultLocationNotification => 'defaultLocationNotification'.tr;
static String get defaultMergeNotification => 'defaultMergeNotification'.tr;
static String get defaultCardNotification => 'defaultCardNotification'.tr;
static String get defaultNotificationTitle => 'defaultNotificationTitle'.tr;
static String get myPoints => 'myPoints'.tr;
static String get rulesTitle => 'rulesTitle'.tr;
static String get earningTitle => 'earningTitle'.tr;
static String get dailySignIn => 'dailySignIn'.tr;
static String get inviteFriends => 'inviteFriends'.tr;
static String get aiAgentInteraction => 'aiAgentInteraction'.tr;
static String get signedIn => 'signedIn'.tr;
static String get invite2 => 'invite2'.tr;
static String get interact => 'interact'.tr;
static String get history => 'history'.tr;
static String get allRecords => 'allRecords'.tr;
static String get signInReward => 'signInReward'.tr;
static String get copy => 'copy'.tr;
static String get generateInviteCode => 'generateInviteCode'.tr;
static String get inviteCodeCost => 'inviteCodeCost'.tr;
static String get historicalInviteCodes => 'historicalInviteCodes'.tr;
static String get longPressToCopy => 'longPressToCopy'.tr;
static String get pendingUse => 'pendingUse'.tr;
static String get used => 'used'.tr;
static String get inviteToJoin => 'inviteToJoin'.tr;
static String get invitationReason => 'invitationReason'.tr;
static String get whatAreMitiToken => 'whatAreMitiToken'.tr;
static String get welcomeMessage => 'welcomeMessage'.tr;
static String get earningTitle2 => 'earningTitle2'.tr;
static String get dailyPlatform => 'dailyPlatform'.tr;
static String get signInBracket => 'signInBracket'.tr;
static String get engageAI => 'engageAI'.tr;
static String get effectiveInteraction => 'effectiveInteraction'.tr;
static String get successful => 'successful'.tr;
static String get inviteBracket => 'inviteBracket'.tr;
static String get newUsers => 'newUsers'.tr;
static String get consumingMitiToken => 'consumingMitiToken'.tr;
static String get exchangeNotice => 'exchangeNotice'.tr;
static String get futureUse => 'futureUse'.tr;
static String get earningTable => 'earningTable'.tr;
static String get activityType => 'activityType'.tr;
static String get specificActivity => 'specificActivity'.tr;
static String get userActivityReward => 'userActivityReward'.tr;
static String get interactionReward => 'interactionReward'.tr;
static String get invitationReward => 'invitationReward'.tr;
static String get dailySignInReward => 'dailySignInReward'.tr;
static String get consecutiveSignIns => 'consecutiveSignIns'.tr;
static String get dailySignIn2 => 'dailySignIn2'.tr;
static String get interactingWithAIDigitalBeings =>
    'interactingWithAIDigitalBeings'.tr;
static String get successfulInvitationReward =>
    'successfulInvitationReward'.tr;
static String get invitedUserActivityLevel => 'invitedUserActivityLevel'.tr;
static String get earnPerSignIn => 'earnPerSignIn'.tr;
static String get extraForConsecutiveSignIns =>
    'extraForConsecutiveSignIns'.tr;
static String get signInPageDetails => 'signInPageDetails'.tr;
static String get earnPerInteraction => 'earnPerInteraction'.tr;
static String get dailyLimit => 'dailyLimit'.tr;
static String get earningsFromInvitedUser => 'earningsFromInvitedUser'.tr;
static String get inviterEarning => 'inviterEarning'.tr;
static String get consecutiveSignIn => 'consecutiveSignIn'.tr;
static String get signInSuccess => 'signInSuccess'.tr;
static String get congratulations => 'congratulations'.tr;
static String get mitiToken => 'mitiToken'.tr;
static String get acknowledged => 'acknowledged'.tr;

static String get pointRules => 'pointRules'.tr;
static String get search2 => 'search2'.tr;
static String get createAi => 'createAi'.tr;
static String get trainAi => 'trainAi'.tr;
static String get knowledgebaseFiles => 'knowledgebaseFiles'.tr;
static String get trainSuccessTips => 'trainSuccessTips'.tr;
static String get trainFailTips => 'trainFailTips'.tr;
static String get iKnow => 'iKnow'.tr;
static String get trainFileTips1 => 'trainFileTips1'.tr;
static String get trainFileTips2 => 'trainFileTips2'.tr;
static String get trainInputTips => 'trainInputTips'.tr;
static String get knowledgebase => 'knowledgebase'.tr;
static String get select => 'select'.tr;
static String get selectKnowledgebase => 'selectKnowledgebase'.tr;
static String get pleaseUpgradeAiOrOpenKnowledgebase => 'pleaseUpgradeAiOrOpenKnowledgebase'.tr;
}
