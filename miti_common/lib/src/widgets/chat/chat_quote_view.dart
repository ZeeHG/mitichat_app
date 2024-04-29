import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miti_common/miti_common.dart';

class ChatQuoteView extends StatelessWidget {
  const ChatQuoteView({
    Key? key,
    required this.quoteMsg,
    this.onTap,
    this.allAtMap = const <String, String>{},
  }) : super(key: key);
  final Message quoteMsg;
  final Function(Message message)? onTap;
  final Map<String, String> allAtMap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onTap?.call(quoteMsg),
        child: _ChatQuoteContentView(message: quoteMsg, allAtMap: allAtMap),
      );
}

class _ChatQuoteContentView extends StatelessWidget {
  const _ChatQuoteContentView({
    Key? key,
    required this.message,
    this.allAtMap = const <String, String>{},
  }) : super(key: key);
  final Message message;
  final Map<String, String> allAtMap;

  final _decoder = const JsonDecoder();

  @override
  Widget build(BuildContext context) {
    String name = message.senderNickname ?? '';
    String? content;
    // final atMap = <String, String>{};
    Widget? child;
    try {
      if (message.isTextType) {
        content = message.textElem!.content;
      } else if (message.isAtTextType) {
        content = message.atTextElem?.text;
        // message.atTextElem?.atUsersInfo?.forEach((element) {
        //   content = content?.replaceFirst(
        //       element.atUserID ?? "", element.groupNickname ?? "");
        // });
      } else if (message.isPictureType) {
        final picture = message.pictureElem;
        if (null != picture) {
          final url1 = picture.snapshotPicture?.url;
          final url2 = picture.sourcePicture?.url;
          final url = url1 ?? url2;
          if (MitiUtils.isUrlValid(url)) {
            child = ImageUtil.networkImage(
              url: url!,
              width: 32.w,
              height: 32.h,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(6.r),
            );
          }
        }
      } else if (message.isVideoType) {
        final video = message.videoElem;
        if (null != video) {
          child = Stack(
            alignment: Alignment.center,
            children: [
              ImageUtil.networkImage(
                url: video.snapshotUrl!,
                width: 32.w,
                height: 32.h,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(6.r),
              ),
              ImageLibrary.videoPause.toImage
                ..width = 12.w
                ..height = 12.h,
            ],
          );
        }
      } else if (message.isVoiceType) {
        content = '[${StrLibrary.voice}]';
      } else if (message.isCardType) {
        String name = message.cardElem!.nickname!;
        content = '[${StrLibrary.carte}]$name';
      } else if (message.isFileType) {
        final file = message.fileElem;
        if (null != file) {
          final name = file.fileName ?? '';
          final size = MitiUtils.formatBytes(file.fileSize ?? 0);
          content = '$name($size)';
          child = MitiUtils.fileIcon(name).toImage
            ..width = 26.w
            ..height = 30.h;
        }
      } else if (message.isLocationType) {
        final location = message.locationElem;
        if (null != location) {
          final map = _decoder.convert(location.description!);
          final url = map['url'];
          final name = map['name'];
          final addr = map['addr'];
          content = '[${StrLibrary.location}]$name($addr)';
          child = Stack(
            alignment: Alignment.center,
            children: [
              ImageUtil.networkImage(
                url: url!,
                width: 32.w,
                height: 32.h,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(6.r),
              ),
              FaIcon(
                FontAwesomeIcons.locationDot,
                size: 12.w,
                color: StylesLibrary.c_8443F8,
              ),
            ],
          );
        }
      } else if (message.isQuoteType) {
      } else if (message.isMergerType) {
        content = '[${StrLibrary.chatRecord}]';
      } else if (message.isCustomFaceType) {
      } else if (message.isCustomType) {
        if (message.isTagTextType) {
          content = message.tagContent?.textElem?.content;
        }
      } else if (message.isRevokeType) {
        content = StrLibrary.quoteContentBeRevoked;
      } else if (message.isNotificationType) {}
    } catch (e, s) {
      myLogger.e({"error": e, "stack": s});
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      margin: EdgeInsets.only(top: 4.h),
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        color: StylesLibrary.c_F4F5F7,
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth - 70.w),
            child: ChatText(
              text: '$name：${content ?? ''}',
              selectMode: false,
              allAtMap: allAtMap,
              textStyle: StylesLibrary.ts_999999_14sp,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              patterns: [
                MatchPattern(
                  type: PatternType.at,
                  style: StylesLibrary.ts_999999_14sp,
                )
              ],
            ),
          ),
          if (null != child) child
        ],
      ),
    );
  }
}
