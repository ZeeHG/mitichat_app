import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'point_records_logic.dart';

class PointRecordsPage extends StatelessWidget {
  final logic = Get.find<PointRecordsLogic>();

  PointRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.allRecords),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.w),
            child: ListView.builder(
                itemCount: logic.pointRecords.length,
                itemBuilder: (_, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1.w, color: Styles.c_F1F2F6))),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StrLibrary.inviteFriends.toText
                              ..style = Styles.ts_333333_16sp_medium,
                            5.verticalSpace,
                            "2024-01-01".toText..style = Styles.ts_999999_12sp,
                          ],
                        ),
                        Spacer(),
                        "+5".toText..style = Styles.ts_8443F8_18sp_medium,
                      ],
                    ),
                  );
                }),
          )),
    );
  }
}
