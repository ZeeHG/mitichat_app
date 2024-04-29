import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/pages/conversation/conversation_logic.dart';
import 'package:miti/pages/home/home_logic.dart';
import 'package:miti_common/miti_common.dart';

import 'contacts_logic.dart';

class ContactsPage extends StatelessWidget {
  final logic = Get.find<ContactsLogic>();
  final conversationLogic = Get.find<ConversationLogic>();
  final homeLogic = Get.find<HomeLogic>();

  ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Scaffold(
      appBar: TitleBar.contacts(
          popCtrl: logic.popCtrl,
          onScan: logic.scan,
          onAddFriend: logic.addFriend,
          onAddGroup: logic.addGroup,
          onCreateGroup: logic.createGroup,
          onClickSearch: logic.searchContacts,
          onSwitchTab: conversationLogic.switchTab,
          tabIndex: conversationLogic.tabIndex,
          unhandledCount: homeLogic.unhandledFriendAndGroupCount,
          mq: mq),
      backgroundColor: StylesLibrary.c_F7F8FA,
      body: Obx(
        () => Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 65.h),
              child: AzList<ISUserInfo>(
                data: logic.friendList,
                itemCount: logic.friendList.length,
                itemBuilder: (_, data, index) => _friendItem(data),
              ),
            ),
            Container(
              constraints: BoxConstraints(minWidth: 1.sw),
              color: StylesLibrary.c_FFFFFF,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(
                      left: 12.w, right: 12.w, top: 9.h, bottom: 20.h),
                  child: Row(
                    children: List.generate(
                        logic.menus.length,
                        (index) => Row(
                              children: [
                                _menuItem(
                                    text: logic.menus[index]["text"],
                                    color: logic.menus[index]["color"],
                                    shadowColor: logic.menus[index]
                                        ["shadowColor"],
                                    onTap: logic.menus[index]["onTap"],
                                    badge:
                                        logic.menus[index]["key"] == "newRecent"
                                            ? homeLogic
                                                .unhandledFriendAndGroupCount
                                                .value
                                            : null),
                                8.horizontalSpace
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
                    image: AssetImage(ImageLibrary.appHeaderBg3,
                        package: 'miti_common'),
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.bottomCenter,
                  )),
                )),
          ],
        ),
      ),
    );
  }

  Widget _menuItem({
    double? width,
    double? height,
    Color? color,
    TextStyle? tStyle,
    Color? shadowColor,
    int? badge,
    required String text,
    Function()? onTap,
  }) {
    width = width ?? 108.w;
    height = height ?? 50.h;
    color = color ?? StylesLibrary.c_8544F8;
    tStyle = tStyle ?? StylesLibrary.ts_FFFFFF_14sp_medium;
    shadowColor = shadowColor ?? Color.fromRGBO(132, 67, 248, 0.5);
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Stack(
          children: [
            Container(
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
                constraints: BoxConstraints(minWidth: width),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Center(
                  child: text.toText..style = tStyle,
                )),
            if (null != badge)
              Positioned(
                  top: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: const Offset(0, 0),
                    child: UnreadCountView(count: badge),
                  ))
          ],
        ));
  }

  Widget _friendItem(ISUserInfo info) {
    Widget buildChild() => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => logic.viewFriendInfo(info),
          child: Container(
            height: 54.h,
            color: StylesLibrary.c_FFFFFF,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  AvatarView(
                    url: info.faceURL,
                    text: info.showName,
                  ),
                  12.horizontalSpace,
                  info.showName.toText..style = StylesLibrary.ts_333333_16sp,
                ],
              ),
            ),
          ),
        );
    return buildChild();
  }
}
