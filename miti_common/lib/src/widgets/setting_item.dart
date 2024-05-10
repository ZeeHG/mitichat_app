import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class SettingItem extends StatelessWidget {
  final String label;
  final String? value;
  final String? valueAvatarUrl;
  final String? valueAvatarText;
  final bool showRightArrow;
  final bool showBorder;
  final Function()? onTap;
  final Function()? onTapValue;

  const SettingItem(
      {super.key,
      required this.label,
      this.value,
      this.valueAvatarUrl,
      this.valueAvatarText,
      this.showRightArrow = true,
      this.showBorder = true,
      this.onTap,
      this.onTapValue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: StylesLibrary.c_F1F2F6,
              width: showBorder ? 1.h : 0,
            ),
          ),
        ),
        height: 50.h,
        child: Row(
          children: [
            label.toText..style = StylesLibrary.ts_333333_14sp,
            const Spacer(),
            if (null != valueAvatarUrl)
              AvatarView(
                width: 38.w,
                height: 38.h,
                url: valueAvatarUrl,
                text: valueAvatarText,
              )
            else
              Expanded(
                  flex: 3,
                  child: (value ?? '').toText
                    ..style = StylesLibrary.ts_999999_14sp
                    ..maxLines = 1
                    ..overflow = TextOverflow.ellipsis
                    ..textAlign = TextAlign.right
                    ..onTap = onTapValue),
            if (showRightArrow)
              ImageLibrary.appRightArrow.toImage
                ..width = 20.w
                ..height = 20.h,
          ],
        ),
      ),
    );
  }
}

class SettingItemGroup extends StatelessWidget {
  final List<Widget> children;

  const SettingItemGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      color: StylesLibrary.c_FFFFFF,
      child: Column(children: children),
    );
  }
}
