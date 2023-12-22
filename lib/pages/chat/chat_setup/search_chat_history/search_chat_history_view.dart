import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_keyword_text/search_keyword_text.dart';
import 'package:sprintf/sprintf.dart';

import 'search_chat_history_logic.dart';

class SearchChatHistoryPage extends StatelessWidget {
  final logic = Get.find<SearchChatHistoryLogic>();

  SearchChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.search(
          controller: logic.searchCtrl,
          focusNode: logic.focusNode,
          onSubmitted: (_) => logic.search(),
          onCleared: logic.clearInput,
          onChanged: logic.onChanged,
        ),
        backgroundColor: Styles.c_FFFFFF,
        body: Obx(() => logic.isNotKey
            ? _defaultView
            : (logic.isSearchNotResult ? _emptyListView : _resultView)),
      ),
    );
  }

  Widget _buildItemView(Message message) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => logic.previewMessageHistory(message),
        child: Container(
          height: 66.h,
          color: Styles.c_FFFFFF,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              AvatarView(
                url: message.senderFaceUrl,
                text: message.senderNickname,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 10.w),
                  decoration: BoxDecoration(
                    border: BorderDirectional(
                      bottom: BorderSide(color: Styles.c_E8EAEF, width: 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          (message.senderNickname ?? '').toText
                            ..style = Styles.ts_8E9AB0_14sp,
                          const Spacer(),
                          IMUtils.getChatTimeline(message.sendTime ?? 0).toText
                            ..style = Styles.ts_8E9AB0_14sp,
                        ],
                      ),
                      2.verticalSpace,
                      SearchKeywordText(
                        text: logic.calContent(message),
                        keyText: logic.searchKey.value,
                        style: Styles.ts_0C1C33_17sp,
                        keyStyle: Styles.ts_0089FF_17sp,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Widget get _resultView => SmartRefresher(
        controller: logic.refreshController,
        footer: IMViews.buildFooter(),
        enablePullDown: false,
        enablePullUp: true,
        onLoading: logic.load,
        child: ListView.builder(
          itemCount: logic.messageList.length,
          itemBuilder: (_, index) =>
              _buildItemView(logic.messageList.elementAt(index)),
        ),
      );

  Widget get _defaultView => Column(
        children: [
          32.verticalSpace,
          StrRes.quicklyFindChatHistory.toText..style = Styles.ts_8E9AB0_14sp,
          34.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StrRes.picture.toText
                ..style = Styles.ts_0089FF_17sp
                ..onTap = logic.searchChatHistoryPicture,
              StrRes.video.toText
                ..style = Styles.ts_0089FF_17sp
                ..onTap = logic.searchChatHistoryVideo,
              StrRes.file.toText
                ..style = Styles.ts_0089FF_17sp
                ..onTap = logic.searchChatHistoryFile,
            ],
          ),
        ],
      );

  Widget get _emptyListView => SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            85.verticalSpace,
            ImageRes.searchNotFound.toImage
              ..width = 125.w
              ..height = 76.h,
            22.verticalSpace,
            sprintf(StrRes.notFoundChatHistory, [logic.searchKey.value]).toText
              ..style = Styles.ts_8E9AB0_17sp,
          ],
        ),
      );
}
