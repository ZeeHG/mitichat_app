import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_keyword_text/search_keyword_text.dart';
import 'package:sprintf/sprintf.dart';
import '../../widgets/chat_file_download_progress_view.dart';
import 'global_search_logic.dart';

class GlobalSearchPage extends StatelessWidget {
  final logic = Get.find<GlobalSearchLogic>();

  GlobalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: TitleBar.search(
          focusNode: logic.focusNode,
          controller: logic.searchCtrl,
          onSubmitted: (_) => logic.search(),
          onCleared: () => logic.focusNode.requestFocus(),
          onChanged: (_) => logic.search(),
        ),
        backgroundColor: Styles.c_F8F9FA,
        body: Obx(() => Column(
              children: [
                _tabBar(),
                if (logic.searchKey.isNotEmpty)
                  logic.isAllEmpty
                      ? _emptyView
                      : Flexible(
                          child: IndexedStack(
                            index: logic.index.value,
                            children: [
                              _allView(),
                              _contactsView(),
                              _groupView(),
                              _chatHistoryView(),
                              _fileView(),
                            ],
                          ),
                        ),
              ],
            )),
      ),
    );
  }

  Widget _allView() => ListView(
        padding: EdgeInsets.only(top: 10.h),
        children: [
          if (logic.contactsList.isNotEmpty)
            _categoryContainer(
              title: StrLibrary.globalSearchContacts,
              children: logic
                  .subList(logic.contactsList)
                  .map((e) => itemView(
                        nickname: e.nickname,
                        faceURL: e.faceURL,
                        onTap: () => logic.viewUserProfile(e),
                      ))
                  .toList(),
              seeMoreStr: logic.contactsList.length > 3
                  ? StrLibrary.seeMoreRelatedContacts
                  : null,
              onSeeMore: () => logic.switchTab(1),
            ),
          if (logic.groupList.isNotEmpty)
            _categoryContainer(
              title: StrLibrary.globalSearchGroup,
              children: logic
                  .subList(logic.groupList)
                  .map((e) => itemView(
                        nickname: e.groupName,
                        faceURL: e.faceURL,
                        isGroup: true,
                        onTap: () => logic.viewGroup(e),
                      ))
                  .toList(),
              seeMoreStr: logic.groupList.length > 3
                  ? StrLibrary.seeMoreRelatedGroup
                  : null,
              onSeeMore: () => logic.switchTab(2),
            ),
          if (logic.textMessageList.isNotEmpty)
            _categoryContainer(
              title: StrLibrary.globalSearchChatHistory,
              children: logic.subList(logic.textMessageList).map((e) {
                final message = e.messageList?.firstOrNull;
                final showName = e.showName;
                final faceURL = e.faceURL;
                final sendTime = message?.sendTime;
                final count = e.messageCount ?? 0;
                final content = count > 1
                    ? sprintf(StrLibrary.relatedChatHistory, [count])
                    : logic.calContent(message!);
                final time = null == sendTime
                    ? null
                    : MitiUtils.getChatTimeline(sendTime);
                return itemView(
                  nickname: showName,
                  faceURL: faceURL,
                  time: time,
                  content: content,
                  isChatText: true,
                  isGroup: message?.isSingleChat == false,
                  onTap: () => logic.viewMessage(e),
                );
              }).toList(),
              seeMoreStr: logic.textMessageList.length > 3
                  ? StrLibrary.seeMoreRelatedChatHistory
                  : null,
              onSeeMore: () => logic.switchTab(3),
            ),
          if (logic.fileMessageList.isNotEmpty)
            _categoryContainer(
              title: StrLibrary.globalSearchChatFile,
              children: logic
                  .subList(logic.fileMessageList)
                  .map((e) => itemView(
                        nickname: MitiUtils.calContent(
                          content: e.fileElem?.fileName ?? '',
                          key: logic.searchKey.value,
                          style: Styles.ts_333333_16sp,
                          usedWidth: 44.w + 80.w + 26.w,
                        ),
                        fileIcon: ChatFileIconView(
                          message: e,
                          downloadProgressView: ChatFileDownloadProgressView(e),
                        ),
                        content: e.senderNickname,
                        onTap: () => logic.viewFile(e),
                      ))
                  .toList(),
              seeMoreStr: logic.fileMessageList.length > 3
                  ? StrLibrary.seeMoreRelatedFile
                  : null,
              onSeeMore: () => logic.switchTab(4),
            ),
        ],
      );

  Widget _contactsView() => logic.contactsList.isEmpty
      ? _emptyView
      : ListView(
          padding: EdgeInsets.only(top: 10.h),
          children: List.generate(logic.contactsList.length, (i) {
            final item = logic.contactsList[i];
            return itemView(
              nickname: item.nickname,
              faceURL: item.faceURL,
              onTap: () => logic.viewUserProfile(item),
            );
          }));

  Widget _groupView() => logic.groupList.isEmpty
      ? _emptyView
      : ListView(
          padding: EdgeInsets.only(top: 10.h),
          children: List.generate(logic.groupList.length, (i) {
            final item = logic.groupList[i];
            return itemView(
              nickname: item.groupName,
              faceURL: item.faceURL,
              isGroup: true,
              onTap: () => logic.viewGroup(item),
            );
          }),
        );

  Widget _chatHistoryView() => logic.textMessageList.isEmpty
      ? _emptyView
      : SmartRefresher(
          key: const ValueKey(0),
          controller: logic.textMessageRefreshCtrl,
          enablePullDown: false,
          enablePullUp: true,
          footer: IMViews.buildFooter(),
          onLoading: logic.loadTextMessage,
          child: ListView(
            padding: EdgeInsets.only(top: 10.h),
            children:
                List.generate(logic.textMessageList.length, (index) {
              final e = logic.textMessageList[index];
              final message = e.messageList?.firstOrNull;
              final sendTime = message?.sendTime;
              final count = e.messageCount ?? 0;
              return itemView(
                nickname: e.showName,
                faceURL: e.faceURL,
                time: null == sendTime
                    ? null
                    : MitiUtils.getChatTimeline(sendTime),
                content: count > 1
                    ? sprintf(StrLibrary.relatedChatHistory, [count])
                    : logic.calContent(message!),
                isChatText: true,
                isGroup: message?.isSingleChat == false,
                onTap: () => logic.viewMessage(e),
              );
            }),
          ),
        );

  Widget _fileView() => logic.fileMessageList.isEmpty
      ? _emptyView
      : SmartRefresher(
          key: const ValueKey(1),
          controller: logic.fileMessageRefreshCtrl,
          enablePullDown: false,
          enablePullUp: true,
          footer: IMViews.buildFooter(),
          onLoading: logic.loadFileMessage,
          child: ListView(
            padding: EdgeInsets.only(top: 10.h),
            children: List.generate(logic.fileMessageList.length, (index) {
              final e = logic.fileMessageList[index];
              return itemView(
                nickname: MitiUtils.calContent(
                  content: e.fileElem?.fileName ?? '',
                  key: logic.searchKey.value,
                  style: Styles.ts_333333_16sp,
                  usedWidth: 44.w + 80.w + 26.w,
                ),
                fileIcon: ChatFileIconView(
                  message: e,
                  downloadProgressView: ChatFileDownloadProgressView(e),
                ),
                content: e.senderNickname,
                onTap: () => logic.viewFile(e),
              );
            }),
          ),
        );

  Widget _categoryContainer({
    required String title,
    List<Widget> children = const [],
    String? seeMoreStr,
    Function()? onSeeMore,
  }) =>
      Container(
        margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 6.h),
              child: title.toText..style = Styles.ts_999999_14sp,
            ),
            ...children,
            if (null != seeMoreStr)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onSeeMore,
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    border: BorderDirectional(
                      top: BorderSide(
                        color: Styles.c_E8EAEF,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      seeMoreStr.toText..style = Styles.ts_9280B3_16sp,
                      const Spacer(),
                      ImageRes.appRightArrow.toImage
                        ..width = 24.w
                        ..height = 24.h,
                    ],
                  ),
                ),
              ),
          ],
        ),
      );

  Widget itemView({
    Widget? fileIcon,
    String? nickname,
    String? fileName,
    String? faceURL,
    String? time,
    String? content,
    bool isGroup = false,
    bool isChatText = false,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          color: Styles.c_FFFFFF,
          child: Row(
            children: [
              fileIcon ??
                  AvatarView(
                    text: nickname,
                    url: faceURL,
                    isGroup: isGroup,
                  ),
              10.horizontalSpace,
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: isChatText
                                ? ((nickname ?? '').toText
                                  ..style = Styles.ts_333333_16sp
                                  ..maxLines = 1
                                  ..overflow = TextOverflow.ellipsis)
                                : SearchKeywordText(
                                    text: nickname ?? fileName ?? '',
                                    keyText: logic.searchKey.value,
                                    style: Styles.ts_333333_16sp,
                                    keyStyle: Styles.ts_9280B3_16sp,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                        if (time != null)
                          time.toText..style = Styles.ts_999999_14sp,
                      ],
                    ),
                    if (null != content)
                      SearchKeywordText(
                        text: content,
                        keyText: logic.searchKey.value,
                        style: Styles.ts_999999_14sp,
                        keyStyle: Styles.ts_9280B3_14sp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget _tabBar() {
    Widget tabItem({
      required String label,
      required int index,
      bool isChecked = false,
    }) =>
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => logic.switchTab(index),
          child: SizedBox(
            height: 48.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                label.toText
                  ..style = (isChecked
                      ? Styles.ts_9280B3_16sp_medium
                      : Styles.ts_999999_16sp),
                if (isChecked)
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 36.w,
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: Styles.c_9280B3,
                        borderRadius: BorderRadius.circular(2.5.r),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
    return Container(
      color: Styles.c_FFFFFF,
      height: 48.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          logic.tabs.length,
          (i) => tabItem(
            index: i,
            label: logic.tabs[i],
            isChecked: logic.index.value == i,
          ),
        ),
      ),
    );
  }

  Widget get _emptyView => Container(
        width: 1.sw,
        margin: EdgeInsets.only(top: 30.h),
        child: StrLibrary.searchNotFound.toText
          ..style = Styles.ts_999999_16sp
          ..textAlign = TextAlign.center,
      );
}
