import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:miti_common/miti_common.dart';

class ChatPreviewTextMsgView extends StatelessWidget {
  const ChatPreviewTextMsgView({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    String content = "";
    if (message.isTextType) {
      content = message.textElem!.content!;
    } else if (message.isAtTextType) {
      content = MitiUtils.replaceMessageAtMapping(message, {});
    } else if (message.isQuoteType) {
      content = message.quoteElem?.text ?? "";
    }
    return Scaffold(
        backgroundColor: StylesLibrary.c_F8F9FA,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: SelectionArea(
              child: content.toText
                ..style = StylesLibrary.ts_333333_16sp
              ,
            ),
          ),
        ));
  }
}
