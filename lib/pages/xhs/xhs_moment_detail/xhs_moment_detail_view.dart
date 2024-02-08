import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import '../xhs_logic.dart';
import 'xhs_moment_detail_logic.dart';

class XhsMomentDetailPage extends StatelessWidget {
  final logic = Get.find<XhsMomentDetailLogic>();
  final xhsLogic = Get.find<XhsLogic>();

  XhsMomentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final xhsMoment = logic.xhsMomentList[0];
      return Scaffold(
        appBar: TitleBar.xhsMomentDetail(
          backgroundColor: Styles.c_FFFFFF,
          left: Expanded(
              child: Row(children: [
            ImageRes.appBackBlack.toImage
              ..width = 24.w
              ..height = 24.h
              ..onTap = (() => Get.back()),
            SizedBox(width: 12.w),
            AvatarView(
              url: xhsMoment.faceURL,
              text: xhsMoment.nickname,
              width: 36.w,
              height: 36.h,
            ),
            9.horizontalSpace,
            (xhsMoment.nickname ?? "").toText
              ..style = Styles.ts_333333_18sp_medium
              ..maxLines = 1
              ..overflow = TextOverflow.ellipsis
              ..textAlign = TextAlign.center,
          ])),
          right: logic.isMyMoment? Button(
              text: StrRes.delete,
              textStyle: Styles.ts_FFFFFF_14sp,
              disabledTextStyle: Styles.ts_FFFFFF_14sp,
              height: 28.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              onTap: logic.delXhsMoment) : SizedBox(),
        ),
        backgroundColor: Styles.c_F7F7F7,
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Container(
              color: Styles.c_FFFFFF,
            ),
            Listener(
                onPointerDown: (event) {
                  logic.cancelComment();
                },
                child: Column(
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (null != xhsMoment.content?.metas &&
                              xhsMoment.content!.metas!.isNotEmpty)
                            ConstrainedBox(
                                child: Swiper(
                                  itemCount: xhsMoment.content!.metas!.length,
                                  loop: false,
                                  onTap: (index) => logic.viewMeta(
                                      type: xhsMoment.content?.type ?? 0,
                                      metas: xhsMoment.content!.metas!,
                                      index: index),
                                  pagination: SwiperCustomPagination(
                                    builder: (BuildContext context,
                                        SwiperPluginConfig config) {
                                      return Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 7.5.h),
                                            child: PageIndicator(
                                              count: config.itemCount,
                                              controller:
                                                  config.pageController!,
                                              layout: PageIndicatorLayout.SCALE,
                                              size: 10.h,
                                              activeColor: Styles.c_8443F8,
                                              color: Styles.c_CDCDCD,
                                              space: 5,
                                            )),
                                      );
                                    },
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        padding: EdgeInsets.only(bottom: 25.h),
                                        color: Styles.c_FFFFFF,
                                        child: xhsMoment.content?.type == 1
                                            ? Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: xhsMoment.content!
                                                            .metas![0]!.thumb ??
                                                        xhsMoment
                                                            .content!
                                                            .metas![0]!
                                                            .original!,
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                                height: 80.h,
                                                                child: Center(
                                                                  child: Text(
                                                                      "loading..."),
                                                                )),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                  ImageRes.videoPause.toImage
                                                    ..width = 40.w
                                                    ..height = 40.h,
                                                ],
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: xhsMoment.content!
                                                    .metas![index].original!,
                                                placeholder: (context, url) =>
                                                    Container(
                                                        height: 80.h,
                                                        child: Center(
                                                          child: Text(
                                                              "loading..."),
                                                        )),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Container(
                                                        height: 80.h,
                                                        child: Center(
                                                          child: Text("error"),
                                                        )),
                                              ));
                                  },
                                ),
                                constraints:
                                    BoxConstraints.loose(Size(375.w, 300.h))),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            width: 375.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if ((null != xhsMoment?.content?.author &&
                                        xhsMoment!
                                            .content!.author!.isNotEmpty) ||
                                    (null != xhsMoment?.content?.originLink &&
                                        xhsMoment!.content!.originLink!
                                            .isNotEmpty)) ...[
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: logic.onTapOriginCard,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 10.h),
                                      decoration: BoxDecoration(
                                        color: Styles.c_F7F8FA,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6.r)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (null !=
                                                      xhsMoment
                                                          ?.content?.title &&
                                                  xhsMoment!.content!.title!
                                                      .isNotEmpty) ...[
                                                xhsMoment!.content!.title!
                                                    .toString()
                                                    .toText
                                                  ..style = Styles
                                                      .ts_333333_16sp_medium
                                                  ..overflow =
                                                      TextOverflow.ellipsis
                                                  ..maxLines = 1,
                                                5.verticalSpace
                                              ],
                                              if (null !=
                                                      xhsMoment
                                                          ?.content?.author &&
                                                  xhsMoment!.content!.author!
                                                      .isNotEmpty)
                                                xhsMoment!.content!.author!
                                                    .toString()
                                                    .toText
                                                  ..style = Styles
                                                      .ts_999999_12sp_medium
                                                  ..overflow =
                                                      TextOverflow.ellipsis
                                                  ..maxLines = 1,
                                            ],
                                          )),
                                          if (null !=
                                              xhsMoment.content?.metas?[0]
                                                  ?.original) ...[
                                            14.horizontalSpace,
                                            Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                color: Styles.c_F7F8FA,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6.r)),
                                              ),
                                              child: CachedNetworkImage(
                                                width: 82.w,
                                                height: 45.h,
                                                imageUrl: xhsMoment.content!
                                                    .metas![0].original!,
                                                placeholder: (context, url) =>
                                                    Container(
                                                        height: 80.h,
                                                        child: Center(
                                                          child: Text(
                                                              "loading..."),
                                                        )),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Container(
                                                        height: 80.h,
                                                        child: Center(
                                                          child: Text("error"),
                                                        )),
                                              ),
                                            )
                                          ]
                                        ],
                                      ),
                                    ),
                                  ),
                                  20.verticalSpace
                                ],
                                if (null != xhsMoment?.content?.title &&
                                    xhsMoment!.content!.title!.isNotEmpty) ...[
                                  xhsMoment!.content!.title!.toString().toText
                                    ..style = Styles.ts_333333_16sp_medium,
                                  10.verticalSpace
                                ],
                                if (null != xhsMoment.content?.text &&
                                    xhsMoment!.content!.text!.isNotEmpty) ...[
                                  xhsMoment.content!.text.toString().toText
                                    ..style = Styles.ts_333333_14sp,
                                  10.verticalSpace
                                ],
                                _buildTimeView(),
                                10.verticalSpace
                              ],
                            ),
                          ),
                          Container(
                            color: Styles.c_F7F7F7,
                            height: 6.h,
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              width: 375.w,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      12.horizontalSpace,
                                      sprintf(StrRes.totalComment,
                                          [logic.commentsCount]).trim().toText
                                        ..style = Styles.ts_999999_12sp,
                                    ],
                                  ),
                                  if (logic.comments.isNotEmpty)
                                    ...logic.comments
                                        .map((item) => _buildCommentView(item))
                                        .toList()
                                ],
                              ))
                        ],
                      ),
                    )),
                    Container(
                      color: Styles.c_F7F7F7,
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      child: Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => logic.commentMoments(),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.r),
                                  color: Styles.c_FFFFFF,
                                ),
                                child: Row(
                                  children: [
                                    ImageRes.editComment.toImage
                                      ..width = 14.w
                                      ..height = 14.h,
                                    6.horizontalSpace,
                                    Expanded(
                                        child: StrRes.saySomething.toText
                                          ..style = Styles.ts_999999_14sp)
                                  ],
                                )),
                          )),
                          19.horizontalSpace,
                          (logic.iIsLiked
                                  ? ImageRes.likeActive
                                  : ImageRes.like2)
                              .toImage
                            ..width = 20.w
                            ..height = 18.h
                            ..onTap = () => logic.likeMoments(),
                          5.horizontalSpace,
                          logic.likeUsersCount.toString().toText
                            ..style = Styles.ts_4B3230_12sp,
                          19.horizontalSpace,
                          ImageRes.comment.toImage
                            ..width = 20.w
                            ..height = 20.h
                            ..onTap = () => logic.commentMoments(),
                          5.horizontalSpace,
                          logic.commentsCount.toString().toText
                            ..style = Styles.ts_4B3230_12sp,
                        ],
                      ),
                    )
                  ],
                )),
            if (logic.commentHintText.isNotEmpty)
              Align(
                alignment: Alignment.bottomCenter,
                child: _inputBox,
              ),
          ],
        ),
      );
    });
  }

  Widget _buildTimeView() => TimelineUtil.format(
        (logic.xhsMomentList[0].createTime ?? 0),
        dayFormat: DayFormat.Full,
        locale: Get.locale?.languageCode ?? 'zh',
      ).toText
        ..style = Styles.ts_999999_12sp;

  Widget _buildCommentView(Comments comment) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Styles.c_EDEDED, width: 1.h)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarView(
                  width: 34.w,
                  height: 34.h,
                  url: comment.faceURL,
                  text: comment.nickname,
                ),
                6.horizontalSpace,
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (comment.nickname ?? "").toText
                              ..style = Styles.ts_9280B3_14sp_medium
                              ..overflow = TextOverflow.ellipsis
                              ..maxLines = 1,
                            // if (null != comment.content &&
                            //     comment.content!.isNotEmpty)
                            //   ConstrainedBox(
                            //     constraints:
                            //         BoxConstraints(maxWidth: 375.w - 104.w),
                            //     child: Container(
                            //       child: comment.content!.toText
                            //         ..style = Styles.ts_333333_14sp,
                            //     ),
                            //   )
                            if (null != comment.content &&
                                comment.content!.isNotEmpty)
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => logic.replyComment(comment),
                                child: ConstrainedBox(
                                  constraints:
                                      BoxConstraints(maxWidth: 375.w - 88.w),
                                  child: Container(
                                    child: RichText(
                                      text: TextSpan(children: [
                                        if (null != comment?.replyUserID) ...[
                                          TextSpan(
                                              text: StrRes.replied,
                                              style: Styles.ts_333333_14sp),
                                          TextSpan(
                                              text: " " +
                                                  (comment.replyNickname ??
                                                      "") +
                                                  "：",
                                              style: Styles.ts_8443F8_14sp),
                                          TextSpan(
                                              text: comment.content,
                                              style: Styles.ts_333333_14sp),
                                        ]
                                      ]),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ))
                      ],
                    ),
                    5.verticalSpace,
                    TimelineUtil.format(
                      (comment.createTime ?? 0),
                      dayFormat: DayFormat.Full,
                      locale: Get.locale?.languageCode ?? 'zh',
                    ).toText
                      ..style = Styles.ts_999999_11sp
                  ],
                ))
              ],
            )
          ],
        ),
      );

  Widget get _inputBox => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        color: Styles.c_F7F8FA,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Styles.c_FFFFFF,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  controller: logic.inputCtrl,
                  autofocus: true,
                  minLines: 1,
                  maxLines: 4,
                  style: Styles.ts_333333_16sp,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: logic.commentHintText.value,
                    hintStyle: Styles.ts_999999_16sp,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),
            12.horizontalSpace,
            ImageRes.appSendMessage2.toImage
              ..width = 28.w
              ..height = 28.h
              ..onTap = logic.submitComment,
          ],
        ),
      );
}
