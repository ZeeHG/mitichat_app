import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

double kVoiceRecordBarHeight = 36.h;

enum RecordBarStatus {
  holdTalk,
  releaseToSend,
  liftFingerToCancelSend,
}

class ChatVoiceRecordBar extends StatefulWidget {
  const ChatVoiceRecordBar({
    Key? key,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.onLongPressMoveUpdate,
    this.speakBarColor,
    this.speakTextStyle,
    this.interruptListener,
    this.onChangedBarStatus,
  }) : super(key: key);
  final Function(LongPressStartDetails details) onLongPressStart;
  final Function(LongPressEndDetails details) onLongPressEnd;
  final Function(LongPressMoveUpdateDetails details) onLongPressMoveUpdate;
  final Color? speakBarColor;
  final TextStyle? speakTextStyle;
  final Stream<bool>? interruptListener;
  final Function(RecordBarStatus status)? onChangedBarStatus;

  @override
  State<ChatVoiceRecordBar> createState() => _ChatVoiceRecordBarState();
}

class _ChatVoiceRecordBarState extends State<ChatVoiceRecordBar> {
  bool _pressing = false;
  bool _canCancel = false;
  final double _offset = 40.h;
  StreamSubscription? _sub;

  @override
  void initState() {
    _sub = widget.interruptListener?.listen((interrupt) {
      if (!mounted) return;
      setState(() {
        _pressing = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) {
        setState(() {
          _pressing = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          _pressing = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressing = false;
        });
      },
      onLongPressStart: (details) {
        myLogger.i({"message": "语音录制长按开始", "data": details});
        HapticFeedback.heavyImpact();
        widget.onLongPressStart(details);
        setState(() {
          _pressing = true;
        });
      },
      onLongPressEnd: (details) {
        myLogger.i({"message": "语音录制长按结束", "data": details});
        widget.onLongPressEnd(details);
        setState(() {
          _pressing = false;
          _canCancel = false;
        });
      },
      onLongPressMoveUpdate: (details) {
        widget.onLongPressMoveUpdate(details);
        // Offset local = details.localPosition;
        // print('global:$global');
        // print('local:$local');
        Offset global = details.globalPosition;
        setState(() {
          _canCancel = global.dy < (1.sh - kInputBoxMinHeight - _offset);
          widget.onChangedBarStatus?.call(_canCancel
              ? RecordBarStatus.liftFingerToCancelSend
              : RecordBarStatus.releaseToSend);
        });
      },
      child: Container(
        // constraints: BoxConstraints(minHeight: 40.h),
        height: kVoiceRecordBarHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.speakBarColor ??
              (_pressing ? Styles.c_999999_opacity30 : Styles.c_FFFFFF),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          _pressing
              ? (_canCancel
                  ? StrLibrary.liftFingerToCancelSend
                  : StrLibrary.releaseToSend)
              : StrLibrary.holdTalk,
          style: widget.speakTextStyle ?? Styles.ts_333333_16sp_medium,
        ),
      ),
    );
  }
}
