import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ChatToolBox extends StatelessWidget {
  ChatToolBox(
      {Key? key,
      this.onTapAlbum,
      this.onTapCall,
      this.onTapCamera,
      this.onTapCard,
      this.onTapFile,
      this.onTapAutoTranslate,
      this.onTapLocation,
      this.onTapSnapchat,
      this.onTapGroupNote,
      this.onTapVote,
      this.onTapSearch})
      : super(key: key);
  final Function()? onTapAlbum;
  final Function()? onTapCamera;
  final Function()? onTapCall;
  final Function()? onTapFile;
  final Function()? onTapAutoTranslate;
  final Function()? onTapCard;
  final Function()? onTapLocation;
  final Function()? onTapSnapchat;
  final Function()? onTapGroupNote;
  final Function()? onTapVote;
  final Function()? onTapSearch;

  final PageController pageController = PageController();

  List<List<T>> chunkArray<T>(List<T> sourceArray, int chunkSize) {
    List<List<T>> chunks = [];

    for (int i = 0; i < sourceArray.length; i += chunkSize) {
      int end = (i + chunkSize < sourceArray.length)
          ? i + chunkSize
          : sourceArray.length;
      chunks.add(sourceArray.sublist(i, end));
    }

    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      if (null != onTapAlbum)
        ToolboxItemInfo(
          text: StrRes.toolboxAlbum,
          icon: ImageRes.appToolboxAlbum.toImage
            ..width = 24.w
            ..height = 24.h,
          onTap: () {
            if (Platform.isAndroid) {
              Permissions.storage(
                  permissions: [Permission.photos, Permission.videos],
                  onTapAlbum);
            } else {
              Permissions.photos(onTapAlbum);
            }
          },
        ),
      if (null != onTapCamera)
        ToolboxItemInfo(
          text: StrRes.toolboxCamera,
          icon: ImageRes.appToolboxCamera.toImage
            ..width = 26.w
            ..height = 22.h,
          onTap: () => Permissions.camera(onTapCamera),
        ),
      if (null != onTapCall)
        ToolboxItemInfo(
          text: StrRes.toolboxCall,
          icon: ImageRes.appToolboxCall.toImage
            ..width = 30.w
            ..height = 18.h,
          onTap: () => Permissions.cameraAndMicrophone(onTapCall),
        ),
      if (null != onTapLocation)
        ToolboxItemInfo(
          text: StrRes.toolboxLocation,
          icon: ImageRes.appToolboxLocation.toImage
            ..width = 22.w
            ..height = 26.h,
          onTap: () => Permissions.location(onTapLocation),
        ),
      if (null != onTapCard)
        ToolboxItemInfo(
            text: StrRes.toolboxCard,
            icon: ImageRes.appToolboxCard.toImage
              ..width = 30.w
              ..height = 22.h,
            onTap: onTapCard),
      if (null != onTapFile)
        ToolboxItemInfo(
          text: StrRes.toolboxFile,
          icon: ImageRes.appToolboxFile.toImage
            ..width = 30.w
            ..height = 22.h,
          onTap: () => Permissions.storage(
              permissions: [Permission.photos, Permission.videos], onTapFile),
        ),
      if (null != onTapAutoTranslate)
        ToolboxItemInfo(
          text: StrRes.autoTranslate,
          icon: ImageRes.appTranslate.toImage
            ..width = 28.w
            ..height = 25.h,
          onTap: () => onTapAutoTranslate!(),
        ),
      // 单聊
      if (null != onTapSnapchat)
        ToolboxItemInfo(
          text: StrRes.toolboxSnapchat,
          icon: ImageRes.appToolboxSnapchat.toImage
            ..width = 30.w
            ..height = 24.h,
          onTap: () => onTapSnapchat!(),
        ),

      if (null != onTapSearch)
        ToolboxItemInfo(
          text: StrRes.search2,
          icon: ImageRes.appToolboxSearch.toImage
            ..width = 26.w
            ..height = 26.h,
          onTap: () => onTapSearch!(),
        ),

      // 群聊
      // if (null != onTapGroupNote)
      //   ToolboxItemInfo(
      //     text: StrRes.toolboxGroupNote,
      //     icon: ImageRes.appToolboxGroupNote,
      //     onTap: () => onTapGroupNote!(),
      //     disabled: true,
      //   ),
      if (null != onTapVote)
        ToolboxItemInfo(
          text: StrRes.toolboxVote,
          icon: ImageRes.appToolboxVote.toImage..width=24.w..height=24.h,
          onTap: () => onTapVote!(),
          disabled: true,
        ),
    ];
    final pages = chunkArray(items, 8);

    return Container(
      color: Styles.c_F7F7F7,
      height: 240.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: pages.length,
            itemBuilder: (context, i) {
              return GridView.builder(
                itemCount: pages[i].length,
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 10.h,
                  bottom: 30.h,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 62.w / 75.h,
                  // crossAxisSpacing: 10.w,
                  // mainAxisSpacing: 29.h,
                ),
                itemBuilder: (_, index) {
                  final item = pages[i].elementAt(index);
                  return _buildItemView(
                      icon: item.icon,
                      text: item.text,
                      onTap: item.onTap,
                      disabled: item.disabled ?? false);
                },
              );
            },
          ),
          Positioned(
              bottom: 15.h,
              child: Container(
                width: 1.sw,
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                  controller: pageController, // PageController
                  count: pages.length,
                  effect: SlideEffect(
                      spacing: 10.w,
                      radius: 4.r,
                      dotWidth: 8.w,
                      dotHeight: 8.h,
                      paintStyle: PaintingStyle.fill,
                      strokeWidth: 1,
                      dotColor: Styles.c_DDDDDD,
                      activeDotColor: Styles.c_767676), // your preferred effect
                ),
              )),
        ],
      ),
      // child: Column(
      //   children: [
      //     Row(
      //       children: [
      //         _buildItemView(
      //             text: StrRes.toolboxAlbum,
      //             icon: ImageRes.appToolboxAlbum,
      //             onTap: onTapAlbum),
      //         30.horizontalSpace,
      //         _buildItemView(
      //             text: StrRes.toolboxCamera,
      //             icon: ImageRes.appToolboxCamera,
      //             onTap: onTapCamera),
      //         30.horizontalSpace,
      //         _buildItemView(
      //             text: StrRes.toolboxCall,
      //             icon: ImageRes.appToolboxCall,
      //             onTap: onTapCall),
      //         30.horizontalSpace,
      //         _buildItemView(
      //             text: StrRes.toolboxFile,
      //             icon: ImageRes.appToolboxFile,
      //             onTap: onTapFile),
      //       ],
      //     ),
      //     22.verticalSpace,
      //     Row(
      //       children: [
      //         _buildItemView(
      //             text: StrRes.toolboxCard,
      //             icon: ImageRes.appToolboxCard,
      //             onTap: onTapCard),
      //         30.horizontalSpace,
      //         _buildItemView(
      //             text: StrRes.toolboxLocation,
      //             icon: ImageRes.appToolboxLocation,
      //             onTap: onTapLocation),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildItemView(
          {required String text,
          required ImageView icon,
          Function()? onTap,
          bool disabled = false}) =>
      Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: !disabled ? Styles.c_FFFFFF : Styles.c_E5E5E5,
                    borderRadius: BorderRadius.all(Radius.circular(31.r))),
                width: 62.w,
                height: 62.h,
                child: icon..opacity = !disabled ? 1 : 0.4),
          ),
          // icon.toImage
          //   ..width = 24.w
          //   ..onTap = onTap,
          10.verticalSpace,
          text.toText
            ..style = Styles.ts_666666_12sp
            ..maxLines = 1
            ..overflow = TextOverflow.ellipsis,
        ],
      );
}

class ToolboxItemInfo {
  String text;
  ImageView icon;
  Function()? onTap;
  bool? disabled;

  ToolboxItemInfo(
      {required this.text, required this.icon, this.onTap, this.disabled});
}
