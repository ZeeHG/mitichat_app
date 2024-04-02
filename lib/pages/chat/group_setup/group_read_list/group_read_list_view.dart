import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sprintf/sprintf.dart';

import 'group_read_list_logic.dart';

class GroupReadListPage extends StatelessWidget {
  final logic = Get.find<GroupReadListLogic>();

  GroupReadListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.messageRecipientList),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => Column(
            children: [
              CustomTabBar(
                width: 1.sw,
                labels: [
                  sprintf(StrLibrary.unreadCount, [logic.unreadCount]),
                  sprintf(StrLibrary.hasReadCount, [logic.hasReadCount]),
                ],
                index: logic.index.value,
                onTabChanged: (i) => logic.switchTab(i),
                showUnderline: true,
              ),
              Expanded(
                child: IndexedStack(
                  index: logic.index.value,
                  children: [
                    SmartRefresher(
                      controller: logic.unreadRefreshController,
                      enablePullDown: false,
                      enablePullUp: true,
                      footer: IMViews.buildFooter(),
                      child: ListView.builder(
                        itemCount: logic.unreadMemberList.length,
                        itemBuilder: (_, index) => _itemView(
                          logic.unreadMemberList.elementAt(index),
                        ),
                      ),
                    ),
                    SmartRefresher(
                      controller: logic.hasReadRefreshController,
                      enablePullDown: false,
                      enablePullUp: true,
                      footer: IMViews.buildFooter(),
                      child: ListView.builder(
                        itemCount: logic.hasReadMemberList.length,
                        itemBuilder: (_, index) => _itemView(
                          logic.hasReadMemberList[index],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _itemView(GroupMembersInfo info, {String? status}) => Container(
        height: 64.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        color: Styles.c_FFFFFF,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AvatarView(
              width: 44.w,
              height: 44.h,
              url: info.faceURL,
              text: info.nickname,
            ),
            10.horizontalSpace,
            Expanded(
              child: (info.nickname ?? '').toText
                ..style = Styles.ts_333333_16sp
                ..maxLines = 1
                ..overflow = TextOverflow.ellipsis,
            ),
          ],
        ),
      );
}
