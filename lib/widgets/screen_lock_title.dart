import 'package:flutter/material.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

class ScreenLockTitle extends StatelessWidget {
  const ScreenLockTitle({
    Key? key,
    required this.stream,
  }) : super(key: key);

  final Stream<String> stream;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(StrLibrary.plsEnterPassword, style: Styles.ts_FFFFFF_17sp),
      StreamBuilder(
        builder: (context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData) {
            return Text(
              sprintf(StrLibrary.lockPwdErrorHint, [snapshot.data]),
              style: Styles.ts_FF4E4C_17sp,
            );
          }
          return const SizedBox();
        },
        stream: stream,
      ),
    ]);
  }
}
