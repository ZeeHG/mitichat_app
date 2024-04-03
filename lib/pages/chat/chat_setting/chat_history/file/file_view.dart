import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../widgets/chat_file_download_progress_view.dart';
import 'file_logic.dart';

class ChatHistoryFilePage extends StatelessWidget {
  final logic = Get.find<ChatHistoryFileLogic>();

  ChatHistoryFilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.file, showUnderline: true),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: Obx(() => SmartRefresher(
            controller: logic.refreshController,
            onRefresh: logic.onRefresh,
            onLoading: logic.onLoad,
            header: IMViews.buildHeader(),
            footer: IMViews.buildFooter(),
            child: ListView.builder(
              itemCount: logic.messageList.length,
              itemBuilder: (_, index) =>
                  _itemView(logic.messageList.reversed.elementAt(index)),
            ),
          )),
    );
  }

  Widget _itemView(Message message) => GestureDetector(
        onTap: () => logic.viewFile(message),
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 80.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          color: StylesLibrary.c_FFFFFF,
          child: Row(
            children: [
              ChatFileIconView(
                message: message,
                downloadProgressView: ChatFileDownloadProgressView(message),
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWithMidEllipsis(
                      message.fileElem!.fileName!,
                      style: StylesLibrary.ts_333333_16sp,
                    ),
                    Row(
                      children: [
                        MitiUtils.formatBytes(message.fileElem!.fileSize!)
                            .toText
                          ..style = StylesLibrary.ts_999999_14sp,
                        10.horizontalSpace,
                        Expanded(
                            child: message.senderNickname!.toText
                              ..style = StylesLibrary.ts_999999_14sp
                              ..maxLines = 1
                              ..overflow = TextOverflow.ellipsis),
                        10.horizontalSpace,
                        MitiUtils.getChatTimeline(message.sendTime!).toText
                          ..style = StylesLibrary.ts_999999_14sp,
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
