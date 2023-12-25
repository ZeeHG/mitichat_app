import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'contacts_logic.dart';

class ContactsPage extends StatelessWidget {
  final logic = Get.find<ContactsLogic>();

  ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Scaffold(
      appBar: TitleBar.contacts(
          onClickAddContacts: logic.addContacts,
          onClickSearch: logic.searchContacts,
          mq: mq),
      backgroundColor: Styles.c_FFFFFF,
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildItemView(
                    assetsName: ImageRes.appNewFriend,
                    label: StrRes.newFriend,
                    count: logic.friendApplicationCount,
                    onTap: logic.newFriend,
                  ),
                  _buildItemView(
                    assetsName: ImageRes.appNewGroup,
                    label: StrRes.newGroupRequest,
                    count: logic.groupApplicationCount,
                    onTap: logic.newGroup,
                  ),
                  Container(
                    decoration: BoxDecoration(color: Styles.c_F7F7F7),
                    height: 6.h,
                  ),
                  _buildItemView(
                    assetsName: ImageRes.appMyFriend,
                    label: StrRes.myFriend,
                    onTap: logic.myFriend,
                  ),
                  _buildItemView(
                    assetsName: ImageRes.appMyGroup,
                    label: StrRes.myGroup,
                    onTap: logic.myGroup,
                  ),
                  // _buildItemView(
                  //   assetsName: ImageRes.appTagGroup,
                  //   label: StrRes.tagGroup,
                  //   onTap: logic.tagGroup,
                  // ),
                  // _buildItemView(
                  //   assetsName: ImageRes.appIssueNotice,
                  //   label: StrRes.issueNotice,
                  //   onTap: logic.notificationIssued,
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(color: Styles.c_F7F7F7),
                  //   height: 6.h,
                  // ),
                  // _buildItemView(
                  //   assetsName: ImageRes.appBot,
                  //   label: StrRes.createBot,
                  //   onTap: logic.createBot,
                  // ),
                ],
              ),
            ),
            IgnorePointer(
                ignoring: true,
                child: Container(
                  height: 215.h - 105.h - mq.padding.top,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(ImageRes.appHeaderBg2,
                        package: 'openim_common'),
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.bottomCenter,
                  )),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildItemView({
    String? assetsName,
    required String label,
    Widget? icon,
    int count = 0,
    bool showRightArrow = true,
    double? height,
    Function()? onTap,
  }) =>
      Ink(
        color: Styles.c_FFFFFF,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height ?? 60.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                if (null != assetsName)
                  ClipOval(
                    child: assetsName.toImage
                      ..width = 40.w
                      ..height = 40.h,
                  ),
                if (null != icon) icon,
                12.horizontalSpace,
                label.toText..style = Styles.ts_332221_16sp,
                const Spacer(),
                if (count > 0) UnreadCountView(count: count),
                4.horizontalSpace,
                if (showRightArrow)
                  ImageRes.appRightArrow.toImage
                    ..width = 20.w
                    ..height = 20.h,
              ],
            ),
          ),
        ),
      );

// /// 我加入的部门
// List<Widget> _buildMyDeptView() => logic.myDeptList
//     .map((dept) => _buildItemView(
//           height: 48.h,
//           icon: SizedBox(
//             width: 42.w,
//             height: 42.h,
//             child: Center(
//               child: ImageRes.tree.toImage
//                 ..width = 18.w
//                 ..height = 18.h,
//             ),
//           ),
//           label: dept.department?.name ?? '',
//           onTap: () => logic.enterMyDepartment(dept.department),
//         ))
//     .toList();
}
