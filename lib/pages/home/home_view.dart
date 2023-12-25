import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../contacts/contacts_view.dart';
import '../conversation/conversation_view.dart';
import '../mine/mine_view.dart';
import '../new_discover/new_discover_view.dart';
import '../workbench/workbench_view.dart';
import 'home_logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(systemNavigationBarColor: Styles.c_F7F7F7),
        child: Scaffold(
            backgroundColor: Styles.c_F7F7F7,
            body: IndexedStack(
              index: logic.index.value,
              children: [
                ConversationPage(),
                ContactsPage(),
                WorkbenchPage(),
                MinePage(),
                NewDiscoverPage(),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: BottomBar(
                index: logic.index.value,
                items: [
                  // 新的发现, 删除对应监听
                  // BottomBarItem(
                  //   selectedImgRes: ImageRes.appHomeTab1Sel,
                  //   unselectedImgRes: ImageRes.appHomeTab1Nor,
                  //   label: StrRes.discover,
                  //   imgWidth: 21.w,
                  //   imgHeight: 21.h,
                  //   onClick: logic.switchTab,
                  // ),
                  // 旧的chat
                  BottomBarItem(
                    selectedImgRes: ImageRes.appHomeTab1Sel,
                    unselectedImgRes: ImageRes.appHomeTab1Nor,
                    label: StrRes.chat,
                    imgWidth: 31.w,
                    imgHeight: 22.h,
                    onClick: logic.switchTab,
                    onDoubleClick: logic.scrollToUnreadMessage,
                    count: logic.unreadMsgCount.value,
                  ),
                  BottomBarItem(
                    selectedImgRes: ImageRes.appHomeTab2Sel,
                    unselectedImgRes: ImageRes.appHomeTab2Nor,
                    label: StrRes.contacts,
                    imgWidth: 24.51.w,
                    imgHeight: 19.h,
                    onClick: logic.switchTab,
                    count: logic.unhandledCount.value,
                  ),
                  // 旧的发现
                  BottomBarItem(
                    selectedImgRes: ImageRes.appHomeTab3Nor2,
                    unselectedImgRes: ImageRes.appHomeTab3Nor2,
                    label: StrRes.discover,
                    imgWidth: 21.w,
                    imgHeight: 21.h,
                    onClick: logic.viewDiscover,
                    count: logic.unreadMomentsCount.value,
                  ),
                  // 新的chat
                  // BottomBarItem(
                  //   selectedImgRes: ImageRes.appHomeTab3Sel,
                  //   unselectedImgRes: ImageRes.appHomeTab3Nor,
                  //   label: StrRes.chat,
                  //   imgWidth: 31.w,
                  //   imgHeight: 22.h,
                  //   onClick: logic.switchTab,
                  //   onDoubleClick: logic.scrollToUnreadMessage,
                  //   count: logic.unreadMsgCount.value,
                  // ),
                  BottomBarItem(
                    selectedImgRes: ImageRes.appHomeTab4Sel2,
                    unselectedImgRes: ImageRes.appHomeTab4Nor2,
                    label: StrRes.mine,
                    imgWidth: 22.w,
                    imgHeight: 22.h,
                    onClick: logic.switchTab,
                  ),
                ],
              ),
            ))));
  }
}
