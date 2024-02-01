import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatMergeMsgView extends StatelessWidget {
  const ChatMergeMsgView({
    Key? key,
    required this.title,
    required this.summaryList,
  }) : super(key: key);
  final String title;
  final List<String> summaryList;

  List<Widget> _children() {
    var list = <Widget>[];
    list
      ..add(10.verticalSpace)
      ..add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: title.toText..style = Styles.ts_333333_16sp,
      ))
      ..add(Container(
        color: Styles.c_E8EAEF,
        height: 1,
        margin: EdgeInsets.symmetric(vertical: 10.h),
      ));
    final maxSummary = min(summaryList.length, 4);
    for (int i = 0; i < maxSummary; i++) {
      final s = summaryList[i];
      list
        ..add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: MatchTextView(
                text: s.trim(), textStyle: Styles.ts_999999_14sp)))
        ..add(6.verticalSpace);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: locationWidth,
      constraints: BoxConstraints(maxWidth: maxWidthContainer),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        border: Border.all(color: Styles.c_E8EAEF, width: 1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _children(),
      ),
    );
  }
}
