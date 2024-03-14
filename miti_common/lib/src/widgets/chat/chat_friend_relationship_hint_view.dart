import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

/// 好友关系异常提示
class ChatFriendRelationshipAbnormalHintView extends StatelessWidget {
  const ChatFriendRelationshipAbnormalHintView({
    Key? key,
    this.blockedByFriend = false,
    this.deletedByFriend = false,
    required this.name,
    this.onTap,
  }) : super(key: key);
  final bool blockedByFriend;
  final bool deletedByFriend;
  final String name;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    if (blockedByFriend) {
      return StrLibrary.blockedByFriendHint.toText
        ..style = Styles.ts_999999_12sp;
    } else if (deletedByFriend) {
      return Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: RichText(
          text: TextSpan(
            text: sprintf(StrLibrary.deletedByFriendHint, [name]),
            style: Styles.ts_999999_12sp,
            children: [
              TextSpan(
                text: StrLibrary.sendFriendVerification,
                style: Styles.ts_8443F8_12sp,
                recognizer: TapGestureRecognizer()..onTap = onTap,
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }
}
