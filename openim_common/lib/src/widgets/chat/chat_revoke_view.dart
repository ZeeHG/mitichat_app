import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

class ChatRevokeView extends StatelessWidget {
  const ChatRevokeView({
    Key? key,
    required this.message,
    this.onReEdit,
    this.canReEdit = false,
  }) : super(key: key);
  final Message message;
  final Function()? onReEdit;
  final bool canReEdit;

  bool get _isISend => message.sendID == OpenIM.iMManager.userID;

  String get _who => _isISend ? StrLibrary.you : message.senderNickname ?? '';

  @override
  Widget build(BuildContext context) {
    final bridge = PackageBridge.viewUserProfileBridge;
    final groupID = message.groupID;
    String? revoker, sender;
    final value = <String, String>{};
    // 群聊撤回包含：撤回自己消息，群组或管理员撤回其他人消息
    var map = json.decode(message.notificationElem!.detail!);
    var info = RevokedInfo.fromJson(map);
    if (info.revokerID == info.sourceMessageSendID) {
      revoker = _who;
    } else {
      if (info.revokerID == OpenIM.iMManager.userID) {
        // revoker = StrLibrary .you;
        revoker = info.revokerID!;
        value[revoker] = StrLibrary.you;
      } else {
        // revoker = info.revokerNickname!;
        revoker = info.revokerID!;
        value[revoker] = info.revokerNickname!;
      }
      if (info.sourceMessageSendID == OpenIM.iMManager.userID) {
        // sender = StrLibrary .you;
        sender = info.sourceMessageSendID!;
        value[sender] = StrLibrary.you;
      } else {
        // sender = info.sourceMessageSenderNickname!;
        sender = info.sourceMessageSendID!;
        value[sender] = info.sourceMessageSenderNickname!;
      }
    }

    final List<InlineSpan> children = <InlineSpan>[];
    if (sender != null) {
      final text = sprintf(StrLibrary.aRevokeBMsg, [revoker, sender]);
      text.splitMapJoin(
        RegExp('($revoker|$sender)'),
        onMatch: (match) {
          final matchText = match[0]!;
          final nickname = value[matchText];
          children.add(TextSpan(
            text: nickname,
            style: Styles.ts_8443F8_12sp,
            recognizer: TapGestureRecognizer()
              ..onTap = () => bridge?.viewUserProfile(
                    matchText,
                    nickname,
                    null,
                    groupID,
                  ),
          ));
          return '';
        },
        onNonMatch: (text) {
          children.add(TextSpan(text: text, style: Styles.ts_999999_12sp));
          return '';
        },
      );
    } else {
      final isIRevoke = revoker == StrLibrary.you;
      children
        ..add(TextSpan(
          text: '$revoker ',
          style: Styles.ts_8443F8_12sp,
          recognizer: TapGestureRecognizer()
            ..onTap = () => bridge?.viewUserProfile(
                  info.sourceMessageSendID!,
                  info.revokerNickname,
                  null,
                  groupID,
                ),
        ))
        ..add(TextSpan(
          text: StrLibrary.revokeMsg,
          style: Styles.ts_999999_12sp,
        ));
      if (isIRevoke && _isISend && canReEdit) {
        children.add(TextSpan(
          text: ' ${StrLibrary.reEdit}',
          style: Styles.ts_8443F8_12sp,
          recognizer: TapGestureRecognizer()..onTap = onReEdit,
        ));
      }
    }
    return RichText(
      text: TextSpan(children: children),
      textAlign: TextAlign.center,
    );
  }
}
