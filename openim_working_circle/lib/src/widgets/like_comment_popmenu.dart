import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class LikeCommentPopMenu extends StatefulWidget {
  const LikeCommentPopMenu({
    Key? key,
    this.onPositionCallback,
    this.onTapLike,
    this.onTapComment,
    this.isLike = false,
  }) : super(key: key);
  final Function(Offset position, Size size)? onPositionCallback;
  final Function()? onTapLike;
  final Function()? onTapComment;
  final bool isLike;

  @override
  State<LikeCommentPopMenu> createState() => _PopMenuState();
}

class _PopMenuState extends State<LikeCommentPopMenu> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (mounted) {
        RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (null != renderBox) {
          Size size = renderBox.size;
          Offset position = renderBox.localToGlobal(Offset.zero);
          widget.onPositionCallback?.call(position, size);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Styles.c_0C1C33_opacity85,
        borderRadius: BorderRadius.circular(2.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(.1),
            offset: Offset(0, 2.h),
            blurRadius: 4.r,
            spreadRadius: 1.r,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItemView(
            widget.isLike ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
            StrRes.like,
            onTap: widget.onTapLike,
            color: widget.isLike ? Styles.c_0089FF : Styles.c_FFFFFF,
          ),
          Container(
            height: 17.h,
            width: .5.w,
            color: Styles.c_0C1C33,
          ),
          _buildItemView(
            Icons.chat,
            StrRes.comment,
            onTap: widget.onTapComment,
            color: Styles.c_FFFFFF,
          ),
        ],
      ),
    );
  }

  _buildItemView(
    IconData icon,
    String label, {
    Function()? onTap,
    Color? color,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          // width: 58.w,
          height: 26.h,
          constraints: BoxConstraints(minWidth: 58.w),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16.w, color: color),
              2.horizontalSpace,
              label.toText..style = Styles.ts_FFFFFF_12sp,
            ],
          ),
        ),
      );
}
