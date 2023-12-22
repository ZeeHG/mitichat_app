import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../widgets/file_download_progress.dart';
import 'file_logic.dart';

class ChatHistoryFilePage extends StatelessWidget {
  final logic = Get.find<ChatHistoryFileLogic>();

  ChatHistoryFilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.file, showUnderline: true),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => SmartRefresher(
            controller: logic.refreshController,
            onRefresh: logic.onRefresh,
            onLoading: logic.onLoad,
            header: IMViews.buildHeader(),
            footer: IMViews.buildFooter(),
            child: ListView.builder(
              itemCount: logic.messageList.length,
              itemBuilder: (_, index) =>
                  _buildItemView(logic.messageList.reversed.elementAt(index)),
            ),
          )),
    );
  }

  Widget _buildItemView(Message message) => GestureDetector(
        onTap: () => logic.viewFile(message),
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 76.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          color: Styles.c_FFFFFF,
          child: Row(
            children: [
              ChatFileIconView(
                message: message,
                downloadProgressView: FileDownloadProgressView(message),
              ),
              // IMUtils.fileIcon(message.fileElem!.fileName!).toImage
              //   ..width = 38.w
              //   ..height = 44.h,
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWithMidEllipsis(
                      message.fileElem!.fileName!,
                      style: Styles.ts_0C1C33_17sp,
                    ),
                    // message.fileElem!.fileName!.toText
                    //   ..style = Styles.ts_0C1C33_17sp
                    //   ..maxLines = 1,
                    Row(
                      children: [
                        IMUtils.formatBytes(message.fileElem!.fileSize!).toText
                          ..style = Styles.ts_8E9AB0_14sp,
                        10.horizontalSpace,
                        message.senderNickname!.toText
                          ..style = Styles.ts_8E9AB0_14sp,
                        10.horizontalSpace,
                        IMUtils.getChatTimeline(message.sendTime!).toText
                          ..style = Styles.ts_8E9AB0_14sp,
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
