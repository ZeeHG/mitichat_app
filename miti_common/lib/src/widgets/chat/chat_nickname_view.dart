import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class ChatNicknameView extends StatelessWidget {
  const ChatNicknameView({
    Key? key,
    this.nickname,
    this.timeStr,
  }) : super(key: key);
  final String? nickname;
  final String? timeStr;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '',
        style: StylesLibrary.ts_999999_12sp,
        children: [
          if (null != nickname)
            WidgetSpan(
              child: Container(
                constraints: BoxConstraints(maxWidth: 100.w),
                margin: EdgeInsets.only(right: 6.w),
                child: nickname!.toText
                  ..style = StylesLibrary.ts_999999_12sp
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis,
              ),
            ),
          if (null != nickname) WidgetSpan(child: 6.horizontalSpace),
          // TextSpan(text: timeStr),
        ],
      ),
    );
  }
}
