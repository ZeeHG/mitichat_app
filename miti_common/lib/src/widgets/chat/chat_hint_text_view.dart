import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

class ChatHintTextView extends StatelessWidget {
  const ChatHintTextView({
    Key? key,
    required this.message,
  }) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    final bridge = PackageBridge.viewUserProfileBridge;
    final groupID = message.groupID;
    final elem = message.notificationElem!;
    final map = json.decode(elem.detail!);
    switch (message.contentType) {
      case MessageType.groupCreatedNotification:
        {
          final ntf = GroupNotification.fromJson(map);
          // a 创建了群聊
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_8443F8_12sp,
              recognizer: TapGestureRecognizer()
                ..onTap = () => bridge?.viewUserProfile(
                      ntf.opUser!.userID!,
                      ntf.opUser!.nickname,
                      ntf.opUser!.faceURL,
                      groupID,
                    ),
              children: [
                TextSpan(
                  text: sprintf(StrLibrary.createGroupNtf, ['']),
                  style: Styles.ts_999999_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.groupInfoSetNotification:
        {
          final ntf = GroupNotification.fromJson(map);
          // a 修改了群资料
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_8443F8_12sp,
              recognizer: TapGestureRecognizer()
                ..onTap = () => bridge?.viewUserProfile(
                      ntf.opUser!.userID!,
                      ntf.opUser!.nickname,
                      ntf.opUser!.faceURL,
                      groupID,
                    ),
              children: [
                TextSpan(
                  text: sprintf(StrLibrary.editGroupInfoNtf, ['']),
                  style: Styles.ts_999999_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.memberQuitNotification:
        {
          final ntf = QuitGroupNotification.fromJson(map);
          // a 退出了群聊
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.quitUser!),
              style: Styles.ts_8443F8_12sp,
              recognizer: TapGestureRecognizer()
                ..onTap = () => bridge?.viewUserProfile(
                      ntf.quitUser!.userID!,
                      ntf.quitUser!.nickname,
                      ntf.quitUser!.faceURL,
                      groupID,
                    ),
              children: [
                TextSpan(
                  text: sprintf(StrLibrary.quitGroupNtf, ['']),
                  style: Styles.ts_999999_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.memberInvitedNotification:
        {
          final aMap = <String, String>{};
          final bMap = <String, String>{};
          final infoMap = <String, GroupMembersInfo>{};
          final ntf = InvitedJoinGroupNotification.fromJson(map);
          // final a = IMUtils.getGroupMemberShowName(ntf.opUser!);
          // final b = ntf.invitedUserList
          //     ?.map((e) => IMUtils.getGroupMemberShowName(e))
          //     .toList()
          //     .join('、');

          aMap[ntf.opUser!.userID!] =
              IMUtils.getGroupMemberShowName(ntf.opUser!);
          infoMap[ntf.opUser!.userID!] = ntf.opUser!;

          for (var user in ntf.invitedUserList!) {
            bMap[user.userID!] = IMUtils.getGroupMemberShowName(user);
            infoMap[user.userID!] = user;
          }

          final a = ntf.opUser!.userID!;
          final b = bMap.keys.join('、');
          String pattern = '(${[a, ...bMap.keys].join('|')})';

          final text = sprintf(StrLibrary.invitedJoinGroupNtf, [a, b]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp(pattern),
            // RegExp('($a|$b)'),
            onMatch: (match) {
              final text = match[0]!;
              final value = aMap[text] ?? bMap[text] ?? '';
              final info = infoMap[text];
              children.add(TextSpan(
                text: value,
                style: Styles.ts_8443F8_12sp,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => bridge?.viewUserProfile(
                        info!.userID!,
                        info.nickname,
                        info.faceURL,
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
          // a 邀请 b 加入群聊
          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.memberKickedNotification:
        {
          final aMap = <String, String>{};
          final bMap = <String, String>{};
          final infoMap = <String, GroupMembersInfo>{};
          final ntf = KickedGroupMemeberNotification.fromJson(map);
          // final a = IMUtils.getGroupMemberShowName(ntf.opUser!);
          // final a = ntf.opUser!.userID;
          // final b = ntf.kickedUserList
          //     ?.map((e) => IMUtils.getGroupMemberShowName(e))
          //     .toList()
          //     .join('、');

          aMap[ntf.opUser!.userID!] =
              IMUtils.getGroupMemberShowName(ntf.opUser!);
          infoMap[ntf.opUser!.userID!] = ntf.opUser!;

          for (var user in ntf.kickedUserList!) {
            bMap[user.userID!] = IMUtils.getGroupMemberShowName(user);
            infoMap[user.userID!] = user;
          }

          final a = ntf.opUser!.userID!;
          final b = bMap.keys.join('、');
          String pattern = '(${[a, ...bMap.keys].join('|')})';

          final text = sprintf(StrLibrary.kickedGroupNtf, [b, a]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp(pattern),
            // RegExp('($a|$b)'),
            onMatch: (match) {
              final text = match[0]!;
              final value = aMap[text] ?? bMap[text] ?? '';
              final info = infoMap[text];
              children.add(TextSpan(
                text: value,
                style: Styles.ts_8443F8_12sp,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => bridge?.viewUserProfile(
                        info!.userID!,
                        info.nickname,
                        info.faceURL,
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
          // b 被 a 移出群聊
          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.memberEnterNotification:
        {
          final ntf = EnterGroupNotification.fromJson(map);
          // a 加入了群聊
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.entrantUser!),
              style: Styles.ts_8443F8_12sp,
              recognizer: TapGestureRecognizer()
                ..onTap = () => bridge?.viewUserProfile(
                      ntf.entrantUser!.userID!,
                      ntf.entrantUser!.nickname,
                      ntf.entrantUser!.faceURL,
                      groupID,
                    ),
              children: [
                TextSpan(
                  text: sprintf(StrLibrary.joinGroupNtf, ['']),
                  style: Styles.ts_999999_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.dismissGroupNotification:
        {
          final ntf = GroupNotification.fromJson(map);
          // a 解散了群聊
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_8443F8_12sp,
              recognizer: TapGestureRecognizer()
                ..onTap = () => bridge?.viewUserProfile(
                      ntf.opUser!.userID!,
                      ntf.opUser!.nickname,
                      ntf.opUser!.faceURL,
                      groupID,
                    ),
              children: [
                TextSpan(
                  text: sprintf(StrLibrary.dismissGroupNtf, ['']),
                  style: Styles.ts_999999_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.groupOwnerTransferredNotification:
        {
          final ntf = GroupRightsTransferNoticication.fromJson(map);
          // final a = IMUtils.getGroupMemberShowName(ntf.opUser!);
          // final b = IMUtils.getGroupMemberShowName(ntf.newGroupOwner!);
          final a = ntf.opUser!.userID;
          final b = ntf.newGroupOwner!.userID;
          final text = sprintf(StrLibrary.transferredGroupNtf, [a, b]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp('($a|$b)'),
            onMatch: (match) {
              final text = match[0]!;
              final info =
                  text == ntf.opUser!.userID ? ntf.opUser! : ntf.newGroupOwner!;
              children.add(TextSpan(
                text: IMUtils.getGroupMemberShowName(info),
                style: Styles.ts_8443F8_12sp,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => bridge?.viewUserProfile(
                        info.userID!,
                        info.nickname,
                        info.faceURL,
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
          // a 将群转让给了 b
          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.groupMemberMutedNotification:
        {
          final ntf = MuteMemberNotification.fromJson(map);
          final a = ntf.opUser!.userID;
          final b = ntf.mutedUser!.userID;
          final c = IMUtils.mutedTime(ntf.mutedSeconds!);
          final text = sprintf(StrLibrary.muteMemberNtf, [b, a, c]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp('($a|$b)'),
            onMatch: (match) {
              final text = match[0]!;
              final info =
                  text == ntf.opUser!.userID ? ntf.opUser! : ntf.mutedUser!;
              children.add(TextSpan(
                text: IMUtils.getGroupMemberShowName(info),
                style: Styles.ts_8443F8_12sp,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => bridge?.viewUserProfile(
                        info.userID!,
                        info.nickname,
                        info.faceURL,
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
          // b 被 a 禁言c小时
          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.groupMemberCancelMutedNotification:
        {
          final ntf = MuteMemberNotification.fromJson(map);
          final a = ntf.opUser!.userID;
          final b = ntf.mutedUser!.userID;
          final text = sprintf(StrLibrary.muteCancelMemberNtf, [b, a]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp('($a|$b)'),
            onMatch: (match) {
              final text = match[0]!;
              final info =
                  text == ntf.opUser!.userID ? ntf.opUser! : ntf.mutedUser!;
              children.add(TextSpan(
                text: IMUtils.getGroupMemberShowName(info),
                style: Styles.ts_8443F8_12sp,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => bridge?.viewUserProfile(
                        info.userID!,
                        info.nickname,
                        info.faceURL,
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
          //  b 被 a 取消了禁言
          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.groupMutedNotification:
        {
          final ntf = MuteMemberNotification.fromJson(map);
          // a 开起了群禁言
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_8443F8_12sp,
              recognizer: TapGestureRecognizer()
                ..onTap = () => bridge?.viewUserProfile(
                      ntf.opUser!.userID!,
                      ntf.opUser!.nickname,
                      ntf.opUser!.faceURL,
                      groupID,
                    ),
              children: [
                TextSpan(
                  text: sprintf(StrLibrary.muteGroupNtf, ['']),
                  style: Styles.ts_999999_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.groupCancelMutedNotification:
        {
          final ntf = MuteMemberNotification.fromJson(map);
          // a 关闭了群禁言
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_8443F8_12sp,
              recognizer: TapGestureRecognizer()
                ..onTap = () => bridge?.viewUserProfile(
                      ntf.opUser!.userID!,
                      ntf.opUser!.nickname,
                      ntf.opUser!.faceURL,
                      groupID,
                    ),
              children: [
                TextSpan(
                  text: sprintf(StrLibrary.muteCancelGroupNtf, ['']),
                  style: Styles.ts_999999_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.friendApplicationApprovedNotification:
        {
          // 你们已成为好友
          return StrLibrary.friendAddedNtf.toText
            ..style = Styles.ts_999999_12sp;
        }
      case MessageType.burnAfterReadingNotification:
        {
          final ntf = BurnAfterReadingNotification.fromJson(map);
          // 开启私聊/关闭私聊
          return (ntf.isPrivate == true
                  ? StrLibrary.openPrivateChatNtf
                  : StrLibrary.closePrivateChatNtf)
              .toText
            ..style = Styles.ts_999999_12sp;
        }
      case MessageType.groupMemberInfoChangedNotification:
        final ntf = GroupMemberInfoChangedNotification.fromJson(map);
        // a编辑了自己的群成员资料
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: IMUtils.getGroupMemberShowName(ntf.opUser!),
            style: Styles.ts_8443F8_12sp,
            recognizer: TapGestureRecognizer()
              ..onTap = () => bridge?.viewUserProfile(
                    ntf.opUser!.userID!,
                    ntf.opUser!.nickname,
                    ntf.opUser!.faceURL,
                    groupID,
                  ),
            children: [
              TextSpan(
                text: sprintf(StrLibrary.memberInfoChangedNtf, ['']),
                style: Styles.ts_999999_12sp,
              ),
            ],
          ),
        );
      case MessageType.groupInfoSetNameNotification:
        final ntf = GroupNotification.fromJson(map);
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: IMUtils.getGroupMemberShowName(ntf.opUser!),
            style: Styles.ts_8443F8_12sp,
            recognizer: TapGestureRecognizer()
              ..onTap = () => bridge?.viewUserProfile(
                    ntf.opUser!.userID!,
                    ntf.opUser!.nickname,
                    ntf.opUser!.faceURL,
                    groupID,
                  ),
            children: [
              TextSpan(
                text: sprintf(StrLibrary.whoModifyGroupName, ['']),
                style: Styles.ts_999999_12sp,
              ),
            ],
          ),
        );
    }
    return const SizedBox();
  }
}
