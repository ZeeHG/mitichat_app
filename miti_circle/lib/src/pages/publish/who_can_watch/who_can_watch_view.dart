import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

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
        title: StrLibrary.whoCanWatch,
        right: Button(
          text: StrLibrary.determine,
          textStyle: StylesLibrary.ts_FFFFFF_14sp,
          height: 28.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          onTap: logic.determine,
        ),
      ),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                10.verticalSpace,
                _buildItemView(
                  title: StrLibrary.public,
                  hint: StrLibrary.everyoneCanSee,
                  showRightArrow: false,
                  index: 0,
                ),
                _buildItemView(
                  title: StrLibrary.private,
                  hint: StrLibrary.onlyVisibleToMe,
                  showRightArrow: false,
                  index: 1,
                ),
                _buildItemView(
                  title: StrLibrary.partiallyVisible,
                  hint: StrLibrary.visibleToTheSelected,
                  value: logic.checkedVisibleList
                      .map((e) => publishLogic.parseName(e))
                      .join('、'),
                  index: 2,
                ),
                _buildItemView(
                  title: StrLibrary.partiallyInvisible,
                  hint: StrLibrary.invisibleToTheSelected,
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
            color: StylesLibrary.c_FFFFFF,
            border: underline
                ? BorderDirectional(
                    bottom:
                        BorderSide(color: StylesLibrary.c_E8EAEF, width: .5),
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
                    ? (ImageLibrary.checked.toImage
                      ..width = 24.w
                      ..height = 24.h)
                    : null,
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title.toText..style = StylesLibrary.ts_333333_17sp,
                    4.verticalSpace,
                    hint.toText..style = StylesLibrary.ts_999999_14sp,
                    if (null != value && value.isNotEmpty) 8.verticalSpace,
                    if (null != value && value.isNotEmpty)
                      value.toText
                        ..style = StylesLibrary.ts_8443F8_14sp
                        ..maxLines = 2
                        ..overflow = TextOverflow.ellipsis,
                  ],
                ),
              ),
              if (showRightArrow)
                ImageLibrary.appRightArrow.toImage
                  ..width = 24.w
                  ..height = 24.h
            ],
          ),
        ),
      );
}
