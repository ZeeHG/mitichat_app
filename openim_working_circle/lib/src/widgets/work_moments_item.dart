import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import 'delete_comment_popmenu.dart';
import 'like_comment_popmenu.dart';

class WorkMomentsItem extends StatelessWidget {
  const WorkMomentsItem({
    Key? key,
    required this.moments,
    this.popMenuID = "",
    this.previewWhoCanWatchList,
    this.delMoment,
    this.replyComment,
    this.delComment,
    this.onPositionCallback,
    this.onTapLike,
    this.onTapComment,
    this.isLike = false,
    this.previewVideo,
    this.previewPicture,
    this.showLikeCommentPopMenu,
    this.onTapAvatar,
  }) : super(key: key);
  final WorkMoments moments;
  final String popMenuID;
  final Function(WorkMoments moments)? previewWhoCanWatchList;
  final Function(WorkMoments moments)? delMoment;
  final Function(WorkMoments moments, Comments comments)? replyComment;
  final Function(WorkMoments moments, Comments comments)? delComment;
  final Function(Offset position, Size size)? onPositionCallback;
  final Function(WorkMoments moments)? onTapLike;
  final Function(WorkMoments moments)? onTapComment;
  final bool isLike;
  final Function(String id)? showLikeCommentPopMenu;
  final Function(int index, List<Metas> metas)? previewPicture;
  final Function(String url, String? coverUrl)? previewVideo;
  final Function(WorkMoments moments)? onTapAvatar;

  // bool _isISendMoments() => moments.userID == OpenIM.iMManager.uid;
  //
  // bool _isISendComments(Comments comments) =>
  //     comments.userID == OpenIM.iMManager.uid;

  /// 非完全公开且我自己发的朋友圈，有权查看权限设置
  bool get _showPermissionIcon => moments.permission != 0 && moments.userID == OpenIM.iMManager.userID;

  /// 是我发的朋友圈可以删除
  bool get _showDelIcon => moments.userID == OpenIM.iMManager.userID;

  /// 是我发送的朋友圈，或者我发送的评论，可以删除评论
  bool _canDelComments(Comments c) => moments.userID == OpenIM.iMManager.userID || c.userID == OpenIM.iMManager.userID;

  ViewUserProfileBridge? get bridge => PackageBridge.viewUserProfileBridge;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            width: 48.w,
            height: 48.h,
            url: moments.faceURL,
            text: moments.nickname,
            onTap: () => onTapAvatar?.call(moments),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (moments.nickname ?? '').toText..style = Styles.ts_6085B1_17sp_medium,
                // (moments.content?.text ?? '').toText..style = Styles.ts_0C1C33_17sp,
                ExpandedText(text: moments.content?.text ?? ''),
                if (null != moments.content?.metas && moments.content!.metas!.isNotEmpty)
                  _buildMetaView(
                    moments.content?.type ?? 0,
                    moments.content?.metas ?? [],
                  ),
                if (null != moments.atUsers && moments.atUsers!.isNotEmpty) _buildMentionedView(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: [
                        _buildTimeView(),
                        if (_showPermissionIcon) _buildSeePermissionView(),
                        if (_showDelIcon) _buildDelView(),
                      ],
                    ),
                    _buildLikeCommentPopMenu(),
                  ],
                ),
                if (null != moments.likeUsers && moments.likeUsers!.isNotEmpty) _buildLikeListView(moments.likeUsers!),

                if (null != moments.comments && moments.comments!.isNotEmpty) _buildCommentListView(moments.userID!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDelView() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => delMoment?.call(moments),
        child: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Container(
            height: 26.h,
            alignment: Alignment.center,
            child: StrRes.delete.toText..style = Styles.ts_6085B1_12sp,
          ),
        ),
      );

  Widget _buildMentionedView() => Padding(
        padding: EdgeInsets.only(top: 6.h),
        child: sprintf(
            StrRes.mentioned, [moments.atUsers!.map((e) => IMUtils.getShowName(e.userID, e.nickname)).join('、')]).toText
          ..style = Styles.ts_8E9AB0_12sp,
      );

  Widget _buildTimeView() => TimelineUtil.format(
        (moments.createTime ?? 0),
        dayFormat: DayFormat.Full,
        locale: Get.locale?.languageCode ?? 'zh',
      ).toText
        ..style = Styles.ts_8E9AB0_12sp;

  Widget _buildSeePermissionView() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => previewWhoCanWatchList?.call(moments),
        child: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: SizedBox(
            height: 26.h,
            child: Row(
              children: [
                Icon(
                  moments.permission == 1 ? Icons.lock : Icons.group_rounded,
                  color: Styles.c_6085B1,
                  size: 14.h,
                ),
                4.horizontalSpace,
                (moments.permission == 1 ? StrRes.private : StrRes.partiallyVisible).toText
                  ..style = Styles.ts_6085B1_12sp,
              ],
            ),
          ),
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
            // TextSpan(
            //   text: likeUsers
            //       .map((e) => IMUtils.getShowName(e.userID, e.nickname))
            //       .join('、'),
            //   style: Styles.ts_6085B1_12sp,
            // ),
            ...likeUsers
                .map((e) => TextSpan(
                      text: IMUtils.getShowName(e.userID, e.nickname),
                      style: Styles.ts_6085B1_12sp,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => bridge?.viewUserProfile(
                              e.userID!,
                              e.nickname,
                              e.faceURL,
                            ),
                      children: [
                        if (likeUsers.last != e) TextSpan(text: '、', style: Styles.ts_0C1C33_12sp),
                      ],
                    ))
                .toList(),
          ],
        ),
      );

  Widget _buildCommentListView(String userID) {
    Widget buildItemView(Comments e) => CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 20.h,
          onPressed: () => replyComment?.call(moments, e),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: IMUtils.getShowName(e.userID, e.nickname),
                    style: Styles.ts_6085B1_14sp,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => bridge?.viewUserProfile(
                            e.userID!,
                            e.nickname,
                            e.faceURL,
                          ),
                    children: [
                      if (e.replyNickname != null && e.replyNickname!.isNotEmpty)
                        TextSpan(
                          text: ' ${StrRes.reply} ',
                          style: Styles.ts_0C1C33_14sp,
                          children: [
                            TextSpan(
                              text: IMUtils.getShowName(
                                e.replyUserID,
                                e.replyNickname,
                              ),
                              style: Styles.ts_6085B1_14sp,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => bridge?.viewUserProfile(
                                      e.replyUserID!,
                                      e.replyNickname,
                                      e.replyFaceURL,
                                    ),
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
            .map((e) => _canDelComments(e)
                ? DeleteCommentPopMenu(
                    child: buildItemView(e),
                    onTap: () => delComment?.call(moments, e),
                  )
                : buildItemView(e))
            .toList(),
      ),
    );
  }

  Widget _buildLikeCommentPopMenu() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          popMenuID == moments.workMomentID
              ? LikeCommentPopMenu(
                  onPositionCallback: onPositionCallback,
                  isLike: isLike,
                  onTapLike: () => onTapLike?.call(moments),
                  onTapComment: () => onTapComment?.call(moments),
                )
              : SizedBox(height: 26.h),
          // widget.showPopMenu ? _buildToolsView() : 26.verticalSpace,
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => showLikeCommentPopMenu?.call(moments.workMomentID!),
            child: ImageRes.moreOp.toImage
              ..width = 22.w
              ..height = 24.h,
          ),
        ],
      );

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
        final url = IMUtils.emptyStrToNull(meta.thumb) ?? meta.original;
        if (isPicture) {
          return Hero(
            tag: meta.original!,
            child: GestureDetector(
              onTap: () => previewPicture?.call(index, metas),
              child: ImageUtil.networkImage(url:
              IMUtils.isGif(url!)?meta.original!:
              url.thumbnailAbsoluteString, fit: BoxFit.cover),
            ),
          );
        }
        return Hero(
          tag: meta.original!,
          child: GestureDetector(
            onTap: () => previewVideo?.call(meta.original!, url),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ImageUtil.networkImage(url: url!.thumbnailAbsoluteString, fit: BoxFit.cover),
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
  }
}
