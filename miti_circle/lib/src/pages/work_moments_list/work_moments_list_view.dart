import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:miti_circle/src/widgets/moments_indicator.dart';
import 'package:miti_circle/src/widgets/work_moments_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sprintf/sprintf.dart';

import 'work_moments_list_logic.dart';

class WorkMomentsListPage extends StatelessWidget {
  final WorkMomentsListLogic logic = Get.find(tag: GetTags.moments);

  WorkMomentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            systemNavigationBarColor: StylesLibrary.c_FFFFFF,
            systemNavigationBarIconBrightness: Brightness.dark),
        child: Scaffold(
          backgroundColor: StylesLibrary.c_FFFFFF,
          body: Obx(() => Stack(
                children: [
                  Listener(
                    onPointerUp: (event) {
                      // logic.pointerUp = true;
                      // logic.startRefresh();
                    },
                    onPointerDown: (event) {
                      // logic.pointerUp = false;
                      logic.cancelComment();
                      final position = logic.popMenuPosition;
                      final size = logic.popMenuSize;
                      if (null != position && size != null) {
                        final dx = event.position.dx;
                        final dy = event.position.dy;
                        if (dx > position.dx &&
                            dx < (position.dx + size.width) &&
                            dy > position.dy &&
                            dy < (position.dy + size.height)) {
                          // 点击事件在菜单上
                        } else {
                          logic.hiddenLikeCommentPopMenu();
                        }
                      }
                    },
                    child: SmartRefresher(
                      controller: logic.refreshCtrl,
                      header: const MomentsIndicator(),
                      // header: const MaterialClassicHeader(color: Color(0xFF041d31)),
                      footer: IMViews.buildFooter(),
                      onRefresh: logic.queryWorkingCircleList,
                      onLoading: logic.loadMore,
                      enablePullUp: true,
                      child: CustomScrollView(
                        controller: logic.scrollController,
                        // physics: const BouncingScrollPhysics(),
                        // controller: logic.scrollController,
                        slivers: [
                          _sliverAppBar(context),
                          if (logic.newMessageCount.value > 0 && logic.isMyself)
                            _newMessageHintView,
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (_, int index) {
                                final info = logic.workMoments.elementAt(index);
                                return Obx(() => _buildItemView(info, index));
                              },
                              childCount: logic.workMoments.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (logic.commentHintText.isNotEmpty)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _inputBox,
                    ),
                ],
              )),

          /* body: Obx(() => SmartRefresher(
            controller: logic.refreshCtrl,
            header: const MaterialClassicHeader(),
            onRefresh: logic.queryWorkingCircleList,
            child: ListView.builder(
              itemCount: logic.workMoments.length,
              itemBuilder: (_, index) {
                final info = logic.workMoments.elementAt(index);
                return Obx(() => _buildItemView(info));
              },
            ),
          )),*/
          /* body: Obx(() => Stack(
            children: [
              Listener(
                onPointerUp: (event) {
                  logic.pointerUp = true;
                  logic.startRefresh();
                },
                onPointerDown: (event) {
                  logic.pointerUp = false;
                  logic.cancelComment();
                  final position = logic.popMenuPosition;
                  final size = logic.popMenuSize;
                  if (null != position && size != null) {
                    final dx = event.position.dx;
                    final dy = event.position.dy;
                    if (dx > position.dx &&
                        dx < (position.dx + size.width) &&
                        dy > position.dy &&
                        dy < (position.dy + size.height)) {
                      // 点击事件在菜单上
                    } else {
                      logic.hiddenLikeCommentPopMenu();
                    }
                  }
                },
                child: CustomScrollView(
                  controller: logic.scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _sliverAppBar,
                    if (logic.newMessageCount.value > 0 && logic.isMyself)
                      _newMessageHintView,
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, int index) {
                          final info = logic.workMoments.elementAt(index);
                          return Obx(() => _buildItemView(info));
                        },
                        childCount: logic.workMoments.length,
                      ),
                    ),
                    if (logic.hasMore.value)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 55.h,
                          child: Center(
                            child: CupertinoActivityIndicator(
                              color: StylesLibrary.c_8443F8,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (logic.commentHintText.isNotEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _inputBox,
                ),
              Positioned(left: 16.w, child: _refreshIndicator),
            ],
          )),*/
        ));
  }

  // Widget get _refreshIndicator => AnimatedBuilder(
  //       animation: logic.translationController,
  //       builder: (BuildContext context, Widget? child) {
  //         return Transform.translate(
  //             offset: Offset(0, logic.translationAnimation.value),
  //             child: AnimatedBuilder(
  //                 animation: logic.rotationController,
  //                 builder: (BuildContext context, Widget? child) {
  //                   return Transform.rotate(
  //                       angle: logic.rotationAnimation.value,
  //                       child: ImageLibrary.circle.toImage
  //                         ..width = 24.w
  //                         ..height = 24.h);
  //                 }));
  //       },
  //     );

  Widget _buildItemView(WorkMoments moments, int index) => WorkMomentsItem(
        moments: moments,
        popMenuID: logic.popMenuID.value,
        previewWhoCanWatchList: logic.previewWhoCanWatchList,
        delMoment: logic.delWorkWorkMoments,
        replyComment: logic.replyComment,
        delComment: logic.delComment,
        onPositionCallback: logic.popMenuPositionCallback,
        onTapLike: logic.likeMoments,
        onTapComment: logic.commentMoments,
        isLike: logic.iIsLiked(moments),
        previewVideo: logic.previewVideo,
        previewPicture: logic.previewPicture,
        showLikeCommentPopMenu: logic.showLikeCommentPopMenu,
        onTapAvatar: logic.viewUserProfile,
      );

  Widget get _newMessageHintView => SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
          color: StylesLibrary.c_FFFFFF,
          child: Center(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: logic.seeNewMessage,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: StylesLibrary.c_000000_opacity60,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child:
                    sprintf(StrLibrary.nMessage, [logic.newMessageCount.value])
                        .toText
                      ..style = StylesLibrary.ts_FFFFFF_16sp,
              ),
            ),
          ),
        ),
      );

  Widget _sliverAppBar(BuildContext context) => SliverAppBar(
        title: (logic.scrollHeight <=
                (180.h - 58.h - MediaQuery.of(context).padding.top))
            ? Container(
                padding: EdgeInsets.only(bottom: 20.h),
                child: StrLibrary.workingCircle.toText
                  ..style = StylesLibrary.ts_333333_18sp_medium,
              )
            : Container(
                padding: EdgeInsets.only(bottom: 20.h),
                child: AvatarView(
                  width: 36.w,
                  height: 36.h,
                  url: logic.faceURL,
                  text: logic.nickname,
                  onTap: logic.viewMyProfilePanel,
                )),
        centerTitle: true,
        expandedHeight: 180.h,
        toolbarHeight: 66.h,
        backgroundColor: StylesLibrary.c_FFFFFF,
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
                child: ImageLibrary.appBackWhite.toImage
                  ..width = 24.w
                  ..height = 24.h
                  ..color = StylesLibrary.c_333333,
              ),
            ),
          ),
        ),
        // stretchTriggerOffset: 100,
        // leading: ImageLibrary.backBlack.toImage..color = StylesLibrary.c_FFFFFF,
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
                            color: StylesLibrary.c_FFFFFF_opacity70,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Center(
                            child: ImageLibrary.appAdd.toImage
                              ..width = 16.w
                              ..height = 16.h
                              ..color = StylesLibrary.c_333333,
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
                        color: StylesLibrary.c_FFFFFF_opacity70,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Center(
                        child: ImageLibrary.appNotification.toImage
                          ..width = 16.w
                          ..height = 16.h
                          ..color = StylesLibrary.c_333333,
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
              color: StylesLibrary.c_FFFFFF,
              child: ImageLibrary.workingCircleHeaderBg3.toImage
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
                        onTap: logic.viewMyProfilePanel,
                      ),
                      12.horizontalSpace,
                      Expanded(
                          child: (logic.nickname ?? '').toText
                            ..style = StylesLibrary.ts_333333_18sp_medium
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
                        //       color: StylesLibrary.c_FFFFFF_opacity70,
                        //       borderRadius: BorderRadius.circular(6.r),
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         ImageLibrary.appAdd.toImage..width=16.w..height=16.h,
                        //         6.horizontalSpace,
                        //         StrLibrary .publishMoment.toText..style=StylesLibrary.ts_333333_14sp_medium
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
                              color: StylesLibrary.c_FFFFFF_opacity70,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              children: [
                                ImageLibrary.appAdd.toImage
                                  ..width = 16.w
                                  ..height = 16.h,
                                6.horizontalSpace,
                                StrLibrary.publishMoment.toText
                                  ..style = StylesLibrary.ts_333333_14sp_medium
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
                                color: StylesLibrary.c_FFFFFF_opacity70,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Center(
                                child: ImageLibrary.appNotification.toImage
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
                      color: StylesLibrary.c_FFFFFF,
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
  //         padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 0),
  //         height: 38.h,
  //         decoration: BoxDecoration(
  //           color: StylesLibrary.c_FFFFFF_opacity70,
  //           borderRadius: BorderRadius.circular(6.r),
  //         ),
  //         child: Row(
  //           children: [
  //             ImageLibrary.appAdd.toImage
  //               ..width = 16.w
  //               ..height = 16.h,
  //             6.horizontalSpace,
  //             StrLibrary .publishMoment.toText..style = StylesLibrary.ts_333333_14sp_medium
  //           ],
  //         ),
  //       ),
  //       itemBuilder: (_) => <PopupMenuEntry<int>>[
  //         PopupMenuItem(
  //           padding: EdgeInsets.only(left: 12.w),
  //           height: 45.h,
  //           value: 0,
  //           child: Row(
  //             children: [
  //               ImageLibrary.appPublishPic.toImage
  //                 ..width = 20.w
  //                 ..height = 20.h,
  //               12.horizontalSpace,
  //               StrLibrary .publishPicture.toText..style = StylesLibrary.ts_333333_16sp,
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
  //               ImageLibrary.appPublishVideo.toImage
  //                 ..width = 20.w
  //                 ..height = 20.h,
  //               12.horizontalSpace,
  //               StrLibrary .publishVideo.toText..style = StylesLibrary.ts_333333_16sp,
  //             ],
  //           ),
  //         ),
  //       ],
  //       onSelected: logic.publish,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(6.w))),
  //     );

  // Widget get _popButton2 => Padding(
  //       padding: EdgeInsets.only(bottom: 20.h),
  //       child: PopupMenuButton<int>(
  //         offset: Offset(0, 48.h),
  //         padding: EdgeInsets.zero,
  //         icon: Container(
  //           // padding: EdgeInsets.only(bottom: 20.h),
  //           child: Container(
  //             width: 38.w,
  //             height: 38.h,
  //             decoration: BoxDecoration(
  //               color: StylesLibrary.c_FFFFFF_opacity70,
  //               borderRadius: BorderRadius.circular(6.r),
  //             ),
  //             child: Center(
  //               child: ImageLibrary.appAdd.toImage
  //                 ..width = 16.w
  //                 ..height = 16.h
  //                 ..color = StylesLibrary.c_333333,
  //             ),
  //           ),
  //         ),
  //         itemBuilder: (_) => <PopupMenuEntry<int>>[
  //           PopupMenuItem(
  //             padding: EdgeInsets.only(left: 12.w),
  //             height: 45.h,
  //             value: 0,
  //             child: Row(
  //               children: [
  //                 ImageLibrary.appPublishPic.toImage
  //                   ..width = 20.w
  //                   ..height = 20.h,
  //                 12.horizontalSpace,
  //                 StrLibrary .publishPicture.toText..style = StylesLibrary.ts_333333_16sp,
  //               ],
  //             ),
  //           ),
  //           const PopupMenuDivider(),
  //           PopupMenuItem(
  //             padding: EdgeInsets.only(left: 12.w),
  //             height: 45.h,
  //             value: 1,
  //             child: Row(
  //               children: [
  //                 ImageLibrary.appPublishVideo.toImage
  //                   ..width = 20.w
  //                   ..height = 20.h,
  //                 12.horizontalSpace,
  //                 StrLibrary .publishVideo.toText..style = StylesLibrary.ts_333333_16sp,
  //               ],
  //             ),
  //           ),
  //         ],
  //         onSelected: logic.publish,
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(6.w))),
  //       ),
  //     );

  /* Widget _buildItemView(WorkMoments moments) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: StylesLibrary.c_FFFFFF,
          border: BorderDirectional(
            bottom: BorderSide(
              color: StylesLibrary.c_E8EAEF,
              width: .5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarView(
              size: 48.w,
              url: moments.faceURL,
              text: moments.userName,
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (moments.userName ?? '').toText
                    ..style = StylesLibrary.ts_6085B1_16sp_medium,
                  // (moments.content?.text ?? '').toText..style = StylesLibrary.ts_333333_16sp,
                  ExpandedText(text: moments.content?.text ?? ''),
                  if (null != moments.content?.metas &&
                      moments.content!.metas!.isNotEmpty)
                    _buildMetaView(
                      moments.content?.type ?? 0,
                      moments.content?.metas ?? [],
                    ),
                  if (null != moments.atUsers && moments.atUsers!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: sprintf(StrLibrary .mentioned, [
                        moments.atUsers!.map((e) => e.userName).join('、')
                      ]).toText
                        ..style = StylesLibrary.ts_999999_12sp,
                    ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          TimelineUtil.format(
                            (moments.createTime ?? 0) * 1000,
                            dayFormat: DayFormat.Full,
                            locale: Get.locale?.languageCode ?? 'zh',
                          ).toText
                            ..style = StylesLibrary.ts_999999_12sp,
                          if (moments.permission != 0 &&
                              moments.userID == OpenIM.iMManager.uid)
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () =>
                                  logic.previewWhoCanWatchList(moments),
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: SizedBox(
                                  height: 26.h,
                                  child: Row(
                                    children: [
                                      Icon(
                                        moments.permission == 1
                                            ? Icons.lock
                                            : Icons.group_rounded,
                                        color: StylesLibrary.c_6085B1,
                                        size: 14.h,
                                      ),
                                      4.horizontalSpace,
                                      (moments.permission == 1
                                              ? StrLibrary .private
                                              : StrLibrary .partiallyVisible)
                                          .toText
                                        ..style = StylesLibrary.ts_6085B1_12sp,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (moments.userID == OpenIM.iMManager.uid)
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => logic.delWorkWorkMoments(moments),
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: Container(
                                  height: 26.h,
                                  alignment: Alignment.center,
                                  child: StrLibrary .delete.toText
                                    ..style = StylesLibrary.ts_6085B1_12sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                      _buildLikeCommentPopMenu(moments),
                    ],
                  ),
                  if (null != moments.likeUsers &&
                      moments.likeUsers!.isNotEmpty)
                    _buildLikeListView(moments.likeUsers!),

                  if (null != moments.comments && moments.comments!.isNotEmpty)
                    _buildCommentListView(moments.userID!, moments),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildLikeListView(List<LikeUsers> likeUsers) => RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: Icon(
                  Icons.thumb_up_alt_outlined,
                  size: 13.w,
                  color: StylesLibrary.c_6085B1,
                ),
              ),
            ),
            TextSpan(
              text: likeUsers.map((e) => e.userName).join('、'),
              style: StylesLibrary.ts_6085B1_12sp,
            ),
          ],
        ),
      );

  Widget _buildCommentListView(String userID, WorkMoments moments) {
    Widget buildItemView(Comments e) => CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 20.h,
          onPressed: () => logic.replyComment(moments, e),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: e.userName ?? '',
                    style: StylesLibrary.ts_6085B1_14sp,
                    children: [
                      if (e.replyUserName != null &&
                          e.replyUserName!.isNotEmpty)
                        TextSpan(
                          text: ' ${StrLibrary .reply} ',
                          style: StylesLibrary.ts_333333_14sp,
                          children: [
                            TextSpan(
                              text: e.replyUserName,
                              style: StylesLibrary.ts_6085B1_14sp,
                            )
                          ],
                        ),
                      TextSpan(
                        text: '：${e.content}',
                        style: StylesLibrary.ts_333333_14sp,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );

    // 是我发的朋友圈或者是我评论的，可以删除
    bool canDel(Comments e) =>
        e.userID == OpenIM.iMManager.uid || userID == OpenIM.iMManager.uid;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.r),
        color: StylesLibrary.c_F8F9FA,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: moments.comments!
            .map((e) => canDel(e)
                ? DeleteCommentPopMenu(
                    child: buildItemView(e),
                    onTap: () => logic.delComment(
                      moments.workMomentID!,
                      e.contentID!,
                    ),
                  )
                : buildItemView(e))
            .toList(),
      ),
    );
  }

  Widget _buildLikeCommentPopMenu(WorkMoments moments) => Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          logic.popMenuID.value == moments.workMomentID
              ? LikeCommentPopMenu(
                  onPositionCallback: logic.popMenuPositionCallback,
                  isLike: logic.iIsLiked(moments),
                  onTapLike: () => logic.likeMoments(moments),
                  onTapComment: () => logic.commentMoments(moments),
                )
              : 26.verticalSpace,
          // widget.showPopMenu ? _buildToolsView() : 26.verticalSpace,
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => logic.showLikeCommentPopMenu(moments.workMomentID!),
            child: ImageLibrary.moreOp.toImage
              ..width = 22.w
              ..height = 24.h,
          ),
        ],
      ));

  /// 图/视频正文
  /// [type] 0:picture  1:video
  Widget _buildMetaView(int type, List<Metas> metas) {
    return GridView.builder(
      padding: EdgeInsets.only(top: 10.h),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: type == 1 ? 9 / 16 : 1.0,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.h,
      ),
      itemBuilder: (_, index) {
        final isPicture = type == 0;
        final meta = metas.elementAt(index);
        final url = meta.thumb ?? meta.original;
        if (isPicture) {
          return Hero(
            tag: meta.original!,
            child: GestureDetector(
              onTap: () => logic.previewPicture(index, metas),
              child: ImageUtil.networkImage(url: url!, fit: BoxFit.cover),
            ),
          );
        }
        return Hero(
          tag: meta.original!,
          child: GestureDetector(
            onTap: () => logic.previewVideo(meta.original!),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ImageUtil.networkImage(url: url!, fit: BoxFit.cover),
                ImageLibrary.videoPause.toImage
                  ..width = 40.w
                  ..height = 40.h,
              ],
            ),
          ),
        );
      },
      itemCount: metas.length,
    );
  }*/

  Widget get _inputBox => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        color: StylesLibrary.c_F7F8FA,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: StylesLibrary.c_FFFFFF,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  controller: logic.inputCtrl,
                  autofocus: true,
                  minLines: 1,
                  maxLines: 4,
                  style: StylesLibrary.ts_333333_16sp,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: logic.commentHintText.value,
                    hintStyle: StylesLibrary.ts_999999_16sp,
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
            ImageLibrary.appSendMessage2.toImage
              ..width = 28.w
              ..height = 28.h
              ..onTap = logic.submitComment,
          ],
        ),
      );
}
