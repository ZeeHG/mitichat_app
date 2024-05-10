import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'invite_friends_history_logic.dart';

class InviteFriendsHistoryPage extends StatelessWidget {
  final logic = Get.find<InviteFriendsHistoryLogic>();

  InviteFriendsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: ""),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: Obx(() => SingleChildScrollView(
            child: logic.users.isEmpty? Container() : Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(color: StylesLibrary.c_FFFFFF),
              child: Column(
                  children: List.generate(logic.users.length,
                      (index) => _buildItemView(user: logic.users[index]))),
            ),
          )),
    );
  }

  Widget _buildItemView({required UserFullInfo user}) => Container(
        
        child: Row(
          children: [
            AvatarView(
              url: user.faceURL,
              text: user.showName,
            ),
            10.horizontalSpace,
            Expanded(
              child: user.showName.toText
                ..maxLines = 1
                ..overflow = TextOverflow.ellipsis,
            ),
          ],
        ),
      );
}
