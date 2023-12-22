import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'multimedia_logic.dart';

class ChatHistoryMultimediaPage extends StatelessWidget {
  final logic = Get.find<ChatHistoryMultimediaLogic>();

  ChatHistoryMultimediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: logic.isPicture ? StrRes.picture : StrRes.video,
        showUnderline: true,
      ),
      backgroundColor: Styles.c_FFFFFF,
      body: Obx(() => SmartRefresher(
            controller: logic.refreshController,
            onRefresh: logic.onRefresh,
            onLoading: logic.onLoad,
            header: IMViews.buildHeader(),
            footer: IMViews.buildFooter(),
            child: _buildListView(),
          )),
    );
  }

  Widget _buildListView() {
    final mediaMessages = logic.messageList.reversed.toList();

    return ListView.builder(
      itemCount: logic.groupMessage.length,
      shrinkWrap: true,
      itemBuilder: (_, index) {
        var entry = logic.groupMessage.entries.toList().reversed.elementAt(index);
        return MultimediaItemWidget(
          list: entry.value,
          label: entry.key,
          isVideo: !logic.isPicture,
          onTap: (message) {
            final currentIndex = mediaMessages.indexOf(message);
            IMUtils.previewMediaFile(context: Get.context!, currentIndex: currentIndex, mediaMessages: mediaMessages);
          },
          snapshotUrl: logic.getSnapshotUrl,
        );
      },
    );
  }
}

class MultimediaItemWidget extends StatelessWidget {
  const MultimediaItemWidget({
    Key? key,
    required this.list,
    required this.label,
    required this.snapshotUrl,
    this.isVideo = false,
    this.onTap,
  }) : super(key: key);
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
          child: label.toText..style = Styles.ts_8E9AB0_14sp,
        ),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.0,
            crossAxisCount: 4,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (_, index) => _buildItemView(list.elementAt(index)),
        ),
      ],
    );
  }

  Widget _buildItemView(Message message) => GestureDetector(
        onTap: () => onTap?.call(message),
        child: Hero(
          tag: message.clientMsgID!,
          placeholderBuilder: (BuildContext context, Size heroSize, Widget child) => child,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Styles.c_E8EAEF),
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
                    ..width = 40.w
                    ..height = 40.h,
              ],
            ),
          ),
        ),
      );
}
