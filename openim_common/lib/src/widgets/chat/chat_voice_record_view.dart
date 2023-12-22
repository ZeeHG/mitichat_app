import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openim_common/openim_common.dart';
import 'package:record/record.dart';

class ChatRecordVoiceView extends StatefulWidget {
  const ChatRecordVoiceView({
    Key? key,
    required this.builder,
    this.maxRecordSec = 60,
    this.onInterrupt,
    this.onCompleted,
  }) : super(key: key);
  final int maxRecordSec;
  final Function()? onInterrupt;
  final Function(int sec, String path)? onCompleted;
  final Widget Function(BuildContext context, int sec) builder;

  @override
  State<ChatRecordVoiceView> createState() => _ChatRecordVoiceViewState();
}

class _ChatRecordVoiceViewState extends State<ChatRecordVoiceView> {
  static const _dir = "voice";
  static const _ext = ".m4a";
  late String _path;
  int _startTimestamp = 0;
  final _audioRecorder = AudioRecorder();
  Timer? _timer;
  int _duration = 0;

  static int _now() => DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    (() async {
      if (await _audioRecorder.hasPermission()) {
        _path = '${await IMUtils.createTempDir(dir: _dir)}/${_now()}$_ext';
        await _audioRecorder.start(RecordConfig(), path: _path);
        _startTimestamp = _now();
        _timer?.cancel();
        _timer = null;
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          // _long = (_now() - _long) ~/ 1000;
          setState(() {
            _duration = ((_now() - _startTimestamp) ~/ 1000);
            if (_duration >= widget.maxRecordSec) {
              widget.onInterrupt?.call();
            }
          });
        });
      }
    })();
    super.initState();
  }

  @override
  void dispose() {
    (() async {
      _timer?.cancel();
      _timer = null;
      // 停止记录
      if (await _audioRecorder.isRecording()) {
        await _audioRecorder.stop();
      }
      widget.onCompleted?.call(_duration, _path);
    })();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder.call(context, _duration);
}

// class ChatRecordVoiceView extends StatelessWidget {
//   const ChatRecordVoiceView({
//     Key? key,
//   }) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Center(
//         child: Container(
//           width: 138.w,
//           height: 124.h,
//           decoration: BoxDecoration(
//             color: Styles.c_0C1C33_opacity60,
//             borderRadius: BorderRadius.circular(6.r),
//           ),
//           child: Column(),
//         ),
//       ),
//     );
//   }
// }

class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, -2);
    path.lineTo(size.width, -2);
    path.lineTo(size.width / 2, size.height * 2 / 4);

    // path.moveTo(0, size.height);
    // path.lineTo(size.width / 2, size.height / 2);
    // path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
