import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import '../select_contacts_logic.dart';
import 'group_list_logic.dart';

class SelectContactsFromGroupPage extends StatelessWidget {
  final logic = Get.find<SelectContactsFromGroupLogic>();
  final selectContactsLogic = Get.find<SelectContactsLogic>();

  SelectContactsFromGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.myGroup),
      backgroundColor: Styles.c_F8F9FA,
      body: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: logic.searchGroup,
            child: Container(
              color: Styles.c_FFFFFF,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: FakeSearchBox(),
            ),
          ),
          if (selectContactsLogic.isMultiModel)
            Container(
                padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                color: Styles.c_F7F8FA,
                child: Container(
                  color: Styles.c_FFFFFF,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: logic.selectAll,
                    child: Container(
                      height: 64.h,
                      color: Styles.c_FFFFFF,
                      child: Row(
                        children: [
                          Obx(() => Padding(
                                padding: EdgeInsets.only(right: 14.w),
                                child: ChatRadio(checked: logic.isSelectAll),
                              )),
                          10.horizontalSpace,
                          StrLibrary.selectAll.toText
                            ..style = Styles.ts_333333_16sp,
                        ],
                      ),
                    ),
                  ),
                )),
          Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: logic.allList.length,
                    itemBuilder: (_, index) => _itemView(logic.allList[index]),
                  ))),
          selectContactsLogic.checkedConfirmView,
        ],
      ),
    );
  }

  Widget _itemView(GroupInfo info) {
    Widget buildChild() => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: selectContactsLogic.onTap(info),
          child: Container(
            height: 64.h,
            color: Styles.c_FFFFFF,
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
                  text: info.groupName,
                  isGroup: true,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (info.groupName ?? '').toText
                        ..style = Styles.ts_333333_16sp
                        ..maxLines = 1
                        ..overflow = TextOverflow.ellipsis,
                      sprintf(StrLibrary.nPerson, [info.memberCount]).toText
                        ..style = Styles.ts_999999_14sp,
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    return selectContactsLogic.isMultiModel ? Obx(buildChild) : buildChild();
  }
}
