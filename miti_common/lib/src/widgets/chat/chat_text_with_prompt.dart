import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';
import 'package:rxdart/rxdart.dart';

class ChatTextWithPrompt extends StatefulWidget {
  ChatTextWithPrompt({
    super.key,
    required this.welcome,
    this.isISend = false,
    this.onSendTextMsg,
    List<String>? questions,
    this.enabledTranslateMenu = false,
    this.enabledUnTranslateMenu = false,
    this.enabledRevokeMenu = false,
    this.onTapMultiMenu,
    this.onTapCopyMenu,
    this.onTapDelMenu,
    this.onTapForwardMenu,
    this.onTapReplyMenu,
    this.onTapRevokeMenu,
    this.onTapTranslateMenu,
    this.onTapUnTranslateMenu,
    this.textScaleFactor = 1.0,
    this.patterns = const [],
    this.onPopMenuShowChanged,
    this.closePopMenuSubject,
    this.disabledChatInput = false,
  }) : questions = questions ?? [];

  @override
  State<ChatTextWithPrompt> createState() => _ChatTextWithPrompt();

  String welcome;
  List<String> questions;
  final bool isISend;
  final Function({String? content})? onSendTextMsg;

  final bool enabledRevokeMenu;
  final bool enabledTranslateMenu;
  final bool enabledUnTranslateMenu;

  final bool disabledChatInput;

  final Function()? onTapCopyMenu;
  final Function()? onTapDelMenu;
  final Function()? onTapTranslateMenu;
  final Function()? onTapUnTranslateMenu;
  final Function()? onTapForwardMenu;
  final Function()? onTapReplyMenu;
  final Function()? onTapRevokeMenu;
  final Function()? onTapMultiMenu;

  final Function(bool show)? onPopMenuShowChanged;

  final Subject<bool>? closePopMenuSubject;

  final double textScaleFactor;
  final List<MatchPattern> patterns;

  List<MenuInfo> get menus => [
        MenuInfo(
          icon: ImageLibrary.menuCopy,
          text: StrLibrary.menuCopy,
          onTap: onTapCopyMenu,
        ),
        MenuInfo(
          icon: ImageLibrary.menuDel,
          text: StrLibrary.menuDel,
          onTap: onTapDelMenu,
        ),
        if (enabledTranslateMenu)
          MenuInfo(
            icon: ImageLibrary.appMenuTranslate,
            text: StrLibrary.translate,
            onTap: onTapTranslateMenu,
          ),
        if (enabledUnTranslateMenu)
          MenuInfo(
            icon: ImageLibrary.appMenuUnTranslate,
            text: StrLibrary.unTranslate,
            onTap: onTapUnTranslateMenu,
          ),
        MenuInfo(
          icon: ImageLibrary.menuForward,
          text: StrLibrary.menuForward,
          onTap: onTapForwardMenu,
        ),
        // MenuInfo(
        //   icon: ImageLibrary.menuReply,
        //   text: StrLibrary.menuReply,
        //   onTap: onTapReplyMenu,
        // ),
        MenuInfo(
          icon: ImageLibrary.menuMulti,
          text: StrLibrary.menuMulti,
          onTap: onTapMultiMenu,
        ),
        if (enabledRevokeMenu)
          MenuInfo(
            icon: ImageLibrary.menuRevoke,
            text: StrLibrary.menuRevoke,
            onTap: onTapRevokeMenu,
          ),
      ];
}

class _ChatTextWithPrompt extends State<ChatTextWithPrompt> {
  final _popupCtrl = CustomPopupMenuController();
  late StreamSubscription<bool> _keyboardSubs;
  late StreamSubscription<bool>? _closeMenuSubs;

  @override
  void dispose() {
    _popupCtrl.dispose();
    _keyboardSubs.cancel();
    _closeMenuSubs?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    final keyboardVisibilityCtrl = KeyboardVisibilityController();
    _keyboardSubs = keyboardVisibilityCtrl.onChange.listen((bool visible) {
      _popupCtrl.hideMenu();
    });

    _popupCtrl.addListener(() {
      widget.onPopMenuShowChanged?.call(_popupCtrl.menuIsShowing);
    });

    _closeMenuSubs = widget.closePopMenuSubject?.listen((value) {
      if (value == true) {
        _popupCtrl.hideMenu();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CopyCustomPopupMenu(
                controller: _popupCtrl,
                menuBuilder: () => ChatLongPressMenu(
                      popupMenuController: _popupCtrl,
                      menus: widget.menus,
                    ),
                pressType: PressType.longPress,
                arrowColor: StylesLibrary.c_333333_opacity85,
                barrierColor: Colors.transparent,
                verticalMargin: 0,
                child: ChatBubble(
                    bubbleType:
                        widget.isISend ? BubbleType.send : BubbleType.receiver,
                    child: ChatText(
                      text: widget.welcome,
                      isISend: widget.isISend,
                      patterns: widget.patterns,
                      textScaleFactor: widget.textScaleFactor,
                    ))),
            ...List.generate(
              widget.questions.length,
              (index) => IgnorePointer(
                  ignoring: widget.disabledChatInput,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => widget.onSendTextMsg
                        ?.call(content: widget.questions[index]),
                    child: Container(
                      width: maxWidthContainer,
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      margin: EdgeInsets.only(top: 4.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey[300]!.withOpacity(0.2),
                            Colors.grey[500]!.withOpacity(0.25),
                          ],
                        ),
                        borderRadius: index != widget.questions.length - 1
                            ? BorderRadius.all(Radius.circular(6.r))
                            : BorderRadius.vertical(
                                top: Radius.circular(6.r),
                                bottom: Radius.circular(12.r)),
                      ),
                      child: ChatText(
                        text: widget.questions[index],
                        textAlign: TextAlign.center,
                        textStyle: StylesLibrary.ts_333333_16sp,
                        isISend: widget.isISend,
                      ),
                    ),
                  )),
            )
          ],
        ),
      );
}
