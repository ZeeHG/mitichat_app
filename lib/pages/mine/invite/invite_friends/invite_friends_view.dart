import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'invite_friends_logic.dart';

class InviteFriendsPage extends StatelessWidget {
  final logic = Get.find<InviteFriendsLogic>();

  InviteFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: ""),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: SingleChildScrollView(
        child: Obx(() => Container(
              width: 1.sw,
              padding: EdgeInsets.all(12.w),
              child: Column(
                children: [
                  ImageLibrary.miti.toImage
                    ..height = 100.h
                    ..width = 100.w,
                  20.verticalSpace,
                  Button(
                    width: 150.w,
                    text: StrLibrary.inviteNow,
                    onTap: logic.inviteDetail,
                  ),
                  20.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: StylesLibrary.c_FFFFFF,
                      borderRadius: BorderRadius.circular(30.w),
                    ),
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: StrLibrary.myInviteRecords.toText
                            ..style = StylesLibrary.ts_333333_14sp,
                        ),
                        20.verticalSpace,
                        if (logic.myInviteRecords.isEmpty)
                          StrLibrary.empty.toText,
                        if (logic.myInviteRecords.isNotEmpty)
                          ...List.generate(
                              logic.myInviteRecords.length,
                              (index) => Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(child: logic.myInviteRecords[index]
                                                ["inviteUserID"]
                                            .toString()
                                            .toText..maxLines=1..overflow=TextOverflow.ellipsis,),
                                            10.horizontalSpace,
                                        _buildTimeView(
                                            logic.myInviteRecords[index]
                                                ["applyTime"])
                                      ],
                                    ),
                                  ))
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildTimeView(int time) => TimelineUtil.format(
        time*1000,
        dayFormat: DayFormat.Full,
        locale: Get.locale?.languageCode ?? 'zh',
      ).toText
        ..style = StylesLibrary.ts_999999_12sp;
}
