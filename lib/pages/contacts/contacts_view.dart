import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim/pages/home/home_logic.dart';
import 'package:openim_common/openim_common.dart';

import 'contacts_logic.dart';

class ContactsPage extends StatelessWidget {
  final logic = Get.find<ContactsLogic>();
  Function(dynamic) switchHomeTab;
  RxInt homeTabIndex;
  final homeLogic = Get.find<HomeLogic>();

  ContactsPage(
      {super.key, required this.switchHomeTab, required this.homeTabIndex});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Scaffold(
      appBar: TitleBar.contacts(
          onClickAddContacts: logic.addContacts,
          onClickSearch: logic.searchContacts,
          onSwitchTab: switchHomeTab,
          homeTabIndex: homeTabIndex,
          unhandledCount: homeLogic.unhandledCount,
          mq: mq),
      backgroundColor: Styles.c_F7F8FA,
      body: Obx(
        () => Stack(
          children: [
            // SingleChildScrollView(
            //   child: Column(
            //     children: [
            //       _buildItemView(
            //         assetsName: ImageRes.appNewFriend,
            //         label: StrRes.newFriend,
            //         count: logic.friendApplicationCount,
            //         onTap: logic.newFriend,
            //       ),
            //       _buildItemView(
            //         assetsName: ImageRes.appNewGroup,
            //         label: StrRes.newGroupRequest,
            //         count: logic.groupApplicationCount,
            //         onTap: logic.newGroup,
            //       ),
            //       Container(
            //         decoration: BoxDecoration(color: Styles.c_F7F7F7),
            //         height: 6.h,
            //       ),
            //       _buildItemView(
            //         assetsName: ImageRes.appMyFriend,
            //         label: StrRes.myFriend,
            //         onTap: logic.myFriend,
            //       ),
            //       _buildItemView(
            //         assetsName: ImageRes.appMyGroup,
            //         label: StrRes.myGroup,
            //         onTap: logic.myGroup,
            //       ),
            //       // _buildItemView(
            //       //   assetsName: ImageRes.appTagGroup,
            //       //   label: StrRes.tagGroup,
            //       //   onTap: logic.tagGroup,
            //       // ),
            //       // _buildItemView(
            //       //   assetsName: ImageRes.appIssueNotice,
            //       //   label: StrRes.issueNotice,
            //       //   onTap: logic.notificationIssued,
            //       // ),
            //       // Container(
            //       //   decoration: BoxDecoration(color: Styles.c_F7F7F7),
            //       //   height: 6.h,
            //       // ),
            //       // _buildItemView(
            //       //   assetsName: ImageRes.appBot,
            //       //   label: StrRes.createBot,
            //       //   onTap: logic.createBot,
            //       // ),
            //     ],
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(top: 65.h),
              child: WrapAzListView<ISUserInfo>(
                data: logic.friendList,
                itemCount: logic.friendList.length,
                itemBuilder: (_, data, index) => _buildFriendItemView(data),
              ),
            ),
            Container(
              constraints: BoxConstraints(minWidth: 1.sw),
              color: Styles.c_FFFFFF,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(
                    left: 12.w, right: 12.w, top: 9.h, bottom: 20.h),
                child: Row(
                  children: List.generate(
                      logic.menus.length,
                      (index) => Row(
                            children: [
                              _buildMenuItemView(
                                  text: logic.menus[index]["text"],
                                  color: logic.menus[index]["color"],
                                  shadowColor: logic.menus[index]["shadowColor"],
                                  onTap: logic.menus[index]["onTap"]),
                              10.horizontalSpace
                            ],
                          )),
                )),
            ),
            IgnorePointer(
                ignoring: true,
                child: Container(
                  height: 183.h - 105.h - mq.padding.top,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(ImageRes.appHeaderBg3,
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
                      ..fit = BoxFit.cover
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

  Widget _buildMenuItemView({
    double? width,
    double? height,
    Color? color,
    TextStyle? tStyle,
    Color? shadowColor,
    required String text,
    Function()? onTap,
  }) {
    width = width ?? 95.w;
    height = height ?? 50.h;
    color = color ?? Styles.c_8544F8;
    tStyle = tStyle ?? Styles.ts_FFFFFF_14sp_medium;
    shadowColor = shadowColor ?? Color.fromRGBO(132, 67, 248, 0.5);
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 9.r,
                  offset: Offset(0, 3.r),
                ),
              ],
            ),
            height: height,
            constraints: BoxConstraints(maxWidth: width),
            // padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Center(
              child: text.toText..style = tStyle,
            )));
  }

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

  Widget _buildFriendItemView(ISUserInfo info) {
    Widget buildChild() => Ink(
          height: 54.h,
          color: Styles.c_FFFFFF,
          child: InkWell(
            onTap: () => logic.viewFriendInfo(info),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  AvatarView(
                    url: info.faceURL,
                    text: info.showName,
                  ),
                  12.horizontalSpace,
                  info.showName.toText..style = Styles.ts_333333_16sp,
                ],
              ),
            ),
          ),
        );
    return buildChild();
  }
}
