import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

double kInputBoxMinHeight = 56.h;

class ChatInputBox extends StatefulWidget {
  const ChatInputBox({
    Key? key,
    required this.toolbox,
    required this.voiceRecordBar,
    required this.emojiView,
    required this.multiOpToolbox,
    this.allAtMap = const {},
    this.isAiSingleChat = false,
    this.atCallback,
    this.controller,
    this.focusNode,
    this.style,
    this.atStyle,
    this.inputFormatters,
    this.enabled = true,
    this.isMultiModel = false,
    this.isNotInGroup = false,
    this.hintText,
    this.openAtList,
    this.forceCloseToolboxSub,
    this.quoteContent,
    this.onClearQuote,
    this.onSend,
    this.disabledChatInput = false,
  }) : super(key: key);
  final AtTextCallback? atCallback;
  final Map<String, String> allAtMap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextStyle? style;
  final TextStyle? atStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool isMultiModel;
  final bool isNotInGroup;
  final String? hintText;
  final String Function()? openAtList;
  final Widget toolbox;
  final Widget voiceRecordBar;
  final Widget emojiView;
  final Widget multiOpToolbox;
  final Stream? forceCloseToolboxSub;
  final String? quoteContent;
  final Function()? onClearQuote;
  final ValueChanged<String>? onSend;
  final bool disabledChatInput;
  final bool isAiSingleChat;

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState
    extends State<ChatInputBox> /*with TickerProviderStateMixin */ {
  bool _toolsVisible = false;
  bool _emojiVisible = false;
  bool _leftKeyboardButton = false;
  bool _rightKeyboardButton = false;
  bool _sendButtonVisible = false;

  // late AnimationController _controller;
  // late Animation<double> _animation;
  bool get _showQuoteView => MitiUtils.isNotNullEmptyStr(widget.quoteContent);

  /// 不可使用时的透明度，如禁言开启
  double get _opacity => (widget.enabled ? 1 : .4);

  @override
  void initState() {
    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 200),
    //   vsync: this,
    // )..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       // controller.reverse();
    //     } else if (status == AnimationStatus.dismissed) {
    //       // controller.forward();
    //     }
    //   });
    //
    // _animation = Tween(begin: 1.0, end: 0.0).animate(_controller)
    //   ..addListener(() {
    //     setState(() {});
    //   });

    widget.focusNode?.addListener(() {
      if (widget.focusNode!.hasFocus) {
        setState(() {
          _toolsVisible = false;
          _emojiVisible = false;
          _leftKeyboardButton = false;
          _rightKeyboardButton = false;
        });
      }
    });

    widget.forceCloseToolboxSub?.listen((value) {
      if (!mounted) return;
      setState(() {
        _toolsVisible = false;
        _emojiVisible = false;
        _rightKeyboardButton = false;
      });
    });

    widget.controller?.addListener(() {
      setState(() {
        _sendButtonVisible = widget.controller!.text.isNotEmpty;
      });
      // if (widget.controller!.text.isEmpty) {
      //   _controller.reverse();
      // } else {
      //   _controller.forward();
      // }
    });

    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    // widget.controller?.dispose();
    // widget.focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) widget.controller?.clear();
    return widget.isNotInGroup
        ? const ChatDisableInputBox()
        : widget.isMultiModel
            ? widget.multiOpToolbox
            : Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        // height: 56.h,
                        constraints:
                            BoxConstraints(minHeight: kInputBoxMinHeight),
                        color: StylesLibrary.c_F7F7F7,
                        child: Row(
                          children: [
                            12.horizontalSpace,
                            (_leftKeyboardButton
                                ? (ImageLibrary.openKeyboard.toImage
                                  ..onTap = onTapLeftKeyboard)
                                : (ImageLibrary.openVoice.toImage
                                  ..onTap = onTapSpeak))
                              ..width = 28.w
                              ..height = 28.h
                              ..opacity = _opacity,
                            12.horizontalSpace,
                            Expanded(
                              child: Stack(
                                children: [
                                  Offstage(
                                    offstage: _leftKeyboardButton,
                                    child: _textFiled,
                                  ),
                                  Offstage(
                                    offstage: !_leftKeyboardButton,
                                    child: widget.voiceRecordBar,
                                  ),
                                ],
                              ),
                            ),
                            12.horizontalSpace,
                            (_rightKeyboardButton
                                ? (ImageLibrary.openKeyboard.toImage
                                  ..onTap = onTapRightKeyboard)
                                : (ImageLibrary.openEmoji.toImage
                                  ..onTap = onTapEmoji))
                              ..width = 28.w
                              ..height = 28.h
                              ..opacity = _opacity,
                            12.horizontalSpace,
                            (_sendButtonVisible
                                    ? ImageLibrary.appSendMessage2
                                    : ImageLibrary.openToolbox)
                                .toImage
                              ..width = 28.w
                              ..height = 28.h
                              ..opacity = _opacity
                              ..onTap =
                                  _sendButtonVisible ? send : toggleToolbox,
                            12.horizontalSpace,
                            // Visibility(
                            //   visible: !_leftKeyboardButton || !_rightKeyboardButton,
                            //   child: Container(
                            //     width: 60.0.w * (1.0 - _animation.value),
                            //     margin: EdgeInsets.only(right: 4.w),
                            //     child: Button(
                            //       text: StrLibrary .send,
                            //       height: 32.h,
                            //       onTap: send,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      if (_showQuoteView)
                        _QuoteView(
                          content: widget.quoteContent!,
                          onClearQuote: widget.onClearQuote,
                        ),
                      Visibility(
                        visible: _toolsVisible,
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 200),
                          child: widget.toolbox,
                        ),
                      ),
                      Visibility(
                        visible: _emojiVisible,
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 200),
                          child: widget.emojiView,
                        ),
                      ),
                    ],
                  ),
                  if (widget.disabledChatInput)
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          color: StylesLibrary.c_999999_opacity13,
                        ))
                ],
              );
  }

  Widget get _textFiled => Container(
        margin: EdgeInsets.only(top: 10.h, bottom: _showQuoteView ? 4.h : 10.h),
        decoration: BoxDecoration(
          color: StylesLibrary.c_FFFFFF,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: ChatTextField(
          allAtMap: widget.allAtMap,
          atCallback: widget.atCallback,
          controller: widget.controller,
          focusNode: widget.focusNode,
          style: widget.style ?? StylesLibrary.ts_333333_17sp,
          atStyle: widget.atStyle ?? StylesLibrary.ts_8443F8_17sp,
          inputFormatters: widget.inputFormatters ??
              [AtTextInputFormatter(widget.openAtList)],
          enabled: widget.enabled,
          hintText: widget.hintText,
          textAlign: widget.enabled ? TextAlign.start : TextAlign.center,
        ),
      );

  void send() {
    if (!widget.enabled) return;
    if (!_emojiVisible) focus();
    if (widget.isAiSingleChat) {
      unfocus();
    }
    if (null != widget.onSend && null != widget.controller) {
      widget.onSend!(widget.controller!.text.toString().trim());
    }
  }

  void toggleToolbox() {
    if (!widget.enabled) return;
    setState(() {
      _toolsVisible = !_toolsVisible;
      _emojiVisible = false;
      _leftKeyboardButton = false;
      _rightKeyboardButton = false;
      if (_toolsVisible) {
        unfocus();
      } else {
        focus();
      }
    });
  }

  void onTapSpeak() {
    if (!widget.enabled) return;
    Permissions.storageAndMicrophone(() => setState(() {
          _leftKeyboardButton = true;
          _rightKeyboardButton = false;
          _toolsVisible = false;
          _emojiVisible = false;
          unfocus();
        }));
  }

  void onTapLeftKeyboard() {
    if (!widget.enabled) return;
    setState(() {
      _leftKeyboardButton = false;
      _toolsVisible = false;
      _emojiVisible = false;
      focus();
    });
  }

  void onTapRightKeyboard() {
    if (!widget.enabled) return;
    setState(() {
      _rightKeyboardButton = false;
      _toolsVisible = false;
      _emojiVisible = false;
      focus();
    });
  }

  void onTapEmoji() {
    if (!widget.enabled) return;
    setState(() {
      _rightKeyboardButton = true;
      _leftKeyboardButton = false;
      _emojiVisible = true;
      _toolsVisible = false;
      unfocus();
    });
  }

  focus() => FocusScope.of(context).requestFocus(widget.focusNode);

  unfocus() => FocusScope.of(context).requestFocus(FocusNode());
}

class _QuoteView extends StatelessWidget {
  const _QuoteView({
    Key? key,
    this.onClearQuote,
    required this.content,
  }) : super(key: key);
  final Function()? onClearQuote;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.h, left: 56.w, right: 100.w),
      color: StylesLibrary.c_F7F8FA,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onClearQuote,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: StylesLibrary.c_FFFFFF,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  content,
                  style: StylesLibrary.ts_999999_14sp,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ImageLibrary.delQuote.toImage
                ..width = 14.w
                ..height = 14.h,
            ],
          ),
        ),
      ),
    );
  }
}
