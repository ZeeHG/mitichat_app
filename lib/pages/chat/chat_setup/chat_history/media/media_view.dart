import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'media_logic.dart';

class ChatHistoryMediaPage extends StatelessWidget {
  final logic = Get.find<ChatHistoryMediaLogic>();

  ChatHistoryMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: logic.isPicture ? StrLibrary.picture : StrLibrary.video,
        showUnderline: true,
      ),
      backgroundColor: Styles.c_FFFFFF,
      body: Obx(() => SmartRefresher(
            controller: logic.refreshController,
            onRefresh: logic.onRefresh,
            onLoading: logic.onLoad,
            header: IMViews.buildHeader(),
            footer: IMViews.buildFooter(),
            child: _itemView(),
          )),
    );
  }

  Widget _itemView() {
    final mediaMessages = logic.messageList.reversed.toList();

    return ListView.builder(
      itemCount: logic.groupMessage.length,
      shrinkWrap: true,
      itemBuilder: (_, index) {
        var entry =
            logic.groupMessage.entries.toList().reversed.elementAt(index);
        return MediaListWidget(
          list: entry.value,
          label: entry.key,
          isVideo: !logic.isPicture,
          onTap: (message) {
            final currentIndex = mediaMessages.indexOf(message);
            MitiUtils.previewMediaFile(
                context: Get.context!,
                currentIndex: currentIndex,
                mediaMessages: mediaMessages);
          },
          snapshotUrl: logic.getSnapshotUrl,
        );
      },
    );
  }
}

class MediaListWidget extends StatelessWidget {
  const MediaListWidget({
    super.key,
    required this.list,
    required this.label,
    required this.snapshotUrl,
    this.isVideo = false,
    this.onTap,
  });
  final String label;
  final List<Message> list;
  final Function(Message message)? onTap;
  final String Function(Message message) snapshotUrl;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
          child: label.toText..style = Styles.ts_999999_14sp,
        ),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.0,
            crossAxisCount: 4,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (_, index) => _mediaItemView(list[index]),
        ),
      ],
    );
  }

  Widget _mediaItemView(Message message) => GestureDetector(
        onTap: () => onTap?.call(message),
        child: Hero(
          tag: message.clientMsgID!,
          placeholderBuilder:
              (BuildContext context, Size heroSize, Widget child) => child,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1.h, color: Styles.c_E8EAEF),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ImageUtil.networkImage(
                  url: snapshotUrl.call(message),
                  width: 94.w,
                  fit: BoxFit.cover,
                ),
                if (isVideo)
                  ImageRes.videoPause.toImage
                    ..width = 38.w
                    ..height = 38.h,
              ],
            ),
          ),
        ),
      );
}
