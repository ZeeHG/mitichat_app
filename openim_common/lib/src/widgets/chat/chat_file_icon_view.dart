import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatFileIconView extends StatelessWidget {
  const ChatFileIconView({
    Key? key,
    required this.message,
    this.sendProgressStream,
    this.downloadProgressView,
  }) : super(key: key);
  final Message message;
  final Stream<MsgStreamEv<int>>? sendProgressStream;
  final Widget? downloadProgressView;

  @override
  Widget build(BuildContext context) {
    final id = message.clientMsgID!;
    final fileName = message.fileElem!.fileName!;
    final isISend = message.sendID == OpenIM.iMManager.userID;
    return Stack(
      children: [
        IMUtils.fileIcon(fileName).toImage
          ..width = 38.w
          ..height = 44.h,
        ChatProgressView(
          isISend: isISend,
          width: 38.w,
          height: 44.h,
          id: id,
          stream: sendProgressStream,
          type: ProgressType.file,
        ),
        if (null != downloadProgressView) downloadProgressView!,
      ],
    );
  }
}
