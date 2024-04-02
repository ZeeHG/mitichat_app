import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'xhs_logic.dart';

class XhsPage extends StatelessWidget {
  final logic = Get.find<XhsLogic>();

  XhsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final mqTop = mq.padding.top;
    return Obx(() => Scaffold(
          backgroundColor: StylesLibrary.c_F7F8FA,
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: StylesLibrary.c_F7F8FA,
                ),
                child: Column(
                  children: [
                    mqTop.verticalSpace,
                    Center(
                      child: CustomTabBar(
                          width: 100.w,
                          labels: [StrLibrary.discoverTab],
                          // labels: [StrLibrary .discoverTab, StrLibrary .follow],
                          index: logic.headerIndex.value,
                          // onTabChanged: (i) => logic.switchHeaderIndex(i),
                          showUnderline: false,
                          bgColor: StylesLibrary.transparent,
                          inactiveTextStyle: StylesLibrary.ts_4B3230_18sp,
                          activeTextStyle: StylesLibrary.ts_4B3230_20sp_medium,
                          indicatorWidth: 20.w),
                    ),
                    if (logic.headerIndex.value == 0) ...listPage,
                    // if (logic.headerIndex.value != 0) ...followPage,
                  ],
                ),
              ),
              IgnorePointer(
                  ignoring: true,
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(ImageLibrary.appHeaderBg3,
                          package: 'miti_common'),
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.topCenter,
                    )),
                  )),
            ],
          ),
        ));
  }

  List<Widget> get listPage {
    return [
      12.verticalSpace,
      // FakeSearchBox(
      //     onTap: logic.search, color: StylesLibrary.c_FFFFFF, borderRadius: 18.r),
      Container(
        width: 375.w,
        height: 46.w,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: logic.categoryList.length,
                      itemBuilder: (_, i) {
                        final category = logic.categoryList[i];
                        return Obx(() => Container(
                              padding: EdgeInsets.only(
                                  left: i == 0 ? 20.w : 15.w, right: 15.w),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => logic.clickCategory(category),
                                  behavior: HitTestBehavior.translucent,
                                  child: Text(
                                    category.label,
                                    style: category.value ==
                                            logic.activeCategory.value.value
                                        ? StylesLibrary.ts_333333_16sp_medium
                                        : StylesLibrary.ts_999999_16sp,
                                  ),
                                ),
                              ),
                            ));
                      })),
              // GestureDetector(
              //   behavior: HitTestBehavior.translucent,
              //   child: Container(
              //     padding: EdgeInsets.only(left: 10.w, right: 20.w),
              //     child: Center(
              //       child: ImageLibrary.appUnfold.toImage
              //         ..width = 12.w
              //         ..height = 7.h,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
      Expanded(
          child: PageView.builder(
              controller: logic.pageController,
              itemCount: logic.categoryList.length,
              itemBuilder: (context, i) {
                return Obx(() => SmartRefresher(
                    controller: logic.refreshCtrlList[i],
                    // header: const MomentsIndicator(),
                    // header: const MaterialClassicHeader(color: Color(0xFF041d31)),
                    footer: IMViews.buildFooter(),
                    onRefresh: logic.queryWorkingCircleList,
                    onLoading: logic.loadMore,
                    enablePullUp: true,
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 7.h,
                      crossAxisSpacing: 7.w,
                      itemCount: logic.workMoments.length,
                      padding: EdgeInsets.only(
                          top: 7.h, left: 12.w, right: 12.w, bottom: 12.h),
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final xhsMoment = index < logic.workMoments.length - 1
                              ? logic.workMoments[index]
                              : null;
                          return xhsMoment == null
                              ? SizedBox()
                              : GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () =>
                                      logic.startXhsMomentDetail(xhsMoment),
                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: StylesLibrary.c_FFFFFF,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Column(
                                      children: [
                                        if (null != xhsMoment.content?.metas &&
                                            xhsMoment.content!.metas!.length >
                                                0) ...[
                                          if (xhsMoment.content?.type != 1)
                                            CachedNetworkImage(
                                              imageUrl: xhsMoment.content!
                                                  .metas![0]!.original!,
                                              placeholder: (context, url) =>
                                                  Container(
                                                      height: 80.h,
                                                      child: Center(
                                                        child:
                                                            Text("loading..."),
                                                      )),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                          height: 80.h,
                                                          child: Center(
                                                            child: Text(""),
                                                          )),
                                            ),
                                          if (xhsMoment.content?.type == 1)
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: xhsMoment.content!
                                                          .metas![0]!.thumb ??
                                                      xhsMoment.content!
                                                          .metas![0]!.original!,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                          height: 80.h,
                                                          child: Center(
                                                            child: Text(""),
                                                          )),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                                ImageLibrary.videoPause.toImage
                                                  ..width = 40.w
                                                  ..height = 40.h,
                                              ],
                                            )
                                        ],
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 8.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if ((context !=
                                                          xhsMoment
                                                              .content?.title &&
                                                      xhsMoment!.content!.title!
                                                          .isNotEmpty) ||
                                                  (context !=
                                                          xhsMoment
                                                              .content?.text &&
                                                      xhsMoment!.content!.text!
                                                          .isNotEmpty)) ...[
                                                (xhsMoment.content?.title ??
                                                        xhsMoment.content!.text)
                                                    .toString()
                                                    .toText
                                                  ..style = StylesLibrary
                                                      .ts_333333_14sp
                                                  ..overflow =
                                                      TextOverflow.ellipsis
                                                  ..maxLines = 2,
                                                12.verticalSpace
                                              ],
                                              Row(
                                                children: [
                                                  AvatarView(
                                                    url: xhsMoment.faceURL,
                                                    text: xhsMoment.nickname
                                                        ?.toString(),
                                                    width: 20.w,
                                                    height: 20.h,
                                                  ),
                                                  6.horizontalSpace,
                                                  Expanded(
                                                      child:
                                                          (xhsMoment.nickname ??
                                                                  "")
                                                              .toString()
                                                              .toText
                                                            ..style = StylesLibrary
                                                                .ts_999999_11sp
                                                            ..overflow =
                                                                TextOverflow
                                                                    .ellipsis
                                                            ..maxLines = 1),
                                                  10.horizontalSpace,
                                                  GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () => logic
                                                        .likeMoments(xhsMoment),
                                                    child: Row(
                                                      children: [
                                                        if (logic.iIsLiked(
                                                            xhsMoment))
                                                          ImageLibrary
                                                              .likeActive
                                                              .toImage
                                                            ..width = 14.w
                                                            ..height = 13.h,
                                                        if (!logic.iIsLiked(
                                                            xhsMoment))
                                                          ImageLibrary
                                                              .like.toImage
                                                            ..width = 14.w
                                                            ..height = 13.h,
                                                        6.horizontalSpace,
                                                        (null !=
                                                                    xhsMoment
                                                                        .likeUsers
                                                                ? xhsMoment
                                                                    .likeUsers!
                                                                    .length
                                                                : 0)
                                                            .toString()
                                                            .toText
                                                          ..style = StylesLibrary
                                                              .ts_999999_11sp
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                        });
                      },
                    )));
              }))
    ];
  }

  // List<Widget> get followPage {
  //   return [
  //     Expanded(
  //         child: ListView.builder(
  //             itemCount: logic.xhsMomentList.length,
  //             itemBuilder: (_, i) => Obx(() {
  //                   final xhsMoment = logic.xhsMomentList[i];
  //                   return Container(
  //                     padding: EdgeInsets.only(top: 12.h, bottom: 15.h),
  //                     margin: EdgeInsets.only(bottom: 6.h),
  //                     color: StylesLibrary.c_FFFFFF,
  //                     child: Column(
  //                       children: [
  //                         Container(
  //                             padding: EdgeInsets.symmetric(horizontal: 12.w),
  //                             child: Row(
  //                               children: [
  //                                 AvatarView(
  //                                   url: xhsMoment["user"]["avatar"],
  //                                   text: xhsMoment["user"]["name"].toString(),
  //                                   width: 32.w,
  //                                   height: 32.h,
  //                                 ),
  //                                 10.horizontalSpace,
  //                                 xhsMoment["user"]["name"].toString().toText
  //                                   ..style = StylesLibrary.ts_4B3230_16sp
  //                                   ..overflow = TextOverflow.ellipsis
  //                                   ..maxLines = 1,
  //                                 10.horizontalSpace,
  //                                 xhsMoment["time"].toString().toText
  //                                   ..style = StylesLibrary.ts_999999_12sp,
  //                                 Spacer(),
  //                                 GestureDetector(
  //                                   child: Container(
  //                                     width: 20.w,
  //                                     height: 20.h,
  //                                     child: ImageLibrary.appMoreBlack.toImage
  //                                       ..width = 20.w
  //                                       ..height = 4.h,
  //                                   ),
  //                                 ),
  //                               ],
  //                             )),
  //                         12.verticalSpace,
  //                         ConstrainedBox(
  //                             child: Swiper(
  //                               itemCount: 3,
  //                               loop: false,
  //                               pagination: SwiperCustomPagination(
  //                                 builder: (BuildContext context,
  //                                     SwiperPluginConfig config) {
  //                                   return Align(
  //                                     alignment: Alignment.bottomCenter,
  //                                     child: Container(
  //                                         padding: EdgeInsets.symmetric(
  //                                             vertical: 7.5.h),
  //                                         child: PageIndicator(
  //                                           count: config.itemCount,
  //                                           controller: config.pageController!,
  //                                           layout: PageIndicatorLayout.SCALE,
  //                                           size: 10.h,
  //                                           activeColor: StylesLibrary.c_8443F8,
  //                                           color: StylesLibrary.c_CDCDCD,
  //                                           space: 5,
  //                                         )),
  //                                   );
  //                                 },
  //                               ),
  //                               itemBuilder: (BuildContext context, int index) {
  //                                 return Container(
  //                                   padding: EdgeInsets.only(bottom: 25.h),
  //                                   color: StylesLibrary.c_FFFFFF,
  //                                   child: Image.network(
  //                                     "https://img0.baidu.com/it/u=104573412,694169124&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=777",
  //                                     fit: BoxFit.contain,
  //                                   ),
  //                                 );
  //                               },
  //                             ),
  //                             constraints:
  //                                 BoxConstraints.loose(Size(375.w, 200.h))),
  //                         Container(
  //                           padding: EdgeInsets.symmetric(horizontal: 12.w),
  //                           child: Row(
  //                             children: [
  //                               Expanded(
  //                                   child: xhsMoment["title"].toString().toText
  //                                     ..style = StylesLibrary.ts_333333_16sp_medium
  //                                     ..overflow = TextOverflow.ellipsis
  //                                     ..maxLines = 1),
  //                               StrLibrary .seeDetails.toText
  //                                 ..style = StylesLibrary.ts_9280B3_14sp
  //                             ],
  //                           ),
  //                         ),
  //                         12.verticalSpace,
  //                         Container(
  //                           padding: EdgeInsets.symmetric(horizontal: 12.w),
  //                           child: Row(
  //                             children: [
  //                               ImageLibrary.like2.toImage
  //                                 ..width = 20.w
  //                                 ..height = 18.h,
  //                               5.horizontalSpace,
  //                               Container(
  //                                 width: 75.w,
  //                                 child: xhsMoment["likeCount"].toString().toText
  //                                   ..style = StylesLibrary.ts_4B3230_12sp,
  //                               ),
  //                               ImageLibrary.collect.toImage
  //                                 ..width = 20.w
  //                                 ..height = 20.h,
  //                               5.horizontalSpace,
  //                               Container(
  //                                 width: 75.w,
  //                                 child: xhsMoment["likeCount"].toString().toText
  //                                   ..style = StylesLibrary.ts_4B3230_12sp,
  //                               ),
  //                               ImageLibrary.comment.toImage
  //                                 ..width = 20.w
  //                                 ..height = 20.h,
  //                               5.horizontalSpace,
  //                               Container(
  //                                 width: 75.w,
  //                                 child: xhsMoment["likeCount"].toString().toText
  //                                   ..style = StylesLibrary.ts_4B3230_12sp,
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 })))
  //   ];
  // }
}
