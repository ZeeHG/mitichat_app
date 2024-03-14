import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../select_contacts_logic.dart';
import 'tag_list_logic.dart';

class SelectContactsFromTagPage extends StatelessWidget {
  final logic = Get.find<SelectContactsFromTagLogic>();
  final selectContactsLogic = Get.find<SelectContactsLogic>();

  SelectContactsFromTagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.tagGroup),
      backgroundColor: Styles.c_F8F9FA,
      body: Column(
        children: [
          if (selectContactsLogic.isMultiModel)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Ink(
                height: 64.h,
                color: Styles.c_FFFFFF,
                child: InkWell(
                  onTap: logic.selectAll,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Obx(() => Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: ChatRadio(checked: logic.isSelectAll),
                            )),
                        10.horizontalSpace,
                        StrLibrary.selectAll.toText
                          ..style = Styles.ts_333333_17sp,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: logic.operableList.length,
                  itemBuilder: (_, index) =>
                      _buildItemView(logic.operableList.elementAt(index)),
                )),
          ),
          selectContactsLogic.checkedConfirmView,
        ],
      ),
    );
  }

  // Widget _buildItemView(TagInfo tagInfo) => Container(
  //       height: 68.h,
  //       color: Styles.c_FFFFFF,
  //       padding: EdgeInsets.symmetric(horizontal: 15.w),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           tagInfo.tagName!.toText..style = Styles.ts_333333_17sp,
  //           6.verticalSpace,
  //           tagInfo.users!.map((e) => e.nickname!).join('、').toText
  //             ..style = Styles.ts_999999_14sp,
  //         ],
  //       ),
  //     );

  Widget _buildItemView(TagInfo info) {
    Widget buildChild() => Ink(
          height: 68.h,
          color: Styles.c_FFFFFF,
          child: InkWell(
            onTap: selectContactsLogic.onTap(info),
            child: Container(
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        info.tagName!.toText..style = Styles.ts_333333_17sp,
                        6.verticalSpace,
                        info.users!.map((e) => e.nickname!).join('、').toText
                          ..style = Styles.ts_999999_14sp,
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
    return selectContactsLogic.isMultiModel ? Obx(buildChild) : buildChild();
  }
}
