import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:miti_common/miti_common.dart';

class MenuInfo {
  String icon;
  String text;
  Function()? onTap;
  bool enabled;

  MenuInfo({
    required this.icon,
    required this.text,
    this.onTap,
    this.enabled = true,
  });
}

class ChatLongPressMenu extends StatelessWidget {
  final CustomPopupMenuController? popupMenuController;
  final List<MenuInfo> menus;

  const ChatLongPressMenu({
    Key? key,
    required this.popupMenuController,
    required this.menus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // menus.removeWhere((element) => !element.enabled);
    // final count = menus.length < 5 ? menus.length : 5;
    return Container(
      constraints: BoxConstraints(maxWidth: 256.w, maxHeight: 122.h),
      decoration: BoxDecoration(
        color: StylesLibrary.c_333333_opacity85,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(15.w, 6.h, 15.w, 3.h),
        child: Wrap(
          // runSpacing: 4.h,
          // spacing: 4.w,
          children: menus
              .map((e) => _menuItem(
                    icon: e.icon,
                    label: e.text,
                    onTap: e.onTap,
                  ))
              .toList(),
        ),
      ),
      /*child: GridView.count(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
        crossAxisCount: count,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.h,
        childAspectRatio: 42 / 52,
        children: menus
            .map((e) => _menuItem(
                  icon: e.icon,
                  label: e.text,
                  onTap: e.onTap,
                ))
            .toList(),
      ),*/
    );
  }

  Widget _menuItem({
    required String icon,
    required String label,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: () {
          popupMenuController?.hideMenu();
          onTap?.call();
        },
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          width: 42.w,
          height: 52.h,
          // constraints: BoxConstraints(
          //   // maxWidth: 42.w,
          //   // maxHeight: 52.h,
          // ),
          child: _MenuItemView(icon: icon, label: label),
        ),
        /*child: SizedBox(
          width: 42.w,
          height: 52.h,
          child: _MenuItemView(icon: icon, label: label),
        ),*/
      );
}

class _MenuItemView extends StatelessWidget {
  const _MenuItemView({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        icon.toImage
          ..width = 28.w
          ..height = 28.h,
        label.toText
          ..style = StylesLibrary.ts_FFFFFF_10sp
          ..maxLines = 1
          ..overflow = TextOverflow.ellipsis,
      ],
    );
  }
}

final allMenus = <MenuInfo>[
  MenuInfo(
    icon: ImageLibrary.menuCopy,
    text: StrLibrary.menuCopy,
    onTap: () {},
  ),
  MenuInfo(
    icon: ImageLibrary.menuDel,
    text: StrLibrary.menuDel,
    onTap: () {},
  ),
  MenuInfo(
    icon: ImageLibrary.menuForward,
    text: StrLibrary.menuForward,
    onTap: () {},
  ),
  MenuInfo(
    icon: ImageLibrary.menuReply,
    text: StrLibrary.menuReply,
    onTap: () {},
  ),
  MenuInfo(
    icon: ImageLibrary.menuMulti,
    text: StrLibrary.menuMulti,
    onTap: () {},
  ),
  MenuInfo(
    icon: ImageLibrary.menuRevoke,
    text: StrLibrary.menuRevoke,
    onTap: () {},
  ),
  MenuInfo(
    icon: ImageLibrary.menuAddFace,
    text: StrLibrary.menuAdd,
    onTap: () {},
  ),
];
