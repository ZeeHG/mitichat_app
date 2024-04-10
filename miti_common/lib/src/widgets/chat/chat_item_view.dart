import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:miti_common/src/widgets/chat/chat_quote_view.dart';
import 'package:rxdart/rxdart.dart';
import 'package:markdown_widget/markdown_widget.dart';

double maxWidth = 219.w;
double maxWidthContainer = 243.w;
double pictureWidth = 120.w;
double videoWidth = 120.w;
double locationWidth = 220.w;

BorderRadius borderRadius(bool isISend) => BorderRadius.only(
      topLeft: Radius.circular(isISend ? 6.r : 6.r),
      topRight: Radius.circular(isISend ? 6.r : 6.r),
      bottomLeft: Radius.circular(6.r),
      bottomRight: Radius.circular(6.r),
    );

class MsgStreamEv<T> {
  final String id;
  final T value;

  MsgStreamEv({required this.id, required this.value});

  @override
  String toString() {
    return 'MsgStreamEv{msgId: $id, value: $value}';
  }
}

class CustomTypeInfo {
  final Widget customView;
  final bool needBubbleBackground;
  final bool needChatItemContainer;

  CustomTypeInfo(
    this.customView, [
    this.needBubbleBackground = true,
    this.needChatItemContainer = true,
  ]);
}

typedef CustomTypeBuilder = CustomTypeInfo? Function(
  BuildContext context,
  Message message,
);
typedef NotificationTypeBuilder = Widget? Function(
  BuildContext context,
  Message message,
);
typedef ItemViewBuilder = Widget? Function(
  BuildContext context,
  Message message,
);
typedef ItemVisibilityChange = void Function(
  Message message,
  bool visible,
);

class ChatItemView extends StatefulWidget {
  const ChatItemView({
    super.key,
    this.mediaItemBuilder,
    this.itemViewBuilder,
    this.customTypeBuilder,
    this.notificationTypeBuilder,
    // required this.clickSubject,
    this.sendStatusSubject,
    this.sendProgressSubject,
    this.visibilityChange,
    this.timelineStr,
    this.leftNickname,
    this.leftFaceUrl,
    this.rightNickname,
    this.rightFaceUrl,
    required this.message,
    this.textScaleFactor = 1.0,
    this.readingDuration = 30,
    // required this.isBubbleMsg,
    this.isMultiSelMode = false,
    this.enabledReadStatus = true,
    this.isPrivateChat = false,
    this.showLongPressMenu = true,
    this.isPlayingSound = false,
    this.canReEdit = false,
    this.ignorePointer = false,
    this.enabledAddEmojiMenu = true,
    this.enabledCopyMenu = true,
    this.enabledDelMenu = true,
    this.enabledForwardMenu = true,
    this.enabledMultiMenu = true,
    this.enabledReplyMenu = true,
    this.enabledRevokeMenu = true,
    this.showLeftNickname = true,
    this.showRightNickname = false,
    this.enabledTranslateMenu = false,
    this.enabledUnTranslateMenu = false,
    this.enabledTtsMenu = false,
    this.enabledUnTtsMenu = false,
    this.onTapAddEmojiMenu,
    this.highlightColor,
    this.allAtMap = const {},
    this.patterns = const [],
    this.checkedList = const [],
    this.onTapLeftAvatar,
    this.onTapRightAvatar,
    this.onLongPressLeftAvatar,
    this.onLongPressRightAvatar,
    this.onTapMultiMenu,
    this.onTapCopyMenu,
    this.onTapDelMenu,
    this.onTapForwardMenu,
    this.onTapReplyMenu,
    this.onTapRevokeMenu,
    this.onTapTranslateMenu,
    this.onTapUnTranslateMenu,
    this.onTapTtsMenu,
    this.onTapUnTtsMenu,
    this.onVisibleTrulyText,
    this.onPopMenuShowChanged,
    this.onTapQuoteMessage,
    this.onMultiSelChanged,
    this.onDestroyMessage,
    this.onViewMessageReadStatus,
    this.onFailedToResend,
    this.onReEit,
    this.closePopMenuSubject,
    this.onClickItemView,
    this.ChatFileDownloadProgressView,
    this.showRead,
  });
  final ItemViewBuilder? mediaItemBuilder;
  final ItemViewBuilder? itemViewBuilder;
  final CustomTypeBuilder? customTypeBuilder;
  final NotificationTypeBuilder? notificationTypeBuilder;
  final bool? showRead;

  // final Subject<Message> clickSubject;
  final Subject<MsgStreamEv<bool>>? sendStatusSubject;
  final Subject<MsgStreamEv<int>>? sendProgressSubject;

  // final Subject<MsgStreamEv<double>> downloadProgressSubject;
  final ItemVisibilityChange? visibilityChange;
  final String? timelineStr;
  final String? leftNickname;
  final String? leftFaceUrl;
  final String? rightNickname;
  final String? rightFaceUrl;
  final Message message;

  /// 文字缩放系数
  final double textScaleFactor;

  /// 阅读时长s
  final int readingDuration;

  // final bool isBubbleMsg;
  final bool isMultiSelMode;
  final bool enabledReadStatus;

  /// 是否开启阅后即焚
  final bool isPrivateChat;

  /// 显示长按菜单
  final bool showLongPressMenu;

  /// 当前播放的语音消息
  final bool isPlayingSound;
  final bool canReEdit;

  /// 禁止pop菜单 ，如禁言的时候
  final bool ignorePointer;
  final bool enabledCopyMenu;
  final bool enabledDelMenu;
  final bool enabledForwardMenu;
  final bool enabledReplyMenu;
  final bool enabledRevokeMenu;
  final bool enabledMultiMenu;
  final bool enabledAddEmojiMenu;
  final bool showLeftNickname;
  final bool showRightNickname;
  final bool enabledTranslateMenu;
  final bool enabledUnTranslateMenu;
  final bool enabledTtsMenu;
  final bool enabledUnTtsMenu;

  ///
  final Color? highlightColor;
  final Map<String, String> allAtMap;
  final List<MatchPattern> patterns;
  final List<Message> checkedList;
  final Function()? onTapLeftAvatar;
  final Function()? onTapRightAvatar;
  final Function()? onLongPressLeftAvatar;
  final Function()? onLongPressRightAvatar;
  final Function()? onTapCopyMenu;
  final Function()? onTapDelMenu;
  final Function()? onTapTranslateMenu;
  final Function()? onTapUnTranslateMenu;
  final Function()? onTapTtsMenu;
  final Function()? onTapUnTtsMenu;
  final Function()? onTapForwardMenu;
  final Function()? onTapReplyMenu;
  final Function()? onTapRevokeMenu;
  final Function()? onTapMultiMenu;
  final Function()? onTapAddEmojiMenu;
  final Function(String? text)? onVisibleTrulyText;
  final Function(bool show)? onPopMenuShowChanged;
  final Function(Message message)? onTapQuoteMessage;
  final Function(bool checked)? onMultiSelChanged;
  final Function()? onClickItemView;

  /// 阅后即焚回调
  final Function()? onDestroyMessage;

  /// 预览群消息已读状态
  final Function()? onViewMessageReadStatus;

  /// 失败重发
  final Function()? onFailedToResend;
  final Function()? onReEit;

  /// 点击系统软键盘返回键关闭菜单
  final Subject<bool>? closePopMenuSubject;

  /// 文件下载精度
  final Widget? ChatFileDownloadProgressView;

  @override
  State<ChatItemView> createState() => _ChatItemViewState();
}

class _ChatItemViewState extends State<ChatItemView> {
  final _popupCtrl = CustomPopupMenuController();
  final _popupTranslateMenuCtrl = CustomPopupMenuController();
  final betaTestLogic = Get.find<BetaTestLogic>();

  Message get _message => widget.message;

  bool get _isISend => _message.sendID == OpenIM.iMManager.userID;

  bool get _isChecked => widget.checkedList.contains(_message);
  late StreamSubscription<bool> _keyboardSubs;
  StreamSubscription<bool>? _closeMenuSubs;

  bool get showMd =>
      (_message.isTextType || _message.isAtTextType) &&
      betaTestLogic.isBot(_message.sendID ?? "") &&
      betaTestLogic.openChatMd.value;

  @override
  void dispose() {
    _popupCtrl.dispose();
    _popupTranslateMenuCtrl.dispose();
    _keyboardSubs.cancel();
    _closeMenuSubs?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    final keyboardVisibilityCtrl = KeyboardVisibilityController();

    // Subscribe
    _keyboardSubs = keyboardVisibilityCtrl.onChange.listen((bool visible) {
      _popupCtrl.hideMenu();
      _popupTranslateMenuCtrl.hideMenu();
    });

    _popupCtrl.addListener(() {
      widget.onPopMenuShowChanged?.call(_popupCtrl.menuIsShowing);
    });

    _popupTranslateMenuCtrl.addListener(() {
      widget.onPopMenuShowChanged?.call(_popupCtrl.menuIsShowing);
    });

    _closeMenuSubs = widget.closePopMenuSubject?.listen((value) {
      if (value == true) {
        _popupCtrl.hideMenu();
        _popupTranslateMenuCtrl.hideMenu();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      child: Container(
        color: widget.highlightColor,
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Center(child: _child),
      ),
      onVisibilityLost: () {
        widget.visibilityChange?.call(widget.message, false);
      },
      onVisibilityGained: () {
        widget.visibilityChange?.call(widget.message, true);
      },
    );
  }

  Widget get _child =>
      widget.itemViewBuilder?.call(context, _message) ?? _buildChildView();

  Widget _buildMarkdown({String? text}) {
    final config =
        _isISend ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        children: MarkdownGenerator(
          linesMargin: EdgeInsets.all(0),
        ).buildWidgets(
            null != text
                ? text
                : _message.isTextType
                    ? _message.textElem!.content!
                    : MitiUtils.replaceMessageAtMapping(_message, {}),
            config: config.copy(configs: [
              PConfig(
                textStyle: _isISend
                    ? StylesLibrary.ts_FFFFFF_16sp
                    : StylesLibrary.ts_333333_16sp,
              ),
              ListConfig(
                  marker: (bool isOrdered, int depth, int index) =>
                      getDefaultMarker(
                          isOrdered,
                          depth,
                          _isISend
                              ? StylesLibrary.c_FFFFFF
                              : StylesLibrary.c_000000,
                          index,
                          12,
                          config))
            ])),
      ),
    );
  }

  onSelectionChanged(CustomPopupMenuController popupCtrl,
      {SelectedContent? selectedContent}) async {
    // 防止输入框焦点切换到选择文本焦点导致菜单列表闪一下
    await Future.delayed(const Duration(milliseconds: 50));
    if (null != selectedContent) {
      popupCtrl.showMenu();
    } else {
      popupCtrl.hideMenu();
    }
  }

  Widget _buildChildView() {
    Widget? child;
    String? senderNickname;
    String? senderFaceURL;
    bool isBubbleBg = false;
    /* if (_message.isCallType) {
    } else if (_message.isMeetingType) {
    } else if (_message.isDeletedByFriendType) {
    } else if (_message.isBlockedByFriendType) {
    } else if (_message.isEmojiType) {
    } else if (_message.isTagType) {
    }*/
    if (_message.isTextType) {
      isBubbleBg = true;
      child = ChatText(
        text: _message.textElem!.content!,
        patterns: widget.patterns,
        textScaleFactor: widget.textScaleFactor,
        onVisibleTrulyText: widget.onVisibleTrulyText,
        isISend: _isISend,
        selectMode: true,
        onSelectionChanged: ({SelectedContent? selectedContent}) =>
            onSelectionChanged(_popupCtrl, selectedContent: selectedContent),
      );
    } else if (_message.isAtTextType) {
      isBubbleBg = true;
      child = ChatText(
        text: _message.atTextElem!.text!,
        allAtMap: MitiUtils.getAtMapping(_message, widget.allAtMap),
        patterns: widget.patterns,
        textScaleFactor: widget.textScaleFactor,
        onVisibleTrulyText: widget.onVisibleTrulyText,
        isISend: _isISend,
        selectMode: true,
        onSelectionChanged: ({SelectedContent? selectedContent}) =>
            onSelectionChanged(_popupCtrl, selectedContent: selectedContent),
      );
    } else if (_message.isPictureType) {
      child = widget.mediaItemBuilder?.call(context, _message) ??
          ChatPictureView(
            isISend: _isISend,
            message: _message,
            sendProgressStream: widget.sendProgressSubject,
          );
    } else if (_message.isVoiceType) {
      isBubbleBg = true;
      final sound = _message.soundElem;
      child = ChatVoiceView(
        isISend: _isISend,
        soundPath: sound?.soundPath,
        soundUrl: sound?.sourceUrl,
        duration: sound?.duration,
        isPlaying: widget.isPlayingSound,
      );
    } else if (_message.isVideoType) {
      child = widget.mediaItemBuilder?.call(context, _message) ??
          ChatVideoView(
            isISend: _isISend,
            message: _message,
            sendProgressStream: widget.sendProgressSubject,
          );
    } else if (_message.isFileType) {
      child = ChatFileView(
        message: _message,
        isISend: _isISend,
        sendProgressStream: widget.sendProgressSubject,
        ChatFileDownloadProgressView: widget.ChatFileDownloadProgressView,
      );
    } else if (_message.isLocationType) {
      final location = _message.locationElem;
      child = ChatLocationView(
        description: location!.description!,
        latitude: location.latitude!,
        longitude: location.longitude!,
      );
    } else if (_message.isQuoteType) {
      isBubbleBg = true;
      child = ChatText(
        text: _message.quoteElem?.text ?? '',
        allAtMap: MitiUtils.getAtMapping(_message, widget.allAtMap),
        patterns: widget.patterns,
        onVisibleTrulyText: widget.onVisibleTrulyText,
        isISend: _isISend,
        selectMode: true,
        onSelectionChanged: ({SelectedContent? selectedContent}) =>
            onSelectionChanged(_popupCtrl, selectedContent: selectedContent),
      );
    } else if (_message.isMergerType) {
      child = ChatMergeMsgView(
        title: _message.mergeElem?.title ?? '',
        summaryList: _message.mergeElem?.abstractList ?? [],
      );
    } else if (_message.isCardType) {
      child = ChatCarteView(cardElem: _message.cardElem!);
    } else if (_message.isCustomFaceType) {
      final face = _message.faceElem;
      child = ChatCustomEmojiView(
        index: face?.index,
        data: face?.data,
        isISend: _isISend,
        heroTag: _message.clientMsgID,
      );
    } else if (_message.isCustomType) {
      final info = widget.customTypeBuilder?.call(context, _message);
      if (null != info) {
        isBubbleBg = info.needBubbleBackground;
        child = info.customView;
        if (!info.needChatItemContainer) {
          return child;
        }
      }
    } else if (_message.isRevokeType) {
      return child = ChatRevokeView(
        message: _message,
        onReEdit: widget.onReEit,
        canReEdit: widget.canReEdit,
      );
    } else if (_message.isNotificationType) {
      if (_message.contentType ==
          MessageType.groupInfoSetAnnouncementNotification) {
        final map = json.decode(_message.notificationElem!.detail!);
        final ntf = GroupNotification.fromJson(map);
        final noticeContent = ntf.group?.notification;
        senderNickname = ntf.opUser?.nickname;
        senderFaceURL = ntf.opUser?.faceURL;
        child = ChatNoticeView(isISend: _isISend, content: noticeContent!);
      } else {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ChatHintTextView(message: _message),
        );
      }
      // final content = _message.noticeContent;
      // final isNotice = MitiUtils.isNotNullEmptyStr(content);
      // child = widget.notificationTypeBuilder?.call(context, _message);
      // if (null == child) {
      //   if (isNotice) {
      //     child = ChatNoticeView(isISend: _isISend, content: content!);
      //   } else {
      //     return ConstrainedBox(
      //       constraints: BoxConstraints(maxWidth: maxWidth),
      //       child: ChatHintTextView(message: _message),
      //     );
      //   }
      // }
    }
    // md测试
    if (showMd) {
      child = _buildMarkdown();
    }
    senderNickname ??= widget.leftNickname ?? _message.senderNickname;
    senderFaceURL ??= widget.leftFaceUrl ?? _message.senderFaceUrl;
    return child = ChatItemContainer(
      message: _message,
      id: _message.clientMsgID!,
      isISend: _isISend,
      leftNickname: senderNickname,
      leftFaceUrl: senderFaceURL,
      rightNickname: widget.rightNickname ?? OpenIM.iMManager.userInfo.nickname,
      rightFaceUrl:
          widget.rightFaceUrl ?? OpenIM.iMManager.userInfo.faceURL ?? "",
      showLeftNickname: widget.showLeftNickname,
      showRightNickname: widget.showRightNickname,
      timelineStr: widget.timelineStr,
      timeStr: MitiUtils.getChatTimeline(_message.sendTime!, 'HH:mm:ss'),
      hasRead: _message.isRead!,
      isSending: _message.status == MessageStatus.sending,
      isSendFailed: _message.status == MessageStatus.failed,
      isMultiSelModel: widget.isMultiSelMode,
      isChecked: _isChecked,
      isBubbleBg: child == null ? true : isBubbleBg,
      menus: widget.showLongPressMenu ? _menusItem : [],
      isPrivateChat: widget.isPrivateChat,
      ignorePointer: widget.ignorePointer,
      onStartDestroy: widget.onDestroyMessage,
      readingDuration: widget.readingDuration,
      sendStatusStream: widget.sendStatusSubject,
      onRadioChanged: widget.onMultiSelChanged,
      onFailedToResend: widget.onFailedToResend,
      popupMenuController: _popupCtrl,
      onLongPressLeftAvatar: widget.onLongPressLeftAvatar,
      onLongPressRightAvatar: widget.onLongPressRightAvatar,
      onTapLeftAvatar: widget.onTapLeftAvatar,
      onTapRightAvatar: widget.onTapRightAvatar,
      quoteView: _quoteMsgView,
      translateView: _translateView,
      ttsView: _ttsView,
      readStatusView: _readStatusView,
      voiceReadStatusView: _voiceReadStatusView,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onClickItemView,
        child: child ??
            ChatText(text: StrLibrary.unsupportedMessage, isISend: _isISend),
      ),
    );
  }

  Widget? get _quoteMsgView {
    final quoteMsg = _message.quoteMessage;
    return quoteMsg != null
        ? ChatQuoteView(
            quoteMsg: quoteMsg,
            onTap: widget.onTapQuoteMessage,
            allAtMap: MitiUtils.getAtMapping(quoteMsg, widget.allAtMap),
          )
        : null;
  }

  Widget _translateView({String? text, required String status}) {
    List<MenuInfo> _translateMenusItem = [];
    if (null != text && status == "show") {
      _translateMenusItem = [
        MenuInfo(
          icon: ImageLibrary.menuCopy,
          text: StrLibrary.menuCopy,
          enabled: true,
          onTap: () => MitiUtils.copy(text: text),
        ),
        MenuInfo(
          icon: ImageLibrary.appMenuUnTranslate,
          text: StrLibrary.unTranslate,
          enabled: widget.enabledUnTranslateMenu,
          onTap: widget.onTapUnTranslateMenu,
        ),
      ];
    }
    return status == "loading"
        ? Container(
            margin: EdgeInsets.only(top: 4.h),
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            height: 42.h,
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: StylesLibrary.c_FFFFFF,
              borderRadius: borderRadius(_isISend),
            ),
            child: ImageLibrary.appTranslateLoading.toImage..height = 24.h,
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            margin: EdgeInsets.only(top: 4.h),
            // constraints: BoxConstraints(maxWidth: maxWidth),
            decoration: BoxDecoration(
              color: _isISend ? StylesLibrary.c_8443F8 : StylesLibrary.c_FFFFFF,
              borderRadius: borderRadius(_isISend),
            ),
            child: status == "fail"
                ? ChatText(
                    text: StrLibrary.translateFail,
                    textStyle: StylesLibrary.ts_FF4E4C_16sp,
                    patterns: widget.patterns,
                    textScaleFactor: widget.textScaleFactor,
                    // onVisibleTrulyText: widget.onVisibleTrulyText,
                    isISend: _isISend,
                  )
                : CopyCustomPopupMenu(
                    controller: _popupTranslateMenuCtrl,
                    menuBuilder: () => ChatLongPressMenu(
                      popupMenuController: _popupTranslateMenuCtrl,
                      menus: _translateMenusItem,
                    ),
                    pressType: PressType.longPress,
                    arrowColor: StylesLibrary.c_333333_opacity85,
                    barrierColor: Colors.transparent,
                    verticalMargin: 0,
                    child: !showMd
                        ? ChatText(
                            text: status == "show" ? text! : "",
                            patterns: widget.patterns,
                            textScaleFactor: widget.textScaleFactor,
                            isISend: _isISend,
                            selectMode: true,
                            onSelectionChanged: (
                                    {SelectedContent? selectedContent}) =>
                                onSelectionChanged(_popupTranslateMenuCtrl,
                                    selectedContent: selectedContent),
                          )
                        : _buildMarkdown(text: text!),
                  ),
          );
  }

  Widget _ttsView({String? text, required String status}) {
    List<MenuInfo> _ttsMenusItem = [];
    if (null != text && status == "show") {
      _ttsMenusItem = [
        MenuInfo(
          icon: ImageLibrary.menuCopy,
          text: StrLibrary.menuCopy,
          enabled: true,
          onTap: () => MitiUtils.copy(text: text),
        ),
        MenuInfo(
          icon: ImageLibrary.appMenuUnTts,
          text: StrLibrary.hide,
          enabled: widget.enabledUnTtsMenu,
          onTap: widget.onTapUnTtsMenu,
        ),
        // MenuInfo(
        //     icon: ImageLibrary.menuForward,
        //     text: StrLibrary .menuForward,
        //     enabled: true,
        //     onTap: widget.onTapForwardMenu,
        //   )
      ];
    }
    return status == "loading"
        ? Container(
            margin: EdgeInsets.only(top: 4.h),
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            height: 42.h,
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: StylesLibrary.c_FFFFFF,
              borderRadius: borderRadius(_isISend),
            ),
            child: ImageLibrary.appTranslateLoading.toImage..height = 24.h,
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            margin: EdgeInsets.only(top: 4.h),
            // constraints: BoxConstraints(maxWidth: maxWidth),
            decoration: BoxDecoration(
              color: _isISend ? StylesLibrary.c_8443F8 : StylesLibrary.c_FFFFFF,
              borderRadius: borderRadius(_isISend),
            ),
            child: status == "fail"
                ? ChatText(
                    text: StrLibrary.translateFail,
                    textStyle: StylesLibrary.ts_FF4E4C_16sp,
                    patterns: widget.patterns,
                    textScaleFactor: widget.textScaleFactor,
                    // onVisibleTrulyText: widget.onVisibleTrulyText,
                    isISend: _isISend,
                  )
                : CopyCustomPopupMenu(
                    controller: _popupTranslateMenuCtrl,
                    menuBuilder: () => ChatLongPressMenu(
                      popupMenuController: _popupTranslateMenuCtrl,
                      menus: _ttsMenusItem,
                    ),
                    pressType: PressType.longPress,
                    arrowColor: StylesLibrary.c_333333_opacity85,
                    barrierColor: Colors.transparent,
                    verticalMargin: 0,
                    child: ChatText(
                      text: status == "show" ? text! : "",
                      patterns: widget.patterns,
                      textScaleFactor: widget.textScaleFactor,
                      isISend: _isISend,
                      selectMode: true,
                      onSelectionChanged: (
                              {SelectedContent? selectedContent}) =>
                          onSelectionChanged(_popupTranslateMenuCtrl,
                              selectedContent: selectedContent),
                    ),
                  ),
          );
  }

  Widget? get _readStatusView => widget.enabledReadStatus &&
          _isISend &&
          _message.status == MessageStatus.succeeded
      ? ChatReadTagView(
          message: _message,
          onTap: widget.onViewMessageReadStatus,
          showRead: widget.showRead)
      : null;

  Widget? get _voiceReadStatusView => _message.isVoiceType && !_message.isRead!
      ? const ChatVoiceReadStatusView()
      : null;

  List<MenuInfo> get _menusItem => [
        if (widget.enabledCopyMenu)
          MenuInfo(
            icon: ImageLibrary.menuCopy,
            text: StrLibrary.menuCopy,
            enabled: widget.enabledCopyMenu,
            onTap: widget.onTapCopyMenu,
          ),
        if (widget.enabledDelMenu)
          MenuInfo(
            icon: ImageLibrary.menuDel,
            text: StrLibrary.menuDel,
            enabled: widget.enabledDelMenu,
            onTap: widget.onTapDelMenu,
          ),
        if (widget.enabledTranslateMenu)
          MenuInfo(
            icon: ImageLibrary.appMenuTranslate,
            text: StrLibrary.translate,
            enabled: widget.enabledTranslateMenu,
            onTap: widget.onTapTranslateMenu,
          ),
        if (widget.enabledUnTranslateMenu)
          MenuInfo(
            icon: ImageLibrary.appMenuUnTranslate,
            text: StrLibrary.unTranslate,
            enabled: widget.enabledUnTranslateMenu,
            onTap: widget.onTapUnTranslateMenu,
          ),
        if (widget.enabledTtsMenu)
          MenuInfo(
            icon: ImageLibrary.appMenuTts,
            text: StrLibrary.tts,
            enabled: widget.enabledTtsMenu,
            onTap: widget.onTapTtsMenu,
          ),
        if (widget.enabledUnTtsMenu)
          MenuInfo(
            icon: ImageLibrary.appMenuUnTts,
            text: StrLibrary.hide,
            enabled: widget.enabledUnTtsMenu,
            onTap: widget.onTapUnTtsMenu,
          ),
        if (widget.enabledForwardMenu)
          MenuInfo(
            icon: ImageLibrary.menuForward,
            text: StrLibrary.menuForward,
            enabled: widget.enabledForwardMenu,
            onTap: widget.onTapForwardMenu,
          ),
        if (widget.enabledReplyMenu)
          MenuInfo(
            icon: ImageLibrary.menuReply,
            text: StrLibrary.menuReply,
            enabled: widget.enabledReplyMenu,
            onTap: widget.onTapReplyMenu,
          ),
        if (widget.enabledMultiMenu)
          MenuInfo(
            icon: ImageLibrary.menuMulti,
            text: StrLibrary.menuMulti,
            enabled: widget.enabledMultiMenu,
            onTap: widget.onTapMultiMenu,
          ),
        if (widget.enabledRevokeMenu)
          MenuInfo(
            icon: ImageLibrary.menuRevoke,
            text: StrLibrary.menuRevoke,
            enabled: widget.enabledRevokeMenu,
            onTap: widget.onTapRevokeMenu,
          ),
        if (widget.enabledAddEmojiMenu)
          MenuInfo(
            icon: ImageLibrary.menuAddFace,
            text: StrLibrary.menuAdd,
            enabled: widget.enabledAddEmojiMenu,
            onTap: widget.onTapAddEmojiMenu,
          ),
      ];
}
