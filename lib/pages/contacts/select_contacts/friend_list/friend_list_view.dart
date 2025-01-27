import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../select_contacts_logic.dart';
import 'friend_list_logic.dart';

class SelectContactsFromFriendsPage extends StatelessWidget {
  final logic = Get.find<SelectContactsFromFriendsLogic>();
  final selectContactsLogic = Get.find<SelectContactsLogic>();

  SelectContactsFromFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: logic.appBarTitle),
      backgroundColor: StylesLibrary.c_F7F8FA,
      body: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: logic.searchFriend,
            child: Container(
              color: StylesLibrary.c_FFFFFF,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: FakeSearchBox(),
            ),
          ),
          if (selectContactsLogic.isMultiModel)
            Container(
              padding: EdgeInsets.only(top: 12.h),
              color: StylesLibrary.c_F7F8FA,
              child: Container(
                color: StylesLibrary.c_FFFFFF,
                child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: logic.selectAll,
                    child: Container(
                        height: 54.h,
                        color: StylesLibrary.c_FFFFFF,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          children: [
                            Obx(() => Padding(
                                  padding: EdgeInsets.only(right: 14.w),
                                  child: ChatRadio(checked: logic.isSelectAll),
                                )),
                            12.horizontalSpace,
                            StrLibrary.selectAll.toText
                              ..style = StylesLibrary.ts_333333_16sp,
                          ],
                        ))),
              ),
            ),
          Flexible(
            child: Obx(
              () => AzList<ISUserInfo>(
                data: logic.friendList,
                itemCount: logic.friendList.length,
                itemBuilder: (_, data, index) => _buildItemView(data),
              ),
            ),
          ),
          selectContactsLogic.checkedConfirmView,
        ],
      ),
    );
  }

  Widget _buildItemView(ISUserInfo info) {
    Widget buildChild() => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: selectContactsLogic.onTap(info),
          child: Container(
            height: 54.h,
            color: StylesLibrary.c_FFFFFF,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                if (selectContactsLogic.isMultiModel)
                  Padding(
                    padding: EdgeInsets.only(right: 14.w),
                    child: ChatRadio(
                      checked: selectContactsLogic.isChecked(info),
                      enabled: !selectContactsLogic.isDefaultChecked(info),
                    ),
                  ),
                AvatarView(
                  url: info.faceURL,
                  text: info.showName,
                ),
                12.horizontalSpace,
                info.showName.toText..style = StylesLibrary.ts_333333_16sp,
              ],
            ),
          ),
        );
    return selectContactsLogic.isMultiModel ? Obx(buildChild) : buildChild();
  }
}
