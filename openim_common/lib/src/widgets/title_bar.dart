import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar(
      {Key? key,
      this.height,
      this.left,
      this.center,
      this.right,
      this.bottom,
      this.backgroundColor,
      this.backgroundImage,
      this.backIconColor,
      this.showUnderline = false,
      EdgeInsetsGeometry? padding,
      this.overBottomBg})
      : 
      super(key: key);
  final double? height;
  final Widget? left;
  final Widget? center;
  final Widget? right;
  final Widget? bottom;
  final Color? backgroundColor;
  final Color? backIconColor;
  final DecorationImage? backgroundImage;
  final bool showUnderline;
  final Widget? overBottomBg;
  final EdgeInsetsGeometry? padding = null;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: null == overBottomBg
          ? Container(
              decoration: BoxDecoration(
                  color: backgroundColor ?? Styles.c_FFFFFF,
                  image: backgroundImage),
              padding: EdgeInsets.only(top: mq.padding.top),
              child: Container(
                height: height,
                padding: padding ?? EdgeInsets.symmetric(horizontal: 12.w),
                decoration: showUnderline
                    ? BoxDecoration(
                        border: BorderDirectional(
                          bottom:
                              BorderSide(color: Styles.c_E8EAEF, width: 1.h),
                        ),
                      )
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        if (null != left) left!,
                        if (null != center) center!,
                        if (null != right) right!,
                      ],
                    ),
                    if (null != bottom) bottom!,
                  ],
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? Styles.c_FFFFFF,
              ),
              // padding: EdgeInsets.only(top: mq.padding.top),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (null != bottom) bottom!,
                  overBottomBg!,
                  Positioned(
                      top: mq.padding.top,
                      child: Container(
                        width: 1.sw,
                        padding: EdgeInsets.only(left: 12.w, right: 12.w),
                        child: Row(
                          children: [
                            if (null != left) left!,
                            if (null != center) center!,
                            if (null != right) right!,
                          ],
                        ),
                      ))
                ],
              ),
            ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 44.h);

  TitleBar.conversation(
      {super.key,
      String? statusStr,
      bool isFailed = false,
      MediaQueryData? mq,
      this.backgroundImage,
      this.left,
      Function()? onScan,
      Function()? onAddFriend,
      Function()? onAddGroup,
      Function()? onCreateGroup,
      // Function()? onVideoMeeting,
      Function()? onClickSearch,
      required Function(dynamic) onSwitchTab,
      required RxInt homeTabIndex,
      RxInt? unhandledCount,
      CustomPopupMenuController? popCtrl,
      // this.left,
      this.backIconColor})
      : backgroundColor = Styles.c_F7F8FA,
        showUnderline = false,
        height = 105.h,
        overBottomBg = IgnorePointer(
            ignoring: true,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image:
                    AssetImage(ImageRes.appHeaderBg3, package: 'openim_common'),
                fit: BoxFit.cover,
                alignment: FractionalOffset.topCenter,
              )),
            )),
        bottom = Positioned(
          top: (mq?.padding.top ?? 30.h) + 55.h,
          child: FakeSearchBox(
              onTap: onClickSearch, color: Styles.c_FFFFFF, borderRadius: 18.r),
        ),
        // left = SizedBox(width: 28.w),
        center = Expanded(
          child: Center(
            child: CustomTabBar(
                width: 100.w,
                labels: [StrRes.chat, StrRes.friend],
                counts: [0.obs, unhandledCount ?? 0.obs],
                index: homeTabIndex.value,
                onTabChanged: (i) => onSwitchTab(i),
                showUnderline: false,
                bgColor: Styles.transparent,
                inactiveTextStyle: Styles.ts_4B3230_18sp,
                activeTextStyle: Styles.ts_4B3230_20sp_medium,
                indicatorWidth: 20.w),
          ),
        ),
        // center=null,
        right = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopButton(
              popCtrl: popCtrl,
              menus: [
                PopMenuInfo(
                  text: StrRes.scan,
                  icon: ImageRes.appPopMenuScan,
                  onTap: onScan,
                ),
                PopMenuInfo(
                  text: StrRes.addFriend,
                  icon: ImageRes.appPopMenuAddFriend,
                  onTap: onAddFriend,
                ),
                PopMenuInfo(
                  text: StrRes.addGroup,
                  icon: ImageRes.appPopMenuAddGroup,
                  onTap: onAddGroup,
                ),
                PopMenuInfo(
                  text: StrRes.createGroup,
                  icon: ImageRes.appPopMenuCreateGroup,
                  onTap: onCreateGroup,
                ),
                // PopMenuInfo(
                //   text: StrRes.videoMeeting,
                //   icon: ImageRes.appPopMenuVideoMeeting,
                //   onTap: onVideoMeeting,
                // ),
              ],
              child: Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: ImageRes.appAddBlack2.toImage
                  ..width = 28.w
                  ..height = 28.h,
              ) /*..onTap = onClickAddBtn*/,
            ),
          ],
        );

  TitleBar.newDiscover(
      {super.key,
      Function()? onScan,
      Function()? onTapLeft,
      CustomPopupMenuController? popCtrl,
      this.backgroundImage,
      this.center,
      bool showBottom = true,
      MediaQueryData? mq})
      : backgroundColor = Styles.c_FFFFFF,
        backIconColor = null,
        showUnderline = false,
        height = showBottom ? 105.h : 50.h,
        overBottomBg = IgnorePointer(
            ignoring: true,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image:
                    AssetImage(ImageRes.appHeaderBg3, package: 'openim_common'),
                fit: BoxFit.cover,
                alignment: FractionalOffset.topCenter,
              )),
            )),
        bottom = showBottom
            ? Positioned(
                top: (mq?.padding.top ?? 30.h) + 55.h,
                child: FakeSearchBox(
                  borderRadius: 18.r,
                ),
              )
            : null,
        left = Container(
            child: ImageRes.appChat2.toImage
              ..width = 22.w
              ..height = 22.h
              ..onTap = onTapLeft),
        right = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopButton(
              popCtrl: popCtrl,
              menus: [
                PopMenuInfo(
                  text: StrRes.scan,
                  icon: ImageRes.appPopMenuScan,
                  onTap: onScan,
                )
              ],
              child: ImageRes.appAddBlack.toImage
                ..width = 22.w
                ..height = 22.h /*..onTap = onClickAddBtn*/,
            ),
          ],
        );

  TitleBar.chat(
      {super.key,
      String? title,
      String? member,
      String? subTitle,
      bool isAiSingleChat = false,
      bool showOnlineStatus = false,
      bool isOnline = false,
      bool isMultiModel = false,
      this.overBottomBg,
      // bool showCallBtn = true,
      bool showBotBtn = true,
      // Function()? onClickCallBtn,
      Function()? onClickMoreBtn,
      Function()? onCloseMultiModel,
      this.bottom,
      this.backIconColor,
      this.backgroundImage})
      : backgroundColor = null,
        height = 48.h,
        showUnderline = true,
        // center = Flexible(
        //     child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     if (null != title)
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Flexible(
        //               flex: 5,
        //               child: Container(
        //                 child: title.trim().toText
        //                   ..style = Styles.ts_333333_17sp_semibold
        //                   ..maxLines = 1
        //                   ..overflow = TextOverflow.ellipsis
        //                   ..textAlign = TextAlign.center,
        //               )),
        //           if (null != member)
        //             Flexible(
        //                 flex: 2,
        //                 child: Container(
        //                     child: member.toText
        //                       ..style = Styles.ts_333333_17sp_semibold
        //                       ..maxLines = 1))
        //         ],
        //       ),
        //     if (subTitle?.isNotEmpty == true)
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           if (showOnlineStatus)
        //             Container(
        //               width: 6.w,
        //               height: 6.h,
        //               margin: EdgeInsets.only(right: 4.w),
        //               decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 color: isOnline ? Styles.c_18E875 : Styles.c_999999,
        //               ),
        //             ),
        //           subTitle!.toText..style = Styles.ts_999999_10sp,
        //         ],
        //       ),
        //   ],
        // )),
        center = 0.horizontalSpace,
        left = Expanded(
            // flex: 1,
            child: isMultiModel
                ? (StrRes.cancel.toText
                  ..style = Styles.ts_333333_17sp
                  ..onTap = onCloseMultiModel)
                : Row(children: [
                    ImageRes.appBackBlack.toImage
                      ..width = 24.w
                      ..height = 24.h
                      ..onTap = (() => Get.back()),
                    SizedBox(width: 12.w),
                    if (null != title) ...[
                      title.trim().toText
                        ..style = Styles.ts_333333_18sp_medium
                        ..maxLines = 1
                        ..overflow = TextOverflow.ellipsis
                        ..textAlign = TextAlign.center,
                      if (isAiSingleChat) ...[
                        9.horizontalSpace,
                        ImageRes.appAiMarker.toImage
                          ..width = 18.w
                          ..height = 16.h,
                      ]
                    ],
                    if (null != member)
                      member.toText
                        ..style = Styles.ts_333333_18sp_medium
                        ..maxLines = 1
                  ])),
        right = SizedBox(
            // width: 16.w + (showCallBtn ? 56.w : 28.w),
            // width: 29.w + (showBotBtn ? 56.w : 28.w),
            width: 24.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if (showCallBtn)
                //   ImageRes.callBack.toImage
                //     ..width = 28.w
                //     ..height = 28.h
                //     ..onTap = onClickCallBtn,
                // if (showBotBtn)
                //   ImageRes.botBtn.toImage
                //     ..width = 26.w
                //     ..height = 20.h,
                // 29.horizontalSpace,
                ImageRes.appMoreBlack.toImage
                  ..width = 24.w
                  ..height = 24.h
                  ..onTap = onClickMoreBtn,
              ],
            ));

  TitleBar.back(
      {super.key,
      String? title,
      String? leftTitle,
      TextStyle? titleStyle,
      TextStyle? leftTitleStyle,
      String? result,
      Color? backgroundColor,
      bool hideBack = false,
      this.overBottomBg,
      this.backIconColor,
      Widget? right,
      this.showUnderline = false,
      Function()? onTap,
      this.bottom,
      this.backgroundImage})
      : height = 44.h,
        backgroundColor = backgroundColor ?? Styles.c_FFFFFF,
        center = Expanded(
            child: (title ?? '').toText
              ..style = (titleStyle ?? Styles.ts_333333_18sp_medium)
              ..textAlign = TextAlign.center),
        left = hideBack
            ? null
            : GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onTap ?? (() => Get.back(result: result)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageRes.appBackBlack.toImage
                      ..width = 24.w
                      ..height = 24.h
                      ..color = backIconColor,
                    if (null != leftTitle)
                      leftTitle.toText
                        ..style =
                            (leftTitleStyle ?? Styles.ts_333333_17sp_semibold),
                  ],
                ),
              ),
        right = right ??
            SizedBox(
              width: 24.w,
            );

  TitleBar.discover(
      {super.key,
      String? title,
      String? leftTitle,
      TextStyle? titleStyle,
      TextStyle? leftTitleStyle,
      String? result,
      this.backgroundColor,
      this.overBottomBg,
      this.backIconColor,
      this.right,
      this.showUnderline = false,
      Function()? onTap,
      this.bottom,
      this.backgroundImage})
      : height = 44.h,
        center = Expanded(
            child: (title ?? '').toText
              ..style = (titleStyle ?? Styles.ts_FFFFFF_17sp_semibold)
              ..textAlign = TextAlign.center),
        left = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap ?? (() => Get.back(result: result)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageRes.appBackBlack.toImage
                ..width = 24.w
                ..height = 24.h
                ..color = backIconColor ?? Styles.c_FFFFFF,
              if (null != leftTitle)
                leftTitle.toText
                  ..style = (leftTitleStyle ?? Styles.ts_333333_17sp_semibold),
            ],
          ),
        );

  TitleBar.contacts(
      {super.key,
      this.showUnderline = false,
      // Function()? onClickSearch,
      // Function()? onClickAddContacts,
      Function()? onClickSearch,
      required Function(dynamic) onSwitchTab,
      required RxInt homeTabIndex,
      CustomPopupMenuController? popCtrl,
      Function()? onScan,
      Function()? onAddFriend,
      Function()? onAddGroup,
      Function()? onCreateGroup,
      // Function()? onVideoMeeting,
      this.backIconColor,
      RxInt? unhandledCount,
      MediaQueryData? mq,
      this.backgroundImage})
      : backgroundColor = Styles.c_FFFFFF,
        height = 105.h,
        overBottomBg = IgnorePointer(
            ignoring: true,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image:
                    AssetImage(ImageRes.appHeaderBg3, package: 'openim_common'),
                fit: BoxFit.cover,
                alignment: FractionalOffset.topCenter,
              )),
            )),
        bottom = Positioned(
          top: (mq?.padding.top ?? 30.h) + 55.h,
          child: FakeSearchBox(
            onTap: onClickSearch,
            borderRadius: 18.r,
          ),
        ),
        center = Expanded(
          child: Center(
            child: CustomTabBar(
                width: 100.w,
                counts: [0.obs, unhandledCount ?? 0.obs],
                labels: [StrRes.chat, StrRes.friend],
                index: homeTabIndex.value,
                onTabChanged: (i) => onSwitchTab(i),
                showUnderline: false,
                bgColor: Styles.transparent,
                inactiveTextStyle: Styles.ts_4B3230_18sp,
                activeTextStyle: Styles.ts_4B3230_20sp_medium,
                indicatorWidth: 20.w),
          ),
        ),
        left = SizedBox(
          width: 40.w,
          height: 40.h,
        ),
        // right = Row(
        //   children: [
        //     12.horizontalSpace,
        //     ImageRes.appAddContacts.toImage
        //       ..width = 28.w
        //       ..height = 28.h
        //       ..onTap = onClickAddContacts,
        //   ],
        // ),
        right = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopButton(
              popCtrl: popCtrl,
              menus: [
                PopMenuInfo(
                  text: StrRes.scan,
                  icon: ImageRes.appPopMenuScan,
                  onTap: onScan,
                ),
                PopMenuInfo(
                  text: StrRes.addFriend,
                  icon: ImageRes.appPopMenuAddFriend,
                  onTap: onAddFriend,
                ),
                PopMenuInfo(
                  text: StrRes.addGroup,
                  icon: ImageRes.appPopMenuAddGroup,
                  onTap: onAddGroup,
                ),
                PopMenuInfo(
                  text: StrRes.createGroup,
                  icon: ImageRes.appPopMenuCreateGroup,
                  onTap: onCreateGroup,
                ),
                // PopMenuInfo(
                //   text: StrRes.videoMeeting,
                //   icon: ImageRes.appPopMenuVideoMeeting,
                //   onTap: onVideoMeeting,
                // ),
              ],
              child: Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: ImageRes.appAddBlack2.toImage
                  ..width = 28.w
                  ..height = 28.h,
              ) /*..onTap = onClickAddBtn*/,
            ),
          ],
        );

  TitleBar.workbench(
      {super.key,
      this.showUnderline = false,
      this.bottom,
      this.overBottomBg,
      this.backIconColor,
      this.backgroundImage})
      : height = 44.h,
        backgroundColor = Styles.c_FFFFFF,
        center = null,
        left = StrRes.workbench.toText..style = Styles.ts_333333_20sp_semibold,
        right = null;

  TitleBar.search(
      {super.key,
      String? hintText,
      TextEditingController? controller,
      FocusNode? focusNode,
      bool autofocus = true,
      this.showUnderline = true,
      this.backIconColor,
      Function(String)? onSubmitted,
      Function()? onCleared,
      ValueChanged<String>? onChanged,
      this.bottom,
      this.overBottomBg,
      this.backgroundImage})
      : height = 44.h,
        backgroundColor = Styles.c_FFFFFF,
        center = Expanded(
          child: Container(
              child: SearchBox(
            enabled: true,
            autofocus: autofocus,
            hintText: hintText,
            controller: controller,
            focusNode: focusNode,
            onSubmitted: onSubmitted,
            onCleared: onCleared,
            onChanged: onChanged,
          )),
        ),
        left = null,
        right = Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: StrRes.cancel.toText
            ..style = Styles.ts_9280B3_16sp
            ..onTap = (() => Get.back()),
        );

  TitleBar.trainAi(
      {super.key,
      this.overBottomBg,
      this.bottom,
      this.left,
      this.backIconColor,
      this.right,
      this.backgroundColor,
      this.backgroundImage})
      : height = 48.h,
        showUnderline = false,
        center = 0.horizontalSpace;

  TitleBar.xhsMomentDetail(
      {super.key,
      this.overBottomBg,
      this.bottom,
      this.left,
      this.backIconColor,
      this.right,
      this.backgroundColor,
      this.backgroundImage})
      : height = 48.h,
        showUnderline = false,
        center = 0.horizontalSpace;
}
