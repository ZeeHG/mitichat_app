import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../publish_logic.dart';
import 'who_can_watch_logic.dart';

class WhoCanWatchPage extends StatelessWidget {
  final logic = Get.find<WhoCanWatchLogic>();
  final publishLogic = Get.find<PublishLogic>();

  WhoCanWatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.whoCanWatch,
        right: Button(
          text: StrRes.determine,
          textStyle: Styles.ts_FFFFFF_14sp,
          height: 28.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          onTap: logic.determine,
        ),
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                10.verticalSpace,
                _buildItemView(
                  title: StrRes.public,
                  hint: StrRes.everyoneCanSee,
                  showRightArrow: false,
                  index: 0,
                ),
                _buildItemView(
                  title: StrRes.private,
                  hint: StrRes.onlyVisibleToMe,
                  showRightArrow: false,
                  index: 1,
                ),
                _buildItemView(
                  title: StrRes.partiallyVisible,
                  hint: StrRes.visibleToTheSelected,
                  value: logic.checkedVisibleList
                      .map((e) => publishLogic.parseName(e))
                      .join('、'),
                  index: 2,
                ),
                _buildItemView(
                  title: StrRes.partiallyInvisible,
                  hint: StrRes.invisibleToTheSelected,
                  value: logic.checkedInvisibleList
                      .map((e) => publishLogic.parseName(e))
                      .join('、'),
                  underline: false,
                  index: 3,
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildItemView({
    required String title,
    required String hint,
    int index = 0,
    String? value,
    bool underline = true,
    bool showRightArrow = true,
  }) =>
      GestureDetector(
        onTap: () => logic.selectPermission(index),
        child: Container(
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            border: underline
                ? BorderDirectional(
                    bottom: BorderSide(color: Styles.c_E8EAEF, width: .5),
                  )
                : null,
          ),
          padding: EdgeInsets.only(
            left: 16.w,
            right: 12.w,
            top: 11.h,
            bottom: 11.h,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 24.w,
                child: logic.permission.value == index
                    ? (ImageRes.checked.toImage
                      ..width = 24.w
                      ..height = 24.h)
                    : null,
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title.toText..style = Styles.ts_0C1C33_17sp,
                    4.verticalSpace,
                    hint.toText..style = Styles.ts_8E9AB0_14sp,
                    if (null != value && value.isNotEmpty) 8.verticalSpace,
                    if (null != value && value.isNotEmpty)
                      value.toText
                        ..style = Styles.ts_0089FF_14sp
                        ..maxLines = 2
                        ..overflow = TextOverflow.ellipsis,
                  ],
                ),
              ),
              if (showRightArrow)
                ImageRes.rightArrow.toImage
                  ..width = 24.w
                  ..height = 24.h
            ],
          ),
        ),
      );
}
