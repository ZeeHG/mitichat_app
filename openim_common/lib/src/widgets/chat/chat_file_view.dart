import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatFileView extends StatelessWidget {
  const ChatFileView({
    Key? key,
    required this.message,
    required this.isISend,
    this.sendProgressStream,
    this.fileDownloadProgressView,
  }) : super(key: key);
  final Message message;
  final Stream<MsgStreamEv<int>>? sendProgressStream;
  final bool isISend;
  final Widget? fileDownloadProgressView;

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints(maxWidth: maxWidth),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      width: maxWidth,
      height: 64.h,
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        border: Border.all(color: Styles.c_E8EAEF, width: 1),
        borderRadius: borderRadius(isISend),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWithMidEllipsis(
                      message.fileElem?.fileName ?? '',
                      style: Styles.ts_0C1C33_17sp,
                      endPartLength: 8,
                    ),
                    // fileName.toText
                    //   ..style = Styles.ts_0C1C33_17sp
                    //   ..maxLines = 1
                    //   ..overflow = TextOverflow.ellipsis,
                    IMUtils.formatBytes(message.fileElem?.fileSize ?? 0).toText
                      ..style = Styles.ts_8E9AB0_14sp,
                  ],
                ),
              ),
              10.horizontalSpace,
              ChatFileIconView(
                message: message,
                sendProgressStream: sendProgressStream,
                downloadProgressView: fileDownloadProgressView,
              ),
              // Stack(
              //   children: [
              //     IMUtils.fileIcon(fileName).toImage
              //       ..width = 38.w
              //       ..height = 44.h,
              //     ChatProgressView(
              //       isISend: isISend,
              //       width: 38.w,
              //       height: 44.h,
              //       id: id,
              //       stream: sendProgressStream,
              //       type: ProgressType.file,
              //     ),
              //     if (null != fileDownloadProgressView)
              //       fileDownloadProgressView!,
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
