import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({
    Key? key,
    this.controller,
    this.focusNode,
    this.textStyle,
    this.hintStyle,
    this.hintText,
    this.searchIconColor,
    this.backgroundColor,
    this.searchIconHeight,
    this.searchIconWidth,
    this.margin,
    this.padding,
    this.enabled = false,
    this.autofocus = false,
    this.height,
    this.onSubmitted,
    this.onCleared,
    this.onChanged,
  }) : super(key: key);
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final String? hintText;
  final Color? searchIconColor;
  final Color? backgroundColor;
  final double? searchIconWidth;
  final double? searchIconHeight;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool enabled;
  final bool autofocus;
  final double? height;
  final Function(String)? onSubmitted;
  final Function()? onCleared;
  final ValueChanged<String>? onChanged;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  bool _showClearBtn = false;

  @override
  void initState() {
    widget.controller?.addListener(() {
      setState(() {
        _showClearBtn = widget.controller!.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 36.h,
      margin: widget.margin,
      padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Styles.c_F7F7F7,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: [
          ImageRes.searchGrey.toImage
            ..color = widget.searchIconColor
            ..width = widget.searchIconWidth ?? 15.w
            ..height = widget.searchIconHeight ?? 15.h,
          10.horizontalSpace,
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              style: widget.textStyle ?? Styles.ts_333333_16sp,
              autofocus: widget.autofocus,
              enabled: widget.enabled,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: widget.hintText ?? StrLibrary.search,
                hintStyle: widget.hintStyle ?? Styles.ts_999999_16sp,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
              onSubmitted: widget.onSubmitted,
              onChanged: widget.onChanged,
            ),
          ),
          if (_showClearBtn) _clearBtn,
        ],
      ),
    );
  }

  Widget get _clearBtn => Visibility(
        visible: _showClearBtn,
        child: GestureDetector(
          onTap: () {
            widget.controller?.clear();
            widget.onCleared?.call();
          },
          behavior: HitTestBehavior.translucent,
          child: ImageRes.clearText.toImage
            ..width = widget.searchIconWidth ?? 24.w
            ..height = widget.searchIconHeight ?? 24.h
            ..color = widget.searchIconColor,
        ),
      );
}
