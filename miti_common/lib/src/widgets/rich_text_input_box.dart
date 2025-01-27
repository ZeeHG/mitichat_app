// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:miti_common/miti_common.dart';

// class RichTextInputBox extends StatefulWidget {
//   const RichTextInputBox({
//     Key? key,
//     required this.voiceRecordBar,
//     this.enabled = true,
//     this.controller,
//     this.focusNode,
//     this.onTapCamera,
//     this.showAlbumIcon = true,
//     this.showCameraIcon = true,
//     this.showCardIcon = true,
//     this.showFileIcon = true,
//     this.showLocationIcon = true,
//     this.onTapAlbum,
//     this.onTapCard,
//     this.onTapFile,
//     this.onTapLocation,
//     this.onSend,
//   }) : super(key: key);
//   final TextEditingController? controller;
//   final FocusNode? focusNode;
//   final Widget voiceRecordBar;
//   final bool enabled;
//   final bool showAlbumIcon;
//   final bool showCameraIcon;
//   final bool showFileIcon;
//   final bool showCardIcon;
//   final bool showLocationIcon;
//   final Function()? onTapAlbum;
//   final Function()? onTapCamera;
//   final Function()? onTapFile;
//   final Function()? onTapCard;
//   final Function()? onTapLocation;
//   final Function()? onSend;

//   @override
//   State<RichTextInputBox> createState() => _RichTextInputBoxState();
// }

// class _RichTextInputBoxState extends State<RichTextInputBox> {
//   bool _leftKeyboardButton = false;

//   @override
//   void initState() {
//     widget.focusNode?.addListener(() {
//       if (widget.focusNode!.hasFocus) {
//         setState(() {
//           _leftKeyboardButton = false;
//         });
//       }
//     });
//     super.initState();
//   }

//   double get _opacity => (widget.enabled ? 1 : .4);

//   focus() => FocusScope.of(context).requestFocus(widget.focusNode);

//   unfocus() => FocusScope.of(context).requestFocus(FocusNode());

//   void onTapSpeak() {
//     if (!widget.enabled) return;
//     Permissions.microphone(() => setState(() {
//           _leftKeyboardButton = true;
//           unfocus();
//         }));
//   }

//   void onTapLeftKeyboard() {
//     if (!widget.enabled) return;
//     setState(() {
//       _leftKeyboardButton = false;
//       focus();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: StylesLibrary.c_F7F8FA,
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Wrap(
//             spacing: 22.w,
//             children: [
//               if (widget.showAlbumIcon)
//                 ImageLibrary.appToolboxAlbum.toImage
//                   ..width = 26.w
//                   ..height = 22.h
//                   ..opacity = _opacity
//                   ..onTap = widget.onTapAlbum,
//               // 22.horizontalSpace,
//               if (widget.showCameraIcon)
//                 ImageLibrary.appToolboxCamera.toImage
//                   ..width = 26.w
//                   ..height = 22.h
//                   ..opacity = _opacity
//                   ..onTap = widget.onTapCamera,
//               // 22.horizontalSpace,
//               if (widget.showFileIcon)
//                 ImageLibrary.appToolboxFile.toImage
//                   ..width = 26.w
//                   ..height = 22.h
//                   ..opacity = _opacity
//                   ..onTap = widget.onTapFile,
//               // 22.horizontalSpace,
//               if (widget.showCardIcon)
//                 ImageLibrary.appToolboxCard.toImage
//                   ..width = 26.w
//                   ..height = 22.h
//                   ..opacity = _opacity
//                   ..onTap = widget.onTapCard,
//               // 15.horizontalSpace,
//               if (widget.showLocationIcon)
//                 ImageLibrary.appToolboxLocation.toImage
//                   ..width = 16.w
//                   ..height = 22.h
//                   ..opacity = _opacity
//                   ..onTap = widget.onTapLocation,
//             ],
//           ),
//           if (widget.showAlbumIcon ||
//               widget.showCameraIcon ||
//               widget.showCardIcon ||
//               widget.showFileIcon ||
//               widget.showLocationIcon)
//             15.verticalSpace,
//           Row(
//             children: [
//               (_leftKeyboardButton
//                   ? (ImageLibrary.openKeyboard.toImage
//                     ..onTap = onTapLeftKeyboard)
//                   : (ImageLibrary.openVoice.toImage..onTap = onTapSpeak))
//                 ..width = 32.w
//                 ..height = 32.h
//                 ..opacity = _opacity,
//               12.horizontalSpace,
//               Expanded(
//                 child: Stack(
//                   children: [
//                     Offstage(
//                       offstage: _leftKeyboardButton,
//                       child: _textFiled,
//                     ),
//                     Offstage(
//                       offstage: !_leftKeyboardButton,
//                       child: widget.voiceRecordBar,
//                     ),
//                   ],
//                 ),
//               ),
//               10.horizontalSpace,
//               if (!_leftKeyboardButton)
//                 SizedBox(
//                   width: 78.w,
//                   child: Button(
//                     text: StrLibrary.send,
//                     height: 36.h,
//                     enabled: widget.enabled,
//                     onTap: widget.onSend,
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget get _textFiled => Container(
//         decoration: BoxDecoration(
//           color: StylesLibrary.c_FFFFFF,
//           borderRadius: BorderRadius.circular(4.r),
//         ),
//         child: ChatTextField(
//           allAtMap: const {},
//           atCallback: (showText, actualText) {},
//           controller: widget.controller,
//           focusNode: widget.focusNode,
//           style: StylesLibrary.ts_333333_17sp,
//           atStyle: StylesLibrary.ts_8443F8_17sp,
//           enabled: true,
//           textAlign: TextAlign.start,
//         ),
//       );
// }
