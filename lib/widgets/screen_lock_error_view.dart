import 'package:flutter/material.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

class ScreenLockErrorView extends StatelessWidget {
  const ScreenLockErrorView({
    super.key,
    required this.stream,
  });

  final Stream<String> stream;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(StrLibrary.plsEnterPassword, style: StylesLibrary.ts_FFFFFF_16sp),
      StreamBuilder(
        builder: (context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData) {
            return Text(
              sprintf(StrLibrary.lockPwdErrorHint, [snapshot.data]),
              style: StylesLibrary.ts_FF4E4C_16sp,
            );
          }
          return Container();
        },
        stream: stream,
      ),
    ]);
  }
}
