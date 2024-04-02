import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class ExpandedText extends StatefulWidget {
  const ExpandedText({
    Key? key,
    required this.text,
    this.textStyle,
    this.maxLines = 4,
  }) : super(key: key);
  final String text;
  final TextStyle? textStyle;
  final int maxLines;

  @override
  State<ExpandedText> createState() => _ExpandedTextState();
}

class _ExpandedTextState extends State<ExpandedText> {
  bool _isExpand = false;

  TextStyle get _textStyle => widget.textStyle ?? StylesLibrary.ts_333333_17sp;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, cons) {
      final tp = MitiUtils.getTextPainter(
        widget.text,
        _textStyle,
        maxLines: widget.maxLines,
        maxWidth: cons.maxWidth,
      );
      return tp.didExceedMaxLines
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isExpand
                    ? Text(widget.text, style: _textStyle)
                    : Text(
                        widget.text,
                        style: _textStyle,
                        maxLines: widget.maxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      _isExpand = !_isExpand;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: (_isExpand ? StrLibrary.rollUp : StrLibrary.fullText)
                        .toText
                      ..style = StylesLibrary.ts_8443F8_17sp,
                  ),
                ),
              ],
            )
          : Text(widget.text, style: _textStyle);
    });
  }
}
