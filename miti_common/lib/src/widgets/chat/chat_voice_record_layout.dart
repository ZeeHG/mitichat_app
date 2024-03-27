import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:miti_common/miti_common.dart';
import 'package:rxdart/rxdart.dart';

typedef SpeakViewChildBuilder = Widget Function(ChatVoiceRecordBar recordBar);

class ChatVoiceRecordLayout extends StatefulWidget {
  const ChatVoiceRecordLayout({
    Key? key,
    required this.builder,
    this.locale,
    this.onCompleted,
    this.speakTextStyle,
    this.speakBarColor,
    this.maxRecordSec = 60,
  }) : super(key: key);

  final SpeakViewChildBuilder builder;
  final Locale? locale;
  final Function(int sec, String path)? onCompleted;
  final Color? speakBarColor;
  final TextStyle? speakTextStyle;

  /// 最大记录时长s
  final int maxRecordSec;

  @override
  State<ChatVoiceRecordLayout> createState() => _ChatVoiceRecordLayoutState();
}

class _ChatVoiceRecordLayoutState extends State<ChatVoiceRecordLayout> {
  final _interruptSub = PublishSubject<bool>();
  bool _showVoiceRecordView = false;
  RecordBarStatus _status = RecordBarStatus.holdTalk;
  bool _isCancelSend = false;

  void _completed(int sec, String path) {
    if (_isCancelSend) {
      File(path).delete();
      _status = RecordBarStatus.holdTalk;
      _isCancelSend = false;
    } else {
      if (sec == 0) {
        File(path).delete();
        showToast(StrLibrary.talkTooShort);
      } else {
        widget.onCompleted?.call(sec, path);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _interruptSub.close();
    super.dispose();
  }

  ChatVoiceRecordBar get _createSpeakBar => ChatVoiceRecordBar(
        speakBarColor: widget.speakBarColor,
        speakTextStyle: widget.speakTextStyle,
        interruptListener: _interruptSub.stream,
        onChangedBarStatus: (status) {
          if (status != _status) {
            setState(() {
              _isCancelSend = status == RecordBarStatus.liftFingerToCancelSend;
              _status = status;
            });
          }
        },
        onLongPressMoveUpdate: (details) {},
        onLongPressEnd: (details) async {
          setState(() {
            myLogger.i({"message": "ChatVoiceRecordBar onLongPressEnd 触发"});
            _showVoiceRecordView = false;
          });
        },
        onLongPressStart: (details) {
          setState(() {
            myLogger.i({"message": "ChatVoiceRecordBar onLongPressStart 触发"});
            _showVoiceRecordView = true;
          });
        },
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(_createSpeakBar),
        Visibility(
          visible: _showVoiceRecordView,
          child: ChatRecordVoiceView(
            onCompleted: _completed,
            onInterrupt: () {
              setState(() {
                myLogger.i({"message": "ChatRecordVoiceView onInterrupt 触发"});
                _interruptSub.add(true);
                _showVoiceRecordView = false;
              });
            },
            builder: (_, sec, startTimestamp) => startTimestamp > 0
                ? Material(
                    color: Colors.transparent,
                    child: Center(
                      child: Container(
                        width: 138.w,
                        height: 124.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: _isCancelSend
                              ? Styles.c_FF4E4C_opacity70
                              : Styles.c_333333_opacity60,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Column(
                          children: [
                            MitiUtils.seconds2HMS(sec).toText
                              ..style = Styles.ts_FFFFFF_12sp,
                            Expanded(child: _lottieAnimWidget),
                            (_isCancelSend
                                    ? StrLibrary.liftFingerToCancelSend
                                    : StrLibrary.releaseToSendSwipeUpToCancel)
                                .toText
                              ..style = Styles.ts_FFFFFF_12sp,
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget get _lottieAnimWidget => Lottie.asset(
        'assets/anim/voice_record.json',
        fit: BoxFit.contain,
        package: 'miti_common',
      );
}
