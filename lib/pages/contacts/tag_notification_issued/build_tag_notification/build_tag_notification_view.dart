import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'build_tag_notification_logic.dart';

class BuildTagNotificationPage extends StatelessWidget {
  final logic = Get.find<BuildTagNotificationLogic>();

  BuildTagNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatVoiceRecordLayout(
      onCompleted: logic.sendSoundNotification,
      builder: (bar) => TouchCloseSoftKeyboard(
        child: Scaffold(
          appBar: TitleBar.back(
            title: StrRes.issueNotice,
          ),
          backgroundColor: Styles.c_F8F9FA,
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 16.h),
                decoration: BoxDecoration(
                  color: Styles.c_FFFFFF,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StrRes.receiveMember.toText..style = Styles.ts_8E9AB0_14sp,
                        if (logic.list.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 12.h, bottom: 26.h),
                            child: Wrap(
                              spacing: 10.w,
                              runSpacing: 9.h,
                              children: logic.list.map((e) => _buildMemberItemView(e)).toList(),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ImageRes.addTagMember.toImage
                              ..width = 76.w
                              ..height = 31.h
                              ..onTap = logic.selectIssuedMember,
                          ],
                        ),
                      ],
                    )),
              ),
              const Spacer(),
              Obx(() => RichTextInputBox(
                    controller: logic.textEditingCtrl,
                    focusNode: logic.focusNode,
                    enabled: logic.enabled.value,
                    voiceRecordBar: bar,
                    onTapCamera: logic.onTapCamera,
                    onTapAlbum: logic.onTapAlbum,
                    onTapCard: logic.onTapCard,
                    onTapFile: logic.onTapFile,
                    onTapLocation: logic.onTapLocation,
                    onSend: logic.sendTextNotification,
                    showAlbumIcon: false,
                    showCameraIcon: false,
                    showCardIcon: false,
                    showFileIcon: false,
                    showLocationIcon: false,
                  )),
            ],
          ),
        ),
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
    return InkWell(
      onTap: () => logic.removeIssuedMember(info),
      child: Container(
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
              constraints: BoxConstraints(maxWidth: 103.w),
              child: (name ?? '').toText
                ..style = Styles.ts_0C1C33_14sp
                ..maxLines = 1
                ..overflow = TextOverflow.ellipsis,
            ),
            8.horizontalSpace,
            Container(
              width: 16.w,
              height: 16.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.r),
                color: Styles.c_E8EAEF,
              ),
              child: Icon(
                Icons.clear,
                size: 10.w,
                color: Styles.c_8E9AB0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
