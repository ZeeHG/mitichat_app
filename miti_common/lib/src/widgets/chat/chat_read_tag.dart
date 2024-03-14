import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

class ChatReadTagView extends StatelessWidget {
  const ChatReadTagView({
    Key? key,
    required this.message,
    this.onTap,
    this.showRead,
  }) : super(key: key);
  final Message message;
  final Function()? onTap;
  final bool? showRead;

  int get _needReadMemberCount {
    final hasReadCount =
        message.attachedInfoElem?.groupHasReadInfo?.hasReadCount ?? 0;
    final unreadCount =
        message.attachedInfoElem?.groupHasReadInfo?.unreadCount ?? 0;
    return hasReadCount + unreadCount;
  }

  int get _unreadCount =>
      message.attachedInfoElem?.groupHasReadInfo?.unreadCount ?? 0;

  bool get isRead => message.isRead!;

  @override
  Widget build(BuildContext context) {
    if (message.isSingleChat) {
      return ((showRead ?? isRead) ? StrLibrary.hasRead : StrLibrary.unread)
          .toText
        ..style = ((showRead ?? isRead)
            ? Styles.ts_999999_12sp
            : Styles.ts_8443F8_12sp);
    } else {
      if (_needReadMemberCount == 0) return const SizedBox();
      bool isAllRead = _unreadCount <= 0;
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: (isAllRead
                ? StrLibrary.allRead
                : sprintf(StrLibrary.nPersonUnRead, [_unreadCount]))
            .toText
          ..style = (isAllRead ? Styles.ts_999999_12sp : Styles.ts_8443F8_12sp),
      );
    }
  }
}
