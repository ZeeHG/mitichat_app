import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'call_records_logic.dart';

class CallRecordsPage extends StatelessWidget {
  final logic = Get.find<CallRecordsLogic>();

  CallRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.callRecords),
      backgroundColor: Styles.c_FFFFFF,
      body: Obx(() => Column(
            children: [
              CustomTabBar(
                labels: [StrLibrary.allCall, StrLibrary.missedCall],
                index: logic.index.value,
                onTabChanged: (i) => logic.switchTab(i),
                showUnderline: true,
              ),
              Expanded(
                child: IndexedStack(
                  index: logic.index.value,
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.only(top: 10.h),
                      itemCount: logic.cacheLogic.callRecordList.length,
                      cacheExtent: 56.h,
                      itemBuilder: (_, index) => _buildItemView(
                          logic.cacheLogic.callRecordList.elementAt(index)),
                    ),
                    ListView.builder(
                      padding: EdgeInsets.only(top: 10.h),
                      itemCount: logic.cacheLogic.callRecordList
                          .where((e) => !e.success)
                          .length,
                      cacheExtent: 56.h,
                      itemBuilder: (_, index) => _buildItemView(logic
                          .cacheLogic.callRecordList
                          .where((e) => !e.success)
                          .elementAt(index)),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _buildItemView(CallRecords records) => Dismissible(
        key: Key('${records.userID}_${records.date}'),
        confirmDismiss: (direction) async {
          return logic.remove(records);
        },
        child: GestureDetector(
          onTap: () => logic.call(records),
          behavior: HitTestBehavior.translucent,
          child: Container(
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                AvatarView(
                  url: records.faceURL,
                  text: records.nickname,
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      records.nickname.toText
                        ..style = (records.success
                            ? Styles.ts_333333_17sp
                            : Styles.ts_FF4E4C_17sp),
                      '[${records.type == 'video' ? StrLibrary.callVideo : StrLibrary.callVoice}]${IMUtils.getChatTimeline(records.date)}'
                          .toText
                        ..style = (records.success
                            ? Styles.ts_333333_14sp
                            : Styles.ts_FF4E4C_14sp),
                    ],
                  ),
                ),
                (records.success
                        ? IMUtils.seconds2HMS(records.duration)
                        : (records.incomingCall
                            ? StrLibrary.incomingCall
                            : StrLibrary.outgoingCall))
                    .toText
                  ..style = (records.success
                      ? Styles.ts_333333_14sp
                      : Styles.ts_FF4E4C_14sp),
              ],
            ),
          ),
        ),
      );
}
