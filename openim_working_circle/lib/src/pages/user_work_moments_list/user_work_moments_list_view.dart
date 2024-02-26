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
      backgroundColor: Styles.c_FFFFFF,
      body: Obx(() => CustomScrollView(
            // physics: const BouncingScrollPhysics(),
            controller: logic.scrollController,
            slivers: [
              _sliverAppBar(context),
              SliverToBoxAdapter(child: 10.verticalSpace),
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
                        color: Styles.c_8443F8,
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
                      StrRes.noDynamic.toText..style = Styles.ts_999999_16sp,
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
      padding: EdgeInsets.only(right: 18.w),
      margin: EdgeInsets.only(
        bottom: logic.addMargin(index) ? 30.h : 20.h,
      ),
      child: Column(
        children: [
          if (null != logic.yearTimelines[moments])
            Padding(
              padding: EdgeInsets.only(bottom: 20.h, left: 18.w),
              child: Row(
                children: [
                  // Expanded(
                  //   child: Container(
                  //     color: Styles.c_E8EAEF,
                  //     height: 1,
                  //     margin: EdgeInsets.symmetric(horizontal: 18.w),
                  //   ),
                  // ),
                  (logic.yearTimelines[moments] ?? '').toText
                    ..style = Styles.ts_333333_22sp_medium,
                  // Expanded(
                  //   child: Container(
                  //     color: Styles.c_E8EAEF,
                  //     height: 1,
                  //     margin: EdgeInsets.symmetric(horizontal: 18.w),
                  //   ),
                  // ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 87.w,
                padding: EdgeInsets.only(left: 18.w),
                child: RichText(
                  text: textSpan ?? const TextSpan(),
                ),
              ),
              // Container(
              //   width: 60.w,
              //   padding: EdgeInsets.only(left: 10.w),
              //   child: null != timeline
              //       ? (timeline.toText..style = Styles.ts_333333_17sp_medium)
              //       : null,
              // ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (urls.isNotEmpty)
                          MetasImageView(
                              urls: urls,
                              width: 60.w,
                              height: 60.h,
                              radius: 4.r),
                        if (urls.isNotEmpty && isVideo)
                          ImageRes.videoPause.toImage
                            ..width = 20.w
                            ..height = 20.h,
                      ],
                    ),
                    Expanded(
                      child: urls.isEmpty
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: Styles.c_F7F7F7,
                              ),
                              child: (moments.content?.text ?? '').toText
                                ..style = Styles.ts_333333_16sp
                                ..maxLines = 2
                                ..overflow = TextOverflow.ellipsis,
                            )
                          : Container(
                              height: 60.h,
                              padding: EdgeInsets.only(left: 12.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ((moments.content?.text ?? '').toText
                                    ..style = Styles.ts_333333_16sp
                                    ..maxLines = 2
                                    ..overflow = TextOverflow.ellipsis),
                                  if (!isVideo)
                                    sprintf(StrRes.totalNPicture, [urls.length])
                                        .toText
                                      ..style = Styles.ts_999999_12sp,
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

  Widget _sliverAppBar(BuildContext context) => SliverAppBar(
        title: (logic.scrollHeight <=
                (180.h - 58.h - MediaQuery.of(context).padding.top))
            ? Container(
                padding: EdgeInsets.only(bottom: 20.h),
                child: StrRes.workingCircle.toText
                  ..style = Styles.ts_333333_18sp_medium,
              )
            : Container(
                padding: EdgeInsets.only(bottom: 20.h),
                child: AvatarView(
                  width: 36.w,
                  height: 36.h,
                  url: logic.faceURL,
                  text: logic.nickname,
                  // onTap: logic.viewMyProfilePanel,
                )),
        centerTitle: true,
        expandedHeight: 180.h,
        toolbarHeight: 66.h,
        backgroundColor: Styles.c_FFFFFF,
        floating: false,
        pinned: true,
        snap: false,
        stretch: true,
        leadingWidth: 48.w,
        leading: Container(
          padding: EdgeInsets.only(left: 10.w, bottom: 20.h),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.back(),
            child: Container(
              width: 38.w,
              height: 38.h,
              child: Center(
                child: ImageRes.appBackWhite.toImage
                  ..width = 24.w
                  ..height = 24.h
                  ..color = Styles.c_333333,
              ),
            ),
          ),
        ),
        // stretchTriggerOffset: 100,
        // leading: ImageRes.backBlack.toImage..color = Styles.c_FFFFFF,
        actions: logic.isMyself &&
                !(logic.scrollHeight <=
                    (180.h - 58.h - MediaQuery.of(context).padding.top))
            ? [
                // _popButton2,
                Container(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: logic.publish,
                      child: Container(
                        // padding: EdgeInsets.only(bottom: 20.h),
                        child: Container(
                          width: 38.w,
                          height: 38.h,
                          decoration: BoxDecoration(
                            color: Styles.c_FFFFFF_opacity70,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Center(
                            child: ImageRes.appAdd.toImage
                              ..width = 16.w
                              ..height = 16.h
                              ..color = Styles.c_333333,
                          ),
                        ),
                      ),
                    )),
                10.horizontalSpace,
                Container(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: logic.seeNewMessage,
                    child: Container(
                      width: 38.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: Styles.c_FFFFFF_opacity70,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Center(
                        child: ImageRes.appNotification.toImage
                          ..width = 16.w
                          ..height = 16.h
                          ..color = Styles.c_333333,
                      ),
                    ),
                  ),
                ),
                18.horizontalSpace,
              ]
            : [],
        flexibleSpace: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 300.h,
              color: Styles.c_FFFFFF,
              child: ImageRes.workingCircleHeaderBg3.toImage
                ..width = 375.w
                ..height = 180.h
                ..fit = BoxFit.cover,
            ),
            if (logic.scrollHeight <=
                (180.h - 58.h - MediaQuery.of(context).padding.top))
              Positioned(
                bottom: 38.h,
                left: 18.w,
                child: Container(
                  width: 1.sw - 36.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AvatarView(
                        width: 50.w,
                        height: 50.h,
                        url: logic.faceURL,
                        text: logic.nickname,
                        // onTap: logic.viewMyProfilePanel,
                      ),
                      12.horizontalSpace,
                      Expanded(
                          child: (logic.nickname ?? '').toText
                            ..style = Styles.ts_333333_18sp_medium
                            ..maxLines = 1
                            ..overflow = TextOverflow.ellipsis),
                      12.horizontalSpace,
                      if (logic.isMyself) ...[
                        // Spacer(),
                        // GestureDetector(
                        //   behavior: HitTestBehavior.translucent,
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 0),
                        //     height: 38.h,
                        //     decoration: BoxDecoration(
                        //       color: Styles.c_FFFFFF_opacity70,
                        //       borderRadius: BorderRadius.circular(6.r),
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         ImageRes.appAdd.toImage..width=16.w..height=16.h,
                        //         6.horizontalSpace,
                        //         StrRes.publishMoment.toText..style=Styles.ts_333333_14sp_medium
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // _popButton,
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: logic.publish,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 11.w, vertical: 0),
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: Styles.c_FFFFFF_opacity70,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              children: [
                                ImageRes.appAdd.toImage
                                  ..width = 16.w
                                  ..height = 16.h,
                                6.horizontalSpace,
                                StrRes.publishMoment.toText
                                  ..style = Styles.ts_333333_14sp_medium
                              ],
                            ),
                          ),
                        ),
                        5.horizontalSpace,
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: logic.seeNewMessage,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 11.w, vertical: 0),
                              height: 38.h,
                              decoration: BoxDecoration(
                                color: Styles.c_FFFFFF_opacity70,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Center(
                                child: ImageRes.appNotification.toImage
                                  ..width = 16.w
                                  ..height = 16.h,
                              )),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            // if (logic.scrollHeight <= (180.h - 58.h - MediaQuery.of(context).padding.top))
            Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 1.sw,
                  height: 16.h,
                  decoration: BoxDecoration(
                      color: Styles.c_FFFFFF,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      )),
                ))
          ],
        ),
      );

  // Widget get _popButton => PopupMenuButton<int>(
  //       offset: Offset(0, 48.h),
  //       padding: EdgeInsets.zero,
  //       icon: Container(
  //                         padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 0),
  //                         height: 38.h,
  //                         decoration: BoxDecoration(
  //                           color: Styles.c_FFFFFF_opacity70,
  //                           borderRadius: BorderRadius.circular(6.r),
  //                         ),
  //                         child: Row(
  //                           children: [
  //                             ImageRes.appAdd.toImage..width=16.w..height=16.h,
  //                             6.horizontalSpace,
  //                             StrRes.publishMoment.toText..style=Styles.ts_333333_14sp_medium
  //                           ],
  //                         ),
  //                       ),
  //       itemBuilder: (_) => <PopupMenuEntry<int>>[
  //         PopupMenuItem(
  //           padding: EdgeInsets.only(left: 12.w),
  //           height: 45.h,
  //           value: 0,
  //           child: Row(
  //             children: [
  //               ImageRes.appPublishPic.toImage
  //                 ..width = 20.w
  //                 ..height = 20.h,
  //               12.horizontalSpace,
  //               StrRes.publishPicture.toText..style = Styles.ts_333333_16sp,
  //             ],
  //           ),
  //         ),
  //         const PopupMenuDivider(),
  //         PopupMenuItem(
  //           padding: EdgeInsets.only(left: 12.w),
  //           height: 45.h,
  //           value: 1,
  //           child: Row(
  //             children: [
  //               ImageRes.appPublishVideo.toImage
  //                 ..width = 20.w
  //                 ..height = 20.h,
  //               12.horizontalSpace,
  //               StrRes.publishVideo.toText..style = Styles.ts_333333_16sp,
  //             ],
  //           ),
  //         ),
  //       ],
  //       onSelected: logic.publish,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(6.w))),
  //     );
}
