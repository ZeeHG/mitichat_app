import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

enum InputBoxType {
  phone,
  account,
  password,
  verificationCode,
  invitationCode,
}

class InputBox extends StatefulWidget {
  const InputBox.phone(
      {super.key,
      // // this.label,,
      required this.code,
      this.onAreaCode,
      this.controller,
      this.focusNode,
      this.labelStyle,
      this.textStyle,
      this.codeStyle,
      this.hintStyle,
      this.formatHintStyle,
      this.onFocusChanged,
      this.onChanged,
      this.hintText,
      this.formatHintText,
      this.margin,
      this.inputFormatters,
      this.border = true,
      this.keyBoardType,
      this.autofocus = false,
      this.readOnly = false,
      this.enabled = true,
      this.showScanIcon = false,
      this.scan,
      this.rightButton,
      this.showClearBtn = true})
      : obscureText = false,
        type = InputBoxType.phone,
        arrowColor = null,
        clearBtnColor = null,
        onSendVerificationCode = null;

  InputBox.account(
      {super.key,
      // this.label,
      required this.code,
      this.onAreaCode,
      this.controller,
      this.focusNode,
      this.labelStyle,
      this.textStyle,
      this.codeStyle,
      this.hintStyle,
      this.formatHintStyle,
      this.hintText,
      this.formatHintText,
      this.margin,
      this.inputFormatters,
      this.border = true,
      this.onFocusChanged,
      this.keyBoardType,
      this.autofocus = false,
      this.readOnly = false,
      this.enabled = true,
      this.showScanIcon = false,
      this.scan,
      this.onChanged,
      this.rightButton,
      this.showClearBtn = true})
      : obscureText = false,
        type = InputBoxType.account,
        arrowColor = null,
        clearBtnColor = null,
        onSendVerificationCode = null;

  InputBox.password(
      {super.key,
      // this.label,,
      this.controller,
      FocusNode? focusNode,
      this.labelStyle,
      this.textStyle,
      this.hintStyle,
      this.onFocusChanged,
      this.formatHintStyle,
      this.hintText,
      this.formatHintText,
      this.margin,
      this.inputFormatters,
      this.border = true,
      this.keyBoardType,
      this.autofocus = false,
      this.readOnly = false,
      this.enabled = true,
      this.showScanIcon = false,
      this.scan,
      this.onChanged,
      this.rightButton,
      this.showClearBtn = true})
      : obscureText = true,
        type = InputBoxType.password,
        codeStyle = null,
        code = '',
        arrowColor = null,
        clearBtnColor = null,
        onSendVerificationCode = null,
        onAreaCode = null,
        focusNode = focusNode ?? FocusNode();

  const InputBox.verificationCode(
      {super.key,
      // this.label,,
      this.onSendVerificationCode,
      this.controller,
      this.focusNode,
      this.labelStyle,
      this.textStyle,
      this.hintStyle,
      this.onFocusChanged,
      this.formatHintStyle,
      this.hintText,
      this.formatHintText,
      this.margin,
      this.inputFormatters,
      this.border = true,
      this.keyBoardType,
      this.autofocus = false,
      this.rightButton,
      this.onChanged,
      this.readOnly = false,
      this.enabled = true,
      this.showScanIcon = false,
      this.scan,
      this.showClearBtn = true})
      : obscureText = false,
        type = InputBoxType.verificationCode,
        code = '',
        codeStyle = null,
        onAreaCode = null,
        arrowColor = null,
        clearBtnColor = null;

  const InputBox.invitationCode(
      {super.key,
      // this.label,,
      this.controller,
      this.focusNode,
      this.labelStyle,
      this.textStyle,
      this.formatHintStyle,
      this.hintStyle,
      this.hintText,
      this.onFocusChanged,
      this.formatHintText,
      this.margin,
      this.inputFormatters,
      this.border = true,
      this.keyBoardType,
      this.autofocus = false,
      this.onChanged,
      this.readOnly = false,
      this.enabled = true,
      this.showScanIcon = false,
      this.scan,
      this.rightButton,
      this.showClearBtn = true})
      : obscureText = false,
        type = InputBoxType.invitationCode,
        code = '',
        codeStyle = null,
        onAreaCode = null,
        onSendVerificationCode = null,
        arrowColor = null,
        clearBtnColor = null;

  const InputBox(
      {Key? key,
      // this.label,,
      this.controller,
      this.focusNode,
      this.labelStyle,
      this.textStyle,
      this.hintStyle,
      this.codeStyle,
      this.formatHintStyle,
      this.code = '+1',
      this.hintText,
      this.formatHintText,
      this.arrowColor,
      this.onChanged,
      this.onFocusChanged,
      this.clearBtnColor,
      this.obscureText = false,
      this.type = InputBoxType.account,
      this.onAreaCode,
      this.onSendVerificationCode,
      this.margin,
      this.inputFormatters,
      this.border = true,
      this.keyBoardType,
      this.autofocus = false,
      this.readOnly = false,
      this.enabled = true,
      this.showClearBtn = true,
      this.showScanIcon = false,
      this.rightButton,
      this.scan})
      : super(key: key);
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? codeStyle;
  final TextStyle? formatHintStyle;
  final String code;
  // final String? label;
  final String? hintText;
  final String? formatHintText;
  final Color? arrowColor;
  final Color? clearBtnColor;
  final bool obscureText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputBoxType type;
  final Function()? onAreaCode;
  final Future<bool> Function()? onSendVerificationCode;
  final EdgeInsetsGeometry? margin;
  final List<TextInputFormatter>? inputFormatters;
  final bool border;
  final TextInputType? keyBoardType;
  final bool autofocus;
  final bool readOnly;
  final bool enabled;
  final bool showClearBtn;
  final bool showScanIcon;
  final Function()? scan;
  final Widget? rightButton;

  final Function(String)? onChanged;
  final Function(bool)? onFocusChanged;
  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  late bool _obscureText;
  bool _showClearBtn = false;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    widget.controller?.addListener(_onChanged);
    widget.focusNode?.addListener(_handleFocusChange);
    super.initState();
  }

  void _onChanged() {
    setState(() {
      _showClearBtn = widget.controller!.text.isNotEmpty;
    });
  }

  void _handleFocusChange() {
    if (widget.onFocusChanged == null) return;
    if (widget.focusNode?.hasFocus ?? false) {
      widget.onFocusChanged?.call(true);
    } else {
      widget.onFocusChanged?.call(false);
    }
  }

  void _toggleEye() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   widget.label,
          //   style: widget.labelStyle ?? StylesLibrary.ts_999999_12sp,
          // ),
          // 6.verticalSpace,
          Container(
            height: 42.h,
            padding: EdgeInsets.only(left: 0, right: 8.w),
            decoration: BoxDecoration(
              // border: Border.all(color: StylesLibrary.c_EAEAEA, width: 1.h),
              // borderRadius: BorderRadius.circular(8.r),
              border: widget.border
                  ? Border(
                      bottom:
                          BorderSide(color: StylesLibrary.c_EAEAEA, width: 1.h))
                  : Border(bottom: BorderSide.none),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.type == InputBoxType.phone ||
                    widget.onAreaCode != null)
                  _areaCodeView,
                _textField,
                if (widget.showClearBtn) _clearBtn,
                _eyeBtn,
                _scanBtn,
                if (widget.type == InputBoxType.verificationCode)
                  VerifyCodedButton(
                    onTapCallback: widget.onSendVerificationCode,
                  ),
                if (widget.rightButton != null) ...[
                  10.horizontalSpace,
                  widget.rightButton!
                ]
              ],
            ),
          ),
          if (null != widget.formatHintText)
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: widget.formatHintText!.toText
                ..style =
                    (widget.formatHintStyle ?? StylesLibrary.ts_999999_12sp),
            ),
        ],
      ),
    );
  }

  Widget get _textField => Expanded(
          child: Listener(
        onPointerDown: (e) {
          if (widget.type == InputBoxType.password &&
              null != widget.focusNode) {
            FocusScope.of(context).requestFocus(widget.focusNode);
          }
        },
        child: TextField(
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            focusNode: widget.focusNode,
            controller: widget.controller,
            keyboardType: _textInputType,
            textInputAction: TextInputAction.next,
            style: widget.textStyle ?? StylesLibrary.ts_333333_16sp,
            autofocus: widget.autofocus,
            obscureText: _obscureText,
            inputFormatters: [
              if (widget.type == InputBoxType.phone ||
                  widget.type == InputBoxType.verificationCode)
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              if (null != widget.inputFormatters) ...widget.inputFormatters!,
            ],
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: widget.hintStyle ?? StylesLibrary.ts_CCCCCC_16sp,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            onChanged: widget.onChanged),
      ));

  Widget get _areaCodeView => GestureDetector(
        onTap: widget.onAreaCode,
        behavior: HitTestBehavior.translucent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.code,
              style: widget.codeStyle ?? StylesLibrary.ts_333333_16sp,
            ),
            8.horizontalSpace,
            ImageLibrary.downArrow.toImage
              ..width = 8.49.w
              ..height = 8.49.h,
            8.horizontalSpace,
            // Container(
            //   width: 1.w,
            //   height: 26.h,
            //   margin: EdgeInsets.symmetric(horizontal: 14.w),
            //   decoration: BoxDecoration(
            //     color: StylesLibrary.c_EAEAEA,
            //     borderRadius: BorderRadius.circular(2.r),
            //   ),
            // ),
          ],
        ),
      );

  Widget get _clearBtn => Visibility(
        visible: _showClearBtn,
        child: GestureDetector(
          onTap: () {
            widget.controller?.clear();
          },
          behavior: HitTestBehavior.translucent,
          child: ImageLibrary.clearText.toImage
            ..width = 24.w
            ..height = 24.h,
        ),
      );

  Widget get _eyeBtn => Visibility(
        visible: widget.type == InputBoxType.password,
        child: GestureDetector(
          onTap: _toggleEye,
          behavior: HitTestBehavior.translucent,
          child: (_obscureText
              ? ImageLibrary.eyeClose.toImage
              : ImageLibrary.eyeOpen.toImage)
            ..width = 24.w
            ..height = 24.h,
        ),
      );

  Widget get _scanBtn => Visibility(
        visible: widget.showScanIcon,
        child: GestureDetector(
          onTap: widget.scan,
          behavior: HitTestBehavior.translucent,
          child: ImageLibrary.appPopMenuScan.toImage
            ..width = 20.w
            ..height = 20.h,
        ),
      );

  TextInputType? get _textInputType {
    if (widget.keyBoardType != null) {
      return widget.keyBoardType;
    }
    TextInputType? keyboardType;
    switch (widget.type) {
      case InputBoxType.phone:
        keyboardType = TextInputType.phone;
        break;
      case InputBoxType.account:
        keyboardType = TextInputType.text;
        break;
      case InputBoxType.password:
        keyboardType = TextInputType.text;
        break;
      case InputBoxType.verificationCode:
        keyboardType = TextInputType.number;
        break;
      case InputBoxType.invitationCode:
        keyboardType = TextInputType.text;
        break;
    }
    return keyboardType;
  }
}

class VerifyCodedButton extends StatefulWidget {
  /// 倒计时的秒数，默认60秒。
  final int seconds;

  /// 用户点击时的回调函数。
  final Future<bool> Function()? onTapCallback;

  const VerifyCodedButton({
    Key? key,
    this.seconds = 60,
    required this.onTapCallback,
  }) : super(key: key);

  @override
  State<VerifyCodedButton> createState() => _VerifyCodedButtonState();
}

class _VerifyCodedButtonState extends State<VerifyCodedButton> {
  Timer? _timer;
  late int _seconds;
  bool _firstTime = true;

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _seconds = widget.seconds;
  }

  void _start() {
    _firstTime = false;
    _timer = Timer.periodic(1.seconds, (timer) {
      if (!mounted) return;
      if (_seconds == 0) {
        _cancel();
        setState(() {});
        return;
      }
      _seconds--;
      setState(() {});
    });
  }

  void _cancel() {
    if (null != _timer) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void _reset() {
    if (_seconds != widget.seconds) {
      _seconds = widget.seconds;
    }
    _cancel();
    setState(() {});
  }

  void _restart() {
    _reset();
    _start();
  }

  bool get _isEnabled => _seconds == 0 || _firstTime;

  @override
  Widget build(BuildContext context) =>
      (_isEnabled ? StrLibrary.sendVerificationCode : '${_seconds}S').toText
        ..style = StylesLibrary.ts_8443F8_16sp
        ..onTap = () {
          if (_isEnabled) {
            widget.onTapCallback?.call().then((start) {
              if (start) _restart();
            });
          }
        };
}
