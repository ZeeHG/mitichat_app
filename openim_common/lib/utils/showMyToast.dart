import 'package:openim_common/openim_common.dart';

showDeveloping() {
  IMViews.showToast(StrLibrary.developing);
}

showToast(String text, {Duration? duration}) {
  IMViews.showToast(text, duration: duration);
}
