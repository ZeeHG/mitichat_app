// import 'package:flutter/material.dart';
// import 'package:miti_common/miti_common.dart';

// /// 触摸关闭键盘
// class TouchCloseSoftKeyboard extends StatelessWidget {
//   final Widget child;
//   final Function? onTouch;
//   final bool isGradientBg;

//   const TouchCloseSoftKeyboard({
//     Key? key,
//     required this.child,
//     this.onTouch,
//     this.isGradientBg = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.translucent,
//       onTap: () {
//         // 触摸收起键盘
//         FocusScope.of(context).requestFocus(FocusNode());
//         onTouch?.call();
//       },
//       child: isGradientBg
//           ? Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     StylesLibrary.c_8443F8_opacity10,
//                     StylesLibrary.c_FFFFFF_opacity0,
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//               child: child,
//             )
//           : child,
//     );
//   }
// }
