import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_keyword_text/search_keyword_text.dart';
import 'package:sprintf/sprintf.dart';

import 'chat_history_logic.dart';

class ChatHistory extends StatelessWidget {
  final logic = Get.find<ChatHistoryLogic>();

  ChatHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Obx(() => Scaffold(
            appBar: TitleBar.search(
                controller: logic.searchCtrl,
                focusNode: logic.focusNode,
                onSubmitted: (_) => logic.search(),
                onCleared: logic.clearInput,
                onChanged: logic.onChanged,
                showUnderline: false),
            backgroundColor: StylesLibrary.c_FFFFFF,
            body: logic.isNotKey
                ? _categoryView
                : (logic.isSearchNotResult ? _emptyView : _resultView),
          )),
    );
  }

  Widget _resultItemView(Message message) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => logic.previewMessageHistory(message),
        child: Container(
          height: 70.h,
          color: StylesLibrary.c_FFFFFF,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                      bottom:
                          BorderSide(color: StylesLibrary.c_E8EAEF, width: 1.h),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          (message.senderNickname ?? '').toText
                            ..style = StylesLibrary.ts_999999_14sp,
                          const Spacer(),
                          MitiUtils.getChatTimeline(message.sendTime ?? 0)
                              .toText
                            ..style = StylesLibrary.ts_999999_14sp,
                        ],
                      ),
                      2.verticalSpace,
                      SearchKeywordText(
                        text: logic.calContent(message),
                        keyText: logic.searchKey.value,
                        style: StylesLibrary.ts_333333_16sp,
                        keyStyle: StylesLibrary.ts_8443F8_16sp,
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
          itemBuilder: (_, index) => _resultItemView(logic.messageList[index]),
        ),
      );

  Widget get _categoryView => Column(
        children: [
          50.verticalSpace,
          StrLibrary.quicklyFindChatHistory.toText
            ..style = StylesLibrary.ts_B3B3B3_12sp,
          15.verticalSpace,
          Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: 300.w,
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: logic.items.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2.w,
                    mainAxisSpacing: 20.h,
                    childAspectRatio: 96.w / 22.h,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return _categoryItemView(index: index);
                  }),
            ),
          )
        ],
      );

  Widget get _emptyView => SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            80.verticalSpace,
            ImageLibrary.searchNotFound.toImage
              ..width = 125.w
              ..height = 76.h,
            20.verticalSpace,
            sprintf(StrLibrary.notFoundChatHistory, [logic.searchKey.value])
                .toText
              ..style = StylesLibrary.ts_999999_16sp,
          ],
        ),
      );

  Widget _categoryItemView({
    required int index,
  }) {
    return Align(
      alignment: Alignment.center,
      child: "${logic.items[index]}".toText
        ..style = StylesLibrary.ts_9280B3_16sp
        ..onTap = () => logic.clickItem(logic.items[index]!),
    );
  }
}
