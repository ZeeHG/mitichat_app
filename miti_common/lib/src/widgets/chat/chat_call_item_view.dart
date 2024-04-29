import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class ChatCallItemView extends StatelessWidget {
  const ChatCallItemView({
    Key? key,
    this.isISend = false,
    required this.type,
    required this.content,
  }) : super(key: key);
  final bool isISend;
  final String content;
  final String type;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          (type == 'audio'
                  ? ImageLibrary.voiceCallMsg
                  : ImageLibrary.videoCallMsg)
              .toImage
            ..width = 18.w
            ..height = 18.h
            ..color =
                (isISend ? StylesLibrary.c_FFFFFF : StylesLibrary.c_333333),
          8.horizontalSpace,
          Text(
            content,
            style: isISend
                ? StylesLibrary.ts_FFFFFF_17sp
                : StylesLibrary.ts_333333_17sp,
          ),
        ],
      );
}
