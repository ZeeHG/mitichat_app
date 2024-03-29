import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/pages/xhs/xhs_logic.dart';
import 'package:miti/pages/xhs/xhs_view.dart';
import 'package:miti_common/miti_common.dart';
// import '../contacts/contacts_view.dart';
import '../conversation/conversation_view.dart';
import '../mine/mine_view.dart';
import 'home_logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();
  final xhsLogic = Get.find<XhsLogic>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            systemNavigationBarColor:
                logic.index.value == 1 ? Styles.c_F7F8FA : Styles.c_FFFFFF),
        child: Scaffold(
            backgroundColor:
                logic.index.value == 1 ? Styles.c_F7F8FA : Styles.c_FFFFFF,
            body: IndexedStack(
              index: logic.index.value,
              children: [
                ConversationPage(),
                // ContactsPage(
                //     switchHomeTab: logic.switchTab, tabIndex: logic.index),
                XhsPage(),
                MinePage(),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: BottomBar(
                activeIndex: logic.index.value,
                items: [
                  BottomBarItem(
                    itemIndex: 0,
                    selectedImgRes: ImageRes.appHomeTab1Sel,
                    unselectedImgRes: ImageRes.appHomeTab1Nor,
                    label: StrLibrary.chat,
                    imgWidth: 31.w,
                    imgHeight: 22.h,
                    onClick: (int index) => logic.switchTab(0),
                    onDoubleClick: logic.scrollToUnreadConversation,
                    count: logic.unreadMsgCount.value,
                  ),
                  BottomBarItem(
                    itemIndex: 1,
                    selectedImgRes: ImageRes.appHomeTab2Sel,
                    unselectedImgRes: ImageRes.appHomeTab2Nor,
                    label: StrLibrary.discoverTab,
                    imgWidth: 22.w,
                    imgHeight: 22.h,
                    onClick: (int index) {
                      logic.switchTab(1);
                      xhsLogic.refreshWorkingCircleList();
                    },
                  ),
                  BottomBarItem(
                    itemIndex: -1,
                    selectedImgRes: ImageRes.appHomeTab3Nor3,
                    unselectedImgRes: ImageRes.appHomeTab3Nor3,
                    label: StrLibrary.workingCircle,
                    imgWidth: 24.w,
                    imgHeight: 24.h,
                    onClick: logic.viewDiscover,
                    count: logic.unreadMomentsCount.value,
                  ),
                  BottomBarItem(
                    itemIndex: 2,
                    selectedImgRes: ImageRes.appHomeTab4Sel3,
                    unselectedImgRes: ImageRes.appHomeTab4Nor3,
                    label: StrLibrary.mine,
                    imgWidth: 22.w,
                    imgHeight: 22.h,
                    onClick: (int index) => logic.switchTab(2),
                  ),
                ],
              ),
            ))));
  }
}
