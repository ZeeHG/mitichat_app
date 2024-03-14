import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../discover_list/discover_list_view.dart';
import '../follow_list/follow_list_view.dart';
import 'package:miti_common/miti_common.dart';

import 'new_discover_logic.dart';

class NewDiscoverPage extends StatelessWidget {
  final logic = Get.find<NewDiscoverLogic>();

  NewDiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Obx(() => Scaffold(
          appBar: TitleBar.newDiscover(
            popCtrl: logic.popCtrl,
            mq: mq,
            onScan: logic.scan,
            onTapLeft: null,
            showBottom: logic.showBottom,
            center: Expanded(
              child: Center(
                child: CustomTabBar(
                  width: 102.w,
                  labels: [StrLibrary.follow, StrLibrary.discover],
                  index: logic.index.value,
                  onTabChanged: (i) => logic.switchTab(i),
                  showUnderline: false,
                  bgColor: Styles.transparent,
                  inactiveTextStyle: Styles.ts_999999_18sp,
                  activeTextStyle: Styles.ts_333333_18sp_medium,
                ),
              ),
            ),
          ),
          backgroundColor: Styles.c_F7F8FA,
          body: IndexedStack(
            index: logic.index.value,
            children: [
              FollowListPage(),
              DiscoverListPage(),
            ],
          ),
        ));
  }
}
