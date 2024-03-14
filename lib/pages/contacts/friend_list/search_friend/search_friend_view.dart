import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:search_keyword_text/search_keyword_text.dart';

import 'search_friend_logic.dart';

class SearchFriendPage extends StatelessWidget {
  final logic = Get.find<SearchFriendLogic>();

  SearchFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.search(
          focusNode: logic.focusNode,
          controller: logic.searchCtrl,
          onSubmitted: (_) => logic.search(),
          onCleared: () => logic.focusNode.requestFocus(),
        ),
        backgroundColor: Styles.c_F8F9FA,
        body: Obx(() => logic.isSearchNotResult
            ? _emptyListView
            : ListView.builder(
                itemCount: logic.resultList.length,
                itemBuilder: (_, index) =>
                    _buildItemView(logic.resultList[index]),
              )),
      ),
    );
  }

  Widget _buildItemView(ISUserInfo info) => Ink(
        height: 64.h,
        color: Styles.c_FFFFFF,
        child: InkWell(
          onTap: () => logic.viewFriendInfo(info),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                AvatarView(
                  url: info.faceURL,
                  text: info.showName,
                ),
                10.horizontalSpace,
                SearchKeywordText(
                  text: info.showName,
                  keyText: logic.searchCtrl.text.trim(),
                  style: Styles.ts_333333_17sp,
                  keyStyle: Styles.ts_8443F8_17sp,
                ),
                // info.getShowName().toText..style = Styles.ts_333333_17sp,
              ],
            ),
          ),
        ),
      );

  Widget get _emptyListView => SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 157.verticalSpace,
            // ImageRes.blacklistEmpty.toImage
            //   ..width = 120.w
            //   ..height = 120.h,
            // 22.verticalSpace,
            44.verticalSpace,
            StrLibrary.searchNotFound.toText..style = Styles.ts_999999_17sp,
          ],
        ),
      );
}
