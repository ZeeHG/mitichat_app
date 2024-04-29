import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class SyncStatusView extends StatelessWidget {
  const SyncStatusView({
    Key? key,
    required this.isFailed,
    required this.statusStr,
  }) : super(key: key);
  final bool isFailed;
  final String statusStr;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isFailed ? StylesLibrary.c_FFE1DD : StylesLibrary.c_F2F8FF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isFailed
                ? (ImageLibrary.syncFailed.toImage
                  ..width = 12.w
                  ..height = 12.h)
                : SizedBox(
                    width: 12.w,
                    height: 12.h,
                    child: CupertinoActivityIndicator(
                      color: StylesLibrary.c_8443F8,
                      radius: 6.r,
                    ),
                  ),
            4.horizontalSpace,
            statusStr.toText
              ..style = (isFailed
                  ? StylesLibrary.ts_FF4E4C_12sp
                  : StylesLibrary.ts_8443F8_12sp),
          ],
        ),
      );
}
