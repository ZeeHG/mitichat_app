import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_working_circle/src/widgets/moments_indicator.dart';
import 'package:openim_working_circle/src/widgets/work_moments_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sprintf/sprintf.dart';

import 'work_moments_list_logic.dart';

class WorkMomentsListPage extends StatelessWidget {
  final WorkMomentsListLogic logic = Get.find(tag: GetTags.moments);

  WorkMomentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: TitleBar.back(),
      backgroundColor: Styles.c_F8F9FA,
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
                    // controller: logic.scrollController,
                    // physics: const BouncingScrollPhysics(),
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
                              color: Styles.c_0089FF,
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
    );
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
  //                       child: ImageRes.circle.toImage
  //                         ..width = 24.w
  //                         ..height = 24.h);
  //                 }));
  //       },
  //     );

  Widget _buildItemView(WorkMoments moments) => WorkMomentsItem(
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
          padding: EdgeInsets.only(top: 22.h, bottom: 6.h),
          color: Styles.c_FFFFFF,
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
                  color: Styles.c_0C1C33_opacity30,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: sprintf(StrRes.nMessage, [logic.newMessageCount.value])
                    .toText
                  ..style = Styles.ts_FFFFFF_14sp,
              ),
            ),
          ),
        ),
      );

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
        actions: logic.isMyself
            ? [
                ImageRes.workingCircleMessage.toImage
                  ..width = 24.w
                  ..height = 24.h
                  ..onTap = logic.seeNewMessage,
                // 16.horizontalSpace,
                _popButton,
                // ImageRes.workingCirclePublish.toImage
                //   ..width = 24.w
                //   ..height = 24.h,
                // 16.horizontalSpace,
              ]
            : [],
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
                      onTap: logic.viewMyProfilePanel,
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

  Widget get _popButton => PopupMenuButton<int>(
        offset: Offset(0, 48.h),
        padding: EdgeInsets.zero,
        icon: ImageRes.workingCirclePublish.toImage
          ..width = 24.w
          ..height = 24.h,
        itemBuilder: (_) => <PopupMenuEntry<int>>[
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            value: 0,
            height: 30.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.image,
                  color: Styles.c_0C1C33,
                  size: 16.w,
                ),
                10.horizontalSpace,
                StrRes.publishPicture.toText..style = Styles.ts_0C1C33_17sp,
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            value: 1,
            height: 30.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.video_collection,
                  color: Styles.c_0C1C33,
                  size: 16.w,
                ),
                10.horizontalSpace,
                StrRes.publishVideo.toText..style = Styles.ts_0C1C33_17sp,
              ],
            ),
          ),
        ],
        onSelected: logic.publish,
      );

  /* Widget _buildItemView(WorkMoments moments) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          border: BorderDirectional(
            bottom: BorderSide(
              color: Styles.c_E8EAEF,
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
                    ..style = Styles.ts_6085B1_17sp_medium,
                  // (moments.content?.text ?? '').toText..style = Styles.ts_0C1C33_17sp,
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
                      child: sprintf(StrRes.mentioned, [
                        moments.atUsers!.map((e) => e.userName).join('、')
                      ]).toText
                        ..style = Styles.ts_8E9AB0_12sp,
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
                            ..style = Styles.ts_8E9AB0_12sp,
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
                                        color: Styles.c_6085B1,
                                        size: 14.h,
                                      ),
                                      4.horizontalSpace,
                                      (moments.permission == 1
                                              ? StrRes.private
                                              : StrRes.partiallyVisible)
                                          .toText
                                        ..style = Styles.ts_6085B1_12sp,
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
                                  child: StrRes.delete.toText
                                    ..style = Styles.ts_6085B1_12sp,
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
                  color: Styles.c_6085B1,
                ),
              ),
            ),
            TextSpan(
              text: likeUsers.map((e) => e.userName).join('、'),
              style: Styles.ts_6085B1_12sp,
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
                    style: Styles.ts_6085B1_14sp,
                    children: [
                      if (e.replyUserName != null &&
                          e.replyUserName!.isNotEmpty)
                        TextSpan(
                          text: ' ${StrRes.reply} ',
                          style: Styles.ts_0C1C33_14sp,
                          children: [
                            TextSpan(
                              text: e.replyUserName,
                              style: Styles.ts_6085B1_14sp,
                            )
                          ],
                        ),
                      TextSpan(
                        text: '：${e.content}',
                        style: Styles.ts_0C1C33_14sp,
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
        color: Styles.c_F8F9FA,
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
            child: ImageRes.moreOp.toImage
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
                ImageRes.videoPause.toImage
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
        color: Styles.c_F0F2F6,
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
                  style: Styles.ts_0C1C33_17sp,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: logic.commentHintText.value,
                    hintStyle: Styles.ts_8E9AB0_17sp,
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
            ImageRes.sendMessage.toImage
              ..width = 32.w
              ..height = 32.h
              ..onTap = logic.submitComment,
          ],
        ),
      );
}
