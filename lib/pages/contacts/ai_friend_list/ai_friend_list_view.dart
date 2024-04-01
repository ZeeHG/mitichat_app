import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'ai_friend_list_logic.dart';

class AiFriendListPage extends StatelessWidget {
  final logic = Get.find<AiFriendListLogic>();

  AiFriendListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.aiFriends),
      backgroundColor: Styles.c_FFFFFF,
      body: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: logic.searchAiFriend,
            child: Container(
              color: Styles.c_FFFFFF,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: FakeSearchBox(),
            ),
          ),
          Container(
            constraints: BoxConstraints(minWidth: 1.sw),
            color: Styles.c_FFFFFF,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(
                    left: 12.w, right: 12.w, top: 9.h, bottom: 20.h),
                child: Row(
                  children: List.generate(
                      logic.menus.length,
                      (index) => Row(
                            children: [
                              _menuItem(
                                  text: logic.menus[index]["text"],
                                  color: logic.menus[index]["color"],
                                  shadowColor: logic.menus[index]
                                      ["shadowColor"],
                                  onTap: logic.menus[index]["onTap"]),
                              27.horizontalSpace
                            ],
                          )),
                )),
          ),
          Flexible(
            child: Obx(
              () => AzList<ISUserInfo>(
                  data: logic.friendList,
                  itemCount: logic.friendList.length,
                  itemBuilder: (_, data, index) => _item(data),
                  firstTagPaddingColor: Styles.c_FFFFFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(ISUserInfo info) => Ink(
        height: 60.h,
        color: Styles.c_FFFFFF,
        child: InkWell(
          onTap: () => logic.viewFriendInfo(info),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                AvatarView(
                  url: info.faceURL,
                  text: info.showName,
                ),
                12.horizontalSpace,
                info.showName.toText..style = Styles.ts_333333_16sp,
              ],
            ),
          ),
        ),
      );

  Widget _menuItem({
    double? width,
    double? height,
    Color? color,
    TextStyle? tStyle,
    Color? shadowColor,
    int? badge,
    required String text,
    Function()? onTap,
  }) {
    width = width ?? 162.w;
    height = height ?? 50.h;
    color = color ?? Styles.c_8544F8;
    tStyle = tStyle ?? Styles.ts_FFFFFF_14sp_medium;
    shadowColor = shadowColor ?? Color.fromRGBO(132, 67, 248, 0.5);
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 9.r,
                      offset: Offset(0, 3.r),
                    ),
                  ],
                ),
                height: height,
                constraints: BoxConstraints(minWidth: width),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Center(
                  child: text.toText..style = tStyle,
                )),
            if (null != badge)
              Positioned(
                  top: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: const Offset(0, 0),
                    child: UnreadCountView(count: badge),
                  ))
          ],
        ));
  }
}
