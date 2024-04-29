import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'invite_records_logic.dart';

class InviteRecordsPage extends StatelessWidget {
  final logic = Get.find<InviteRecordsLogic>();

  InviteRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.allRecords),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: Obx(() => Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.w),
            child: ListView.builder(
                itemCount: logic.inviteRecords.length,
                itemBuilder: (_, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1.w, color: StylesLibrary.c_F1F2F6))),
                    child: Row(
                      children: [
                        "AAAAAA".toText
                          ..style = StylesLibrary.ts_343434_18p_medium,
                        Spacer(),
                        AvatarView(
                          url: "",
                          text: "",
                          width: 26.w,
                          height: 26.h,
                        ),
                        10.horizontalSpace,
                        StrLibrary.used.toText
                          ..style = StylesLibrary.ts_999999_14sp,
                      ],
                    ),
                  );
                }),
          )),
    );
  }
}
