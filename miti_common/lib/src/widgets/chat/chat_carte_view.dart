import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class ChatCarteView extends StatelessWidget {
  const ChatCarteView({
    Key? key,
    required this.cardElem,
  }) : super(key: key);
  final CardElem cardElem;

  @override
  Widget build(BuildContext context) => Container(
        width: locationWidth,
        height: 91.h,
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          border: Border.all(color: Styles.c_E8EAEF, width: 1.h),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AvatarView(
                      width: 44.w,
                      height: 44.h,
                      url: cardElem.faceURL,
                      text: cardElem.nickname,
                    ),
                    10.horizontalSpace,
                    Expanded(
                        child: cardElem.nickname!.toText
                          ..style = Styles.ts_333333_16sp
                          ..maxLines = 1
                          ..overflow = TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            Container(color: Styles.c_E8EAEF, height: 1),
            Container(
              height: 26.h,
              padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 16.w),
              child: StrLibrary.carte.toText..style = Styles.ts_999999_12sp,
            )
          ],
        ),
      );
}
