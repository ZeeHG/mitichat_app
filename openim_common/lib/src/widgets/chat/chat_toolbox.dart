import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatToolBox extends StatelessWidget {
  const ChatToolBox({
    Key? key,
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
  }) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    final items = [
      if (null != onTapAlbum)
        ToolboxItemInfo(
          text: StrRes.toolboxAlbum,
          icon: ImageRes.appToolboxAlbum,
          onTap: () {
            if (Platform.isAndroid) {
              Permissions.requestStorage(onTapAlbum);
            } else {
              Permissions.photos(onTapAlbum);
            }
          },
        ),
      if (null != onTapCamera)
        ToolboxItemInfo(
          text: StrRes.toolboxCamera,
          icon: ImageRes.appToolboxCamera,
          onTap: () => Permissions.camera(onTapCamera),
        ),
      // if (null != onTapCall)
      //   ToolboxItemInfo(
      //     text: StrRes.toolboxCall,
      //     icon: ImageRes.appToolboxCall,
      //     // onTap: () => Permissions.cameraAndMicrophone(onTapCall),
      //     onTap: () => onTapCall!(),
      //     disabled: true,
      //   ),
      if (null != onTapLocation)
        ToolboxItemInfo(
          text: StrRes.toolboxLocation,
          icon: ImageRes.appToolboxLocation,
          onTap: () => Permissions.location(onTapLocation),
        ),
      if (null != onTapCard)
        ToolboxItemInfo(
            text: StrRes.toolboxCard,
            icon: ImageRes.appToolboxCard,
            onTap: onTapCard),
      if (null != onTapFile)
        ToolboxItemInfo(
          text: StrRes.toolboxFile,
          icon: ImageRes.appToolboxFile,
          onTap: () => Permissions.requestStorage(onTapFile),
        ),
      if (null != onTapAutoTranslate)
        ToolboxItemInfo(
          text: StrRes.autoTranslate,
          icon: ImageRes.appTranslate,
          onTap: () => onTapAutoTranslate!(),
        ),
      // 单聊
      if (null != onTapSnapchat)
        ToolboxItemInfo(
          text: StrRes.toolboxSnapchat,
          icon: ImageRes.appToolboxSnapchat,
          onTap: () => onTapSnapchat!(),
        ),
      // 群聊
      if (null != onTapGroupNote)
        ToolboxItemInfo(
          text: StrRes.toolboxGroupNote,
          icon: ImageRes.appToolboxGroupNote,
          onTap: () => onTapGroupNote!(),
          disabled: true,
        ),
      if (null != onTapVote)
        ToolboxItemInfo(
          text: StrRes.toolboxVote,
          icon: ImageRes.appToolboxVote,
          onTap: () => onTapVote!(),
          disabled: true,
        ),
    ];

    return Container(
      color: Styles.c_F7F7F7,
      height: 230.h,
      child: GridView.builder(
        itemCount: items.length,
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 20.h,
          bottom: 20.h,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 62.w / 75.h,
          // crossAxisSpacing: 10.w,
          // mainAxisSpacing: 29.h,
        ),
        itemBuilder: (_, index) {
          final item = items.elementAt(index);
          return _buildItemView(
              icon: item.icon,
              text: item.text,
              onTap: item.onTap,
              disabled: item.disabled ?? false);
        },
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
          required String icon,
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
                ),
                width: 62.w,
                height: 62.h,
                child: icon.toImage
                  ..width = 24.w
                  ..opacity = !disabled ? 1 : 0.4),
          ),
          // icon.toImage
          //   ..width = 24.w
          //   ..onTap = onTap,
          10.verticalSpace,
          text.toText..style = Styles.ts_666666_12sp,
        ],
      );
}

class ToolboxItemInfo {
  String text;
  String icon;
  Function()? onTap;
  bool? disabled;

  ToolboxItemInfo(
      {required this.text, required this.icon, this.onTap, this.disabled});
}
