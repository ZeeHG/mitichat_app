import 'package:flutter/cupertino.dart';
import 'package:miti_common/miti_common.dart';

class ChatDelayedStatusView extends StatelessWidget {
  const ChatDelayedStatusView({
    Key? key,
    required this.isSending,
    this.delay = true,
  }) : super(key: key);
  final bool isSending;
  final bool delay;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(
        Duration(seconds: isSending && delay ? 1 : 0),
        () => isSending,
      ),
      builder: (_, AsyncSnapshot<bool> hot) => Visibility(
        visible: hot.hasData && hot.data == true,
        child: CupertinoActivityIndicator(
          color: Styles.c_8443F8,
        ),
      ),
    );
  }
}
