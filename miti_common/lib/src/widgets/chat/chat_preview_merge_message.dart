import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class ChatPreviewMergeMsgView extends StatelessWidget {
  const ChatPreviewMergeMsgView(
      {Key? key, required this.messageList, required this.title})
      : super(key: key);
  final List<Message> messageList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: title),
      backgroundColor: Styles.c_F8F9FA,
      body: ListView.builder(
        itemCount: messageList.length,
        shrinkWrap: true,
        itemBuilder: (_, index) => _buildItemView(index),
      ),
    );
  }

  Widget _buildItemView(int index) {
    var message = messageList.elementAt(index);
    final content = MitiUtils.parseMsg(message, replaceIdToNickname: true);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => MitiUtils.parseClickEvent(
        message,
        messageList: [message],
        onViewUserInfo: (userInfo) {
          final arguments = {
            'userID': userInfo.userID,
            'nickname': userInfo.nickname,
            'faceURL': userInfo.faceURL,
          };
          Get.toNamed(
            '/user_profile',
            arguments: arguments,
            preventDuplicates: false,
          );
        },
      ),
      child: Container(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarView(
              url: message.senderFaceUrl,
              text: message.senderNickname,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10.w),
                padding: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(color: Styles.c_E8EAEF, width: 1.h),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: (message.senderNickname ?? '').toText
                            ..style = Styles.ts_999999_12sp,
                        ),
                        MitiUtils.getChatTimeline(message.sendTime!).toText
                          ..style = Styles.ts_999999_12sp,
                      ],
                    ),
                    10.verticalSpace,
                    MatchTextView(
                        text: content, textStyle: Styles.ts_333333_17sp)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
