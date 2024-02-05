import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
                    // 12.verticalSpace,
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
                                      final category =
                                          logic.categoryList.value[i];
                                      return Obx(() => Container(
                                            padding: EdgeInsets.only(
                                                left: i == 0 ? 20.w : 10.w,
                                                right: 10.w),
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () => logic
                                                    .clickCategory(category),
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                child: Text(
                                                  category,
                                                  style: category ==
                                                          logic.activeCategory
                                                              .value
                                                      ? Styles
                                                          .ts_333333_16sp_medium
                                                      : Styles.ts_999999_16sp,
                                                ),
                                              ),
                                            ),
                                          ));
                                    })),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: Container(
                                padding:
                                    EdgeInsets.only(left: 10.w, right: 20.w),
                                child: Center(
                                  child: ImageRes.appUnfold.toImage
                                    ..width = 12.w
                                    ..height = 7.h,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 7.h,
                      crossAxisSpacing: 7.w,
                      itemCount: logic.articleList.length,
                      padding: EdgeInsets.only(
                          top: 7.h, left: 12.w, right: 12.w, bottom: 12.h),
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final article = logic.articleList[index];
                          return Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Styles.c_FFFFFF,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: article["splash"],
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 8.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      article["title"].toString().toText
                                        ..style = Styles.ts_333333_14sp
                                        ..overflow = TextOverflow.ellipsis
                                        ..maxLines = 2,
                                      12.verticalSpace,
                                      Row(
                                        children: [
                                          AvatarView(
                                            url: article["user"]["avatar"],
                                            text: article["user"]["name"]
                                                .toString(),
                                            width: 20.w,
                                            height: 20.h,
                                          ),
                                          6.horizontalSpace,
                                          article["user"]["name"]
                                              .toString()
                                              .toText
                                            ..style = Styles.ts_999999_11sp
                                            ..overflow = TextOverflow.ellipsis
                                            ..maxLines = 1,
                                          Spacer(),
                                          ImageRes.like.toImage
                                            ..width = 14.w
                                            ..height = 13.h,
                                          6.horizontalSpace,
                                          article["likeCount"].toString().toText
                                            ..style = Styles.ts_999999_11sp
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                      },
                    )),
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
