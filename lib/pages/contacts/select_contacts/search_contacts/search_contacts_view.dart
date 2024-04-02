import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:search_keyword_text/search_keyword_text.dart';

import '../select_contacts_logic.dart';
import 'search_contacts_logic.dart';

class SelectContactsFromSearchPage extends StatelessWidget {
  final logic = Get.find<SelectContactsFromSearchLogic>();
  final selectContactsLogic = Get.find<SelectContactsLogic>();

  SelectContactsFromSearchPage({super.key});

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
            ? _emptyListView
            : ListView.builder(
                itemCount: logic.resultList.length,
                itemBuilder: (_, index) =>
                    _buildItemView(logic.resultList.elementAt(index)),
              )),
      ),
    );
  }

  Widget _buildItemView(dynamic info) {
    Widget buildChild() => GestureDetector(
          onTap: selectContactsLogic.onTap(info),
          behavior: HitTestBehavior.translucent,
          child: Container(
            height: 64.h,
            color: StylesLibrary.c_FFFFFF,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                if (selectContactsLogic.isMultiModel)
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: ChatRadio(
                      checked: selectContactsLogic.isChecked(info),
                      enabled: !selectContactsLogic.isDefaultChecked(info),
                    ),
                  ),
                AvatarView(
                  url: logic.parseFaceURL(info),
                  text: logic.parseNickname(info),
                  isGroup: info is GroupInfo,
                ),
                10.horizontalSpace,
                // info.getShowName().toText..style = StylesLibrary.ts_333333_17sp,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SearchKeywordText(
                        text: logic.parseNickname(info) ?? '',
                        keyText: logic.searchCtrl.text.trim(),
                        style: StylesLibrary.ts_333333_17sp,
                        keyStyle: StylesLibrary.ts_8443F8_17sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    return selectContactsLogic.isMultiModel ? Obx(buildChild) : buildChild();
  }

  Widget get _emptyListView => SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 157.verticalSpace,
            // ImageLibrary.blacklistEmpty.toImage
            //   ..width = 120.w
            //   ..height = 120.h,
            // 22.verticalSpace,
            44.verticalSpace,
            StrLibrary.searchNotFound.toText
              ..style = StylesLibrary.ts_999999_17sp,
          ],
        ),
      );
}
