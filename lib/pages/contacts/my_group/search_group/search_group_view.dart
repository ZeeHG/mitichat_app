import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:search_keyword_text/search_keyword_text.dart';
import 'package:sprintf/sprintf.dart';

import 'search_group_logic.dart';

class SearchGroupPage extends StatelessWidget {
  final logic = Get.find<SearchGroupLogic>();

  SearchGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: TitleBar.search(
          focusNode: logic.focusNode,
          controller: logic.searchCtrl,
          onSubmitted: (_) => logic.search(),
          onCleared: () => logic.focusNode.requestFocus(),
        ),
        backgroundColor: StylesLibrary.c_F8F9FA,
        body: Obx(() => logic.isSearchNotResult
            ? _emptyList
            : ListView.builder(
                itemCount: logic.resultList.length,
                itemBuilder: (_, index) => _item(logic.resultList[index]),
              )),
      ),
    );
  }

  Widget _item(GroupInfo info) => GestureDetector(
        onTap: () => logic.toGroupChat(info),
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 64.h,
          color: StylesLibrary.c_FFFFFF,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              AvatarView(
                url: info.faceURL,
                text: info.groupName,
                isGroup: true,
              ),
              10.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SearchKeywordText(
                    text: info.groupName ?? '',
                    keyText: logic.searchCtrl.text.trim(),
                    style: StylesLibrary.ts_333333_16sp,
                    keyStyle: StylesLibrary.ts_8443F8_16sp,
                  ),
                  sprintf(StrLibrary.nPerson, [info.memberCount]).toText
                    ..style = StylesLibrary.ts_999999_14sp,
                ],
              ),
            ],
          ),
        ),
      );

  Widget get _emptyList => SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            40.verticalSpace,
            StrLibrary.searchNotFound.toText
              ..style = StylesLibrary.ts_999999_16sp,
          ],
        ),
      );
}
