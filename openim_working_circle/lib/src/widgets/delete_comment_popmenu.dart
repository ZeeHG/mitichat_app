import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class DeleteCommentPopMenu extends StatefulWidget {
  const DeleteCommentPopMenu({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);
  final Widget child;
  final Function()? onTap;

  @override
  State<DeleteCommentPopMenu> createState() => _DeleteCommentPopMenuState();
}

class _DeleteCommentPopMenuState extends State<DeleteCommentPopMenu> {
  final _popCtrl = CustomPopupMenuController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CopyCustomPopupMenu(
      controller: _popCtrl,
      pressType: PressType.longPress,
      arrowColor: Styles.c_0C1C33_opacity85,
      verticalMargin: 0,
      barrierColor: Colors.transparent,
      menuBuilder: () => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _popCtrl.hideMenu();
          widget.onTap?.call();
        },
        child: Container(
          width: 54.w,
          height: 26.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Styles.c_0C1C33_opacity85,
            borderRadius: BorderRadius.circular(4.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(.1),
                offset: Offset(0, 2.h),
                blurRadius: 4.r,
                spreadRadius: 1.r,
              )
            ],
          ),
          child: Text(
            StrRes.delete,
            style: Styles.ts_FFFFFF_12sp,
          ),
        ),
      ),
      child: widget.child,
    );
  }
}
