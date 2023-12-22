import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'tag_notification_detail_logic.dart';

class TagNotificationDetailPage extends StatelessWidget {
  final logic = Get.find<TagNotificationDetailLogic>();

  TagNotificationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.detail),
      backgroundColor: Styles.c_F8F9FA,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Styles.c_FFFFFF,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Column(
                      children: [
                        if (null != logic.textElem) logic.textElem!.content!.toText..style = Styles.ts_0C1C33_17sp,
                        if (null != logic.soundElem)
                          Obx(() => GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => logic.playVoiceMessage(),
                                child: SizedBox(
                                  width: 88.w,
                                  height: 44.h,
                                  child: ChatBubble(
                                    bubbleType: BubbleType.receiver,
                                    backgroundColor: Styles.c_CCE7FE,
                                    child: ChatVoiceView(
                                      isISend: false,
                                      soundPath: logic.soundElem!.soundPath,
                                      soundUrl: logic.soundElem!.sourceUrl,
                                      duration: logic.soundElem!.duration,
                                      isPlaying: logic.isPlaySound(),
                                    ),
                                  ),
                                ),
                              )),
                        if (null == logic.textElem && null == logic.soundElem) StrRes.unsupportedMessage.toText..style = Styles.ts_0C1C33_17sp,
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Styles.c_FFFFFF,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StrRes.receiveMember.toText..style = Styles.ts_8E9AB0_14sp,
                        12.verticalSpace,
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 9.h,
                          children: logic.list
                              .map((e) => GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () => logic.viewMember(e),
                                    child: _buildMemberItemView(e),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            color: Styles.c_FFFFFF,
            child: Button(
              margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              text: StrRes.sendAnother,
              onTap: logic.againSend,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMemberItemView(dynamic info) {
    String? name;
    String? faceURL;
    bool isGroup = false;
    if (info is ConversationInfo) {
      name = info.showName;
      faceURL = info.faceURL;
      isGroup = !info.isSingleChat;
    } else if (info is GroupInfo) {
      name = info.groupName;
      faceURL = info.faceURL;
      isGroup = true;
    } else if (info is UserInfo) {
      name = info.nickname;
      faceURL = info.faceURL;
    } else if (info is TagInfo) {
      name = info.tagName;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Styles.c_E8EAEF, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (info is TagInfo)
            ImageRes.tagIcon.toImage
              ..width = 16.w
              ..height = 16.h
          else
            AvatarView(
              text: name,
              url: faceURL,
              height: 16.h,
              width: 16.w,
              isGroup: isGroup,
              textStyle: Styles.ts_FFFFFF_10sp,
            ),
          7.horizontalSpace,
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 150.w),
            child: (name ?? '').toText
              ..style = Styles.ts_0C1C33_14sp
              ..maxLines = 1
              ..overflow = TextOverflow.ellipsis,
          ),
          // 8.horizontalSpace,
          // Container(
          //   width: 16.w,
          //   height: 16.h,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(3.r),
          //     color: Styles.c_E8EAEF,
          //   ),
          //   child: Icon(
          //     Icons.clear,
          //     size: 10.w,
          //     color: Styles.c_8E9AB0,
          //   ),
          // ),
        ],
      ),
    );
  }
}
