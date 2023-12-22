import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'tag_group_logic.dart';

class TagGroupPage extends StatelessWidget {
  final logic = Get.find<TagGroupLogic>();

  TagGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.tagGroup,
        right: StrRes.add.toText
          ..style = Styles.ts_0C1C33_17sp
          ..onTap = logic.createTagGroup,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => SlidableAutoCloseBehavior(
            child: SmartRefresher(
              controller: logic.refreshCtrl,
              enablePullDown: true,
              enablePullUp: false,
              header: IMViews.buildHeader(),
              onRefresh: logic.queryTagGroup,
              child: logic.tagGroups.isEmpty
                  ? ListView(children: [_emptyListView])
                  : ListView.builder(
                      itemCount: logic.tagGroups.length,
                      padding: EdgeInsets.only(top: 10.h),
                      itemBuilder: (_, index) =>
                          _buildTagItemView(logic.tagGroups.elementAt(index)),
                    ),
            ),
          )),
    );
  }

  Widget _buildTagItemView(TagInfo tagInfo) => Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: .4,
          children: [
            CustomSlidableAction(
              onPressed: (_) => logic.edit(tagInfo),
              flex: 1,
              backgroundColor: Styles.c_0089FF,
              child: StrRes.edit.toText..style = Styles.ts_FFFFFF_16sp,
            ),
            CustomSlidableAction(
              onPressed: (_) => logic.delete(tagInfo),
              flex: 1,
              backgroundColor: Styles.c_FF381F,
              child: StrRes.delete.toText..style = Styles.ts_FFFFFF_16sp,
            ),
          ],
        ),
        child: _buildItemView(tagInfo),
      );

  Widget _buildItemView(TagInfo tagInfo) => Container(
        height: 68.h,
        width: 1.sw,
        color: Styles.c_FFFFFF,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tagInfo.tagName!.toText..style = Styles.ts_0C1C33_17sp,
            6.verticalSpace,
            tagInfo.users!.map((e) => e.nickname!).join('、').toText
              ..style = Styles.ts_8E9AB0_14sp,
          ],
        ),
      );

  Widget get _emptyListView => SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            157.verticalSpace,
            ImageRes.blacklistEmpty.toImage
              ..width = 120.w
              ..height = 120.h,
            22.verticalSpace,
            StrRes.emptyTagGroup.toText..style = Styles.ts_8E9AB0_16sp,
          ],
        ),
      );
}
