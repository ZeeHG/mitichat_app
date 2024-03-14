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
    this.padding,
  }) : super(key: key);
  final WorkMoments moments;
  final String popMenuID;
  final EdgeInsetsGeometry? padding;
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
  bool get _showPermissionIcon =>
      moments.permission != 0 && moments.userID == OpenIM.iMManager.userID;

  /// 是我发的朋友圈可以删除
  bool get _showDelIcon => moments.userID == OpenIM.iMManager.userID;

  /// 是我发送的朋友圈，或者我发送的评论，可以删除评论
  bool _canDelComments(Comments c) =>
      moments.userID == OpenIM.iMManager.userID ||
      c.userID == OpenIM.iMManager.userID;

  ViewUserProfileBridge? get bridge => PackageBridge.viewUserProfileBridge;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          border: BorderDirectional(
            bottom: BorderSide(
              color: Styles.c_EDEDED,
              width: 1.h,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarView(
                  width: 44.w,
                  height: 44.h,
                  url: moments.faceURL,
                  text: moments.nickname,
                  onTap: () => onTapAvatar?.call(moments),
                ),
                10.horizontalSpace,
                SizedBox(
                  height: 44.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (moments.nickname ?? '').toText
                        ..style = Styles.ts_9280B3_16sp_medium
                        ..onTap = () => onTapAvatar?.call(moments),
                      _buildTimeView(),
                    ],
                  ),
                ),
                Spacer(),
                _buildLikeCommentPopMenu(),
              ],
            ),
            if ("" != moments.content?.text) ...[
              12.verticalSpace,
              ExpandedText(
                text: moments.content!.text!,
                textStyle: Styles.ts_333333_16sp,
              ),
            ],
            if (null != moments.content?.metas &&
                moments.content!.metas!.isNotEmpty)
              _buildMetaView(
                moments.content?.type ?? 0,
                moments.content?.metas ?? [],
              ),
            if (null != moments.atUsers && moments.atUsers!.isNotEmpty) ...[
              _buildMentionedView(),
            ],
            if (_showPermissionIcon || _showDelIcon)
              Row(
                children: [
                  if (_showPermissionIcon) _buildSeePermissionView(),
                  if (_showPermissionIcon) 10.horizontalSpace,
                  if (_showDelIcon) _buildDelView(),
                ],
              ),
            if ((null != moments.likeUsers && moments.likeUsers!.isNotEmpty) ||
                (null != moments.comments && moments.comments!.isNotEmpty))
              10.verticalSpace,
            if (null != moments.likeUsers && moments.likeUsers!.isNotEmpty)
              _buildLikeListView(moments.likeUsers!),
            if (null != moments.likeUsers &&
                moments.likeUsers!.isNotEmpty &&
                null != moments.comments &&
                moments.comments!.isNotEmpty)
              Divider(
                color: Styles.c_EDEDED,
                height: 1.h,
              ),
            if (null != moments.comments && moments.comments!.isNotEmpty)
              _buildCommentListView(moments.userID!),
          ],
        ));
  }

  Widget _buildDelView() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => delMoment?.call(moments),
        child: Padding(
          padding: EdgeInsets.only(left: 0),
          child: Container(
            height: 26.h,
            alignment: Alignment.center,
            child: StrLibrary.delete.toText..style = Styles.ts_8443F8_12sp,
          ),
        ),
      );

  Widget _buildMentionedView() => Padding(
        padding: EdgeInsets.only(top: 9.h),
        child: sprintf(StrLibrary.mentioned, [
          moments.atUsers!
              .map((e) => IMUtils.getShowName(e.userID, e.nickname))
              .join('、')
        ]).toText
          ..style = Styles.ts_999999_12sp,
      );

  Widget _buildTimeView() => TimelineUtil.format(
        (moments.createTime ?? 0),
        dayFormat: DayFormat.Full,
        locale: Get.locale?.languageCode ?? 'zh',
      ).toText
        ..style = Styles.ts_999999_12sp;

  Widget _buildSeePermissionView() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => previewWhoCanWatchList?.call(moments),
        child: Padding(
          padding: EdgeInsets.only(left: 0),
          child: SizedBox(
            height: 26.h,
            child: Row(
              children: [
                Icon(
                  moments.permission == 1 ? Icons.lock : Icons.group_rounded,
                  color: Styles.c_8443F8,
                  size: 14.h,
                ),
                4.horizontalSpace,
                (moments.permission == 1
                        ? StrLibrary.private
                        : StrLibrary.partiallyVisible)
                    .toText
                  ..style = Styles.ts_8443F8_12sp,
              ],
            ),
          ),
        ),
      );

  Widget _buildLikeListView(List<LikeUsers> likeUsers) => Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        color: Styles.c_F7F7F7,
        child: Row(children: [
          ImageRes.appLike.toImage
            ..width = 12.w
            ..height = 11.h,
          6.horizontalSpace,
          Expanded(
              child: RichText(
            text: TextSpan(
              children: [
                ...likeUsers
                    .map((e) => TextSpan(
                          text: IMUtils.getShowName(e.userID, e.nickname),
                          style: Styles.ts_9280B3_14sp_medium,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => bridge?.viewUserProfile(
                                  e.userID!,
                                  e.nickname,
                                  e.faceURL,
                                ),
                          children: [
                            if (likeUsers.last != e)
                              TextSpan(
                                  text: '、',
                                  style: Styles.ts_9280B3_14sp_medium),
                          ],
                        ))
                    .toList(),
              ],
            ),
          )),
        ]),
      );

  Widget _buildCommentListView(String userID) {
    Widget buildItemView(Comments e) => CupertinoButton(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          minSize: 20.h,
          onPressed: () => replyComment?.call(moments, e),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: IMUtils.getShowName(e.userID, e.nickname),
                    style: Styles.ts_9280B3_14sp_medium,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => bridge?.viewUserProfile(
                            e.userID!,
                            e.nickname,
                            e.faceURL,
                          ),
                    children: [
                      if (e.replyNickname != null &&
                          e.replyNickname!.isNotEmpty)
                        TextSpan(
                          text: ' ${StrLibrary.reply} ',
                          style: Styles.ts_333333_14sp,
                          children: [
                            TextSpan(
                              text: IMUtils.getShowName(
                                e.replyUserID,
                                e.replyNickname,
                              ),
                              style: Styles.ts_9280B3_14sp_medium,
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
                          text: '：',
                          style: Styles.ts_9280B3_14sp_medium,
                          children: [
                            TextSpan(
                              text: '${e.content}',
                              style: Styles.ts_333333_14sp,
                            )
                          ]),
                    ],
                  ),
                ),
              )
            ],
          ),
        );

    // 是我发的朋友圈或者是我评论的，可以删除
    return Container(
      // margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.r),
        color: Styles.c_F7F7F7,
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
              child: ImageRes.appDiscoverOperation.toImage
                ..width = 24.w
                ..height = 16.h),
        ],
      );

  /// 图/视频正文
  /// [type] 0:picture  1:video
  Widget _buildMetaView(int type, List<Metas> metas) {
    if (metas.length == 1) {
      final isPicture = type == 0;
      final meta = metas.elementAt(0);
      final url = IMUtils.emptyStrToNull(meta.thumb) ?? meta.original;
      return Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: isPicture
                ? Hero(
                    tag: meta.original!,
                    child: GestureDetector(
                      onTap: () => previewPicture?.call(0, metas),
                      child: ImageUtil.networkImage(
                          url: IMUtils.isGif(url!)
                              ? meta.original!
                              : url.thumbnailAbsoluteString,
                          fit: BoxFit.cover),
                    ),
                  )
                : Hero(
                    tag: meta.original!,
                    child: GestureDetector(
                      onTap: () => previewVideo?.call(meta.original!, url),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ImageUtil.networkImage(
                              url: url!.thumbnailAbsoluteString,
                              fit: BoxFit.cover),
                          ImageRes.videoPause.toImage
                            ..width = 40.w
                            ..height = 40.h,
                        ],
                      ),
                    ),
                  ),
          ));
    } else {
      return GridView.builder(
        padding: EdgeInsets.only(top: 12.h),
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
            return ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: Hero(
                  tag: meta.original!,
                  child: GestureDetector(
                    onTap: () => previewPicture?.call(index, metas),
                    child: ImageUtil.networkImage(
                        url: IMUtils.isGif(url!)
                            ? meta.original!
                            : url.thumbnailAbsoluteString,
                        fit: BoxFit.cover),
                  ),
                ));
          }
          return ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: Hero(
                tag: meta.original!,
                child: GestureDetector(
                  onTap: () => previewVideo?.call(meta.original!, url),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ImageUtil.networkImage(
                          url: url!.thumbnailAbsoluteString, fit: BoxFit.cover),
                      ImageRes.videoPause.toImage
                        ..width = 40.w
                        ..height = 40.h,
                    ],
                  ),
                ),
              ));
        },
        itemCount: metas.length,
      );
    }
  }
}
