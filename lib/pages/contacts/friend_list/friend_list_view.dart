import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'friend_list_logic.dart';

class FriendListPage extends StatelessWidget {
  final logic = Get.find<FriendListLogic>();

  FriendListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.myFriend),
      backgroundColor: StylesLibrary.c_FFFFFF,
      body: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: logic.searchFriend,
            child: Container(
              color: StylesLibrary.c_FFFFFF,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: FakeSearchBox(),
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
        ],
      ),
    );
  }

  Widget _buildItemView(ISUserInfo info) => GestureDetector(
        onTap: () => logic.viewFriendInfo(info),
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 60.h,
          color: StylesLibrary.c_FFFFFF,
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
      );
}
