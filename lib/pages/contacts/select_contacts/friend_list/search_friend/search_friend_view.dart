import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:search_keyword_text/search_keyword_text.dart';

import '../../select_contacts_logic.dart';
import 'search_friend_logic.dart';

class SelectContactsFromSearchFriendsPage extends StatelessWidget {
  final logic = Get.find<SelectContactsFromSearchFriendsLogic>();
  final selectContactsLogic = Get.find<SelectContactsLogic>();

  SelectContactsFromSearchFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final originList = {...selectContactsLogic.checkedList};
    return KeyboardDismissOnTap(
      child: Scaffold(
        // appBar: TitleBar.search(
        //   focusNode: logic.focusNode,
        //   controller: logic.searchCtrl,
        //   onSubmitted: (_) => logic.search(),
        //   onCleared: () => logic.focusNode.requestFocus(),
        // ),
        appBar: TitleBar(
            center: Expanded(
                child: logic.appBarTitle.toText
                  ..style = StylesLibrary.ts_333333_18sp_medium
                  ..textAlign = TextAlign.center),
            left: Flexible(
                child: Container(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  selectContactsLogic.checkedList.assignAll(originList);
                  Get.back();
                },
                child: StrLibrary.cancel.toText
                  ..style = StylesLibrary.ts_333333_16sp_medium,
              ),
            )),
            right: Flexible(
              child: Container(
                alignment: Alignment.centerRight,
                child: IntrinsicWidth(
                  child: Button(
                      text: StrLibrary.confirm,
                      textStyle: StylesLibrary.ts_FFFFFF_14sp,
                      disabledTextStyle: StylesLibrary.ts_FFFFFF_14sp,
                      height: 28.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      onTap: () {
                        Get.back();
                      }),
                ),
              ),
            )),
        backgroundColor: StylesLibrary.c_FFFFFF,
        body: Obx(() => Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SearchBox(
                      enabled: true,
                      controller: logic.searchCtrl,
                      focusNode: logic.focusNode,
                      onSubmitted: (_) => logic.search(),
                      onChanged: (_) => logic.search(),
                      onCleared: () => logic.focusNode.requestFocus(),
                    )),
                Expanded(
                    child: logic.isSearchNotResult
                        ? _emptyListView
                        : ListView.builder(
                            itemCount: logic.resultList.length,
                            itemBuilder: (_, index) =>
                                _buildItemView(logic.resultList[index]),
                          ))
              ],
            )),
      ),
    );
  }

  Widget _buildItemView(ISUserInfo info) {
    Widget buildChild() => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: selectContactsLogic.onTap(info),
          child: Container(
            height: 64.h,
            color: StylesLibrary.c_FFFFFF,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                  url: info.faceURL,
                  text: info.showName,
                ),
                10.horizontalSpace,
                // info.getShowName().toText..style = StylesLibrary.ts_333333_17sp,
                SearchKeywordText(
                  text: info.showName,
                  keyText: logic.searchCtrl.text.trim(),
                  style: StylesLibrary.ts_333333_17sp,
                  keyStyle: StylesLibrary.ts_8443F8_17sp,
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
