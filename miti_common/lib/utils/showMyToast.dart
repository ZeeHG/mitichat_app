import 'package:miti_common/miti_common.dart';

showDeveloping() {
  IMViews.showToast(StrLibrary.developing);
}

showToast(String text, {Duration? duration}) {
  IMViews.showToast(text, duration: duration);
}
