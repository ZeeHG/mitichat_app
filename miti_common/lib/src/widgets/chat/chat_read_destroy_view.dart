import 'package:flutter/material.dart';
import 'package:miti_common/miti_common.dart';

class ChatDestroyAfterReadingView extends StatelessWidget {
  const ChatDestroyAfterReadingView({
    Key? key,
    required this.hasRead,
    required this.isPrivateChat,
    required this.readingDuration,
    this.onStartDestroy,
  }) : super(key: key);
  final bool hasRead;
  final bool isPrivateChat;
  final int readingDuration;
  final Function()? onStartDestroy;

  @override
  Widget build(BuildContext context) => Visibility(
        visible: hasRead && isPrivateChat /*&& readingDuration > 0*/,
        child: TimingView(
          sec: readingDuration,
          onFinished: onStartDestroy,
        ),
      );
}
