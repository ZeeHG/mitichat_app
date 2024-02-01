import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'xhs_logic.dart';

class XhsPage extends StatelessWidget {
  final logic = Get.find<XhsLogic>();

  XhsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final mqTop = mq.padding.top;
    return Obx(() => Scaffold(
          backgroundColor: Styles.c_F8F9FA,
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Styles.c_F7F8FA,
                ),
                child: Column(
                  children: [
                    mqTop.verticalSpace,
                    Center(
                      child: CustomTabBar(
                          width: 100.w,
                          labels: [StrRes.discoverTab, StrRes.follow],
                          index: logic.headerIndex.value,
                          onTabChanged: (i) => logic.switchHeaderIndex(i),
                          showUnderline: false,
                          bgColor: Styles.transparent,
                          inactiveTextStyle: Styles.ts_4B3230_18sp,
                          activeTextStyle: Styles.ts_4B3230_20sp_medium,
                          indicatorWidth: 20.w),
                    ),
                    12.verticalSpace,
                    FakeSearchBox(
                        onTap: logic.search,
                        color: Styles.c_FFFFFF,
                        borderRadius: 18.r),
                    12.verticalSpace,
                    Container(
                      width: 375.w,
                      height: 50.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: logic.categoryList.length,
                                  itemBuilder: (_, i) => Container(
                                        child: Text(logic.categoryList[i]),
                                      ))),
                          ImageRes.appAiMarker.toImage
                            ..width = 12.w
                            ..height = 7.h
                        ],
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                      children: [],
                    ))),
                  ],
                ),
              ),
              IgnorePointer(
                  ignoring: true,
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(ImageRes.appHeaderBg3,
                          package: 'openim_common'),
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.topCenter,
                    )),
                  )),
            ],
          ),
        ));
  }
}
