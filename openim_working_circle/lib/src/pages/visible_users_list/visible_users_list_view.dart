import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'visible_users_list_logic.dart';

class VisibleUsersListPage extends StatelessWidget {
  final logic = Get.find<VisibleUsersListLogic>();

  VisibleUsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: logic.title),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => ListView.builder(
            padding: EdgeInsets.only(top: 10.h),
            itemCount: logic.listUserInfo.length,
            itemBuilder: (_, index) {
              final user = logic.listUserInfo.elementAt(index);
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: logic.viewUserInfo,
                child: Container(
                  height: 64.h,
                  color: Styles.c_FFFFFF,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      AvatarView(
                        text: user.nickname,
                        url: user.faceURL,
                      ),
                      10.horizontalSpace,
                      (user.nickname ?? '').toText
                        ..style = Styles.ts_0C1C33_17sp,
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
