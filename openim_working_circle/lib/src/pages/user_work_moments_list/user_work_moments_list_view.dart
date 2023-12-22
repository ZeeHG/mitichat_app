import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import '../../widgets/metas_image_view.dart';
import 'user_work_moments_list_logic.dart';

class UserWorkMomentsListPage extends StatelessWidget {
  final logic = Get.find<UserWorkMomentsListLogic>(tag: GetTags.userMoments);

  UserWorkMomentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: TitleBar.back(),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => CustomScrollView(
            // physics: const BouncingScrollPhysics(),
            controller: logic.scrollController,
            slivers: [
              _sliverAppBar,
              SliverToBoxAdapter(child: 26.verticalSpace),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => logic.viewDetail(logic.workMoments[index]),
                    child: _buildItemView(index),
                  ),
                  childCount: logic.workMoments.length,
                ),
              ),
              if (logic.hasMore.value)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 55.h,
                    child: Center(
                      child: CupertinoActivityIndicator(
                        color: Styles.c_0089FF,
                      ),
                    ),
                  ),
                ),
              if (logic.workMoments.isEmpty && !logic.hasMore.value)
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      100.verticalSpace,
                      ImageRes.workingCircleEmpty.toImage
                        ..width = 84.3.w
                        ..height = 81.35.h
                        ..fit = BoxFit.cover,
                      22.verticalSpace,
                      StrRes.noDynamic.toText..style = Styles.ts_8E9AB0_16sp,
                    ],
                  ),
                ),
            ],
          )),
    );
  }

  Widget _buildItemView(int index) {
    WorkMoments moments = logic.workMoments.elementAt(index);
    final urls = moments.content?.metas?.map((e) => e.thumb!).toList() ?? [];
    final isVideo = moments.content?.type == 1;
    final timeline = logic.getTimelines(moments);
    TextSpan? textSpan;
    if (null != timeline) {
      textSpan = IMViews.getTimelineTextSpan(moments.createTime ?? 0);
    }
    return Container(
      padding: EdgeInsets.only(right: 10.w),
      margin: EdgeInsets.only(
        bottom: logic.addMargin(index) ? 30.h : 5.h,
      ),
      child: Column(
        children: [
          if (null != logic.yearTimelines[moments])
            Padding(
              padding: EdgeInsets.only(bottom: 22.h),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Styles.c_E8EAEF,
                      height: 1,
                      margin: EdgeInsets.only(left: 10.w, right: 12.w),
                    ),
                  ),
                  (logic.yearTimelines[moments] ?? '').toText
                    ..style = Styles.ts_8E9AB0_12sp,
                  Expanded(
                    child: Container(
                      color: Styles.c_E8EAEF,
                      height: 1,
                      margin: EdgeInsets.only(left: 12.w, right: 10.w),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60.w,
                padding: EdgeInsets.only(left: 10.w),
                child: RichText(
                  text: textSpan ?? const TextSpan(),
                ),
              ),
              // Container(
              //   width: 60.w,
              //   padding: EdgeInsets.only(left: 10.w),
              //   child: null != timeline
              //       ? (timeline.toText..style = Styles.ts_0C1C33_17sp_medium)
              //       : null,
              // ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (urls.isNotEmpty) MetasImageView(urls: urls),
                        if (urls.isNotEmpty && isVideo)
                          ImageRes.videoPause.toImage
                            ..width = 40.w
                            ..height = 40.h,
                      ],
                    ),
                    Expanded(
                      child: urls.isEmpty
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 9.h,
                              ),
                              decoration: BoxDecoration(
                                color: Styles.c_E8EAEF,
                              ),
                              child: (moments.content?.text ?? '').toText
                                ..maxLines = 2
                                ..overflow = TextOverflow.ellipsis,
                            )
                          : Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ((moments.content?.text ?? '').toText
                                    ..maxLines = 3
                                    ..overflow = TextOverflow.ellipsis),
                                  if (!isVideo)
                                    sprintf(StrRes.totalNPicture, [urls.length])
                                        .toText
                                      ..style = Styles.ts_8E9AB0_12sp,
                                ],
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget get _sliverAppBar => SliverAppBar(
        title: StrRes.workingCircle.toText
          ..style = Styles.ts_FFFFFF_20sp_medium,
        centerTitle: true,
        expandedHeight: 178.h,
        // collapsedHeight: 100,
        backgroundColor: const Color(0xFF041d31),
        floating: false,
        pinned: true,
        snap: false,
        stretch: true,
        // stretchTriggerOffset: 100,
        // leading: ImageRes.backBlack.toImage..color = Styles.c_FFFFFF,
        actions: [],
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ImageRes.workingCircleHeaderBg.toImage
                ..width = 375.w
                ..height = 222.h
                ..fit = BoxFit.cover,
              Positioned(
                bottom: 24.h,
                left: 16.w,
                child: Row(
                  children: [
                    AvatarView(
                      width: 48.w,
                      height: 48.h,
                      url: logic.faceURL,
                      text: logic.nickname,
                    ),
                    12.horizontalSpace,
                    (logic.nickname ?? '').toText
                      ..style = Styles.ts_FFFFFF_18sp_medium,
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
