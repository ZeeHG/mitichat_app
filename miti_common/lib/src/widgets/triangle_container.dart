import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../miti_common.dart';

enum TriangleDirection { left, right }

class TriangleContainer extends StatelessWidget {
  TriangleContainer(
      {Key? key,
      this.triangleDirection = TriangleDirection.right,
      double? triangleWidth,
      double? triangleHeight,
      Color? triangleColor,
      this.child,
      this.top,
      this.bottom})
      : triangleWidth = triangleWidth ?? 6.w,
        triangleHeight = triangleHeight ?? 10.h,
        triangleColor = triangleColor ?? StylesLibrary.c_8443F8,
        super(key: key);

  TriangleDirection triangleDirection;
  double triangleWidth;
  double triangleHeight;
  double? top;
  double? bottom;
  Widget? child;
  Color triangleColor;

  get isRight => triangleDirection == TriangleDirection.right;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      // padding: EdgeInsets.only(
      //     right: isRight ? triangleWidth : 0,
      //     left: !isRight ? triangleWidth : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: top,
            bottom: bottom,
            left: !isRight ? -1 * triangleWidth + 1.w : null,
            right: isRight ? -1 * triangleWidth + 1.w : null,
            child: CustomPaint(
              painter: TrianglePainter(
                  triangleDirection: triangleDirection, color: triangleColor),
              child: SizedBox(
                width: triangleWidth,
                height: triangleHeight,
              ),
            ),
          ),
          Container(
            child: child,
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({
    Color? color,
    this.triangleDirection = TriangleDirection.right,
  })  : color = color ?? StylesLibrary.c_8443F8,
        super();

  TriangleDirection triangleDirection;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    if (triangleDirection == TriangleDirection.right) {
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height / 2);
      // path.arcToPoint(Offset(size.width, size.height / 2), radius: Radius.circular(0));
      path.lineTo(0, size.height);
      path.close();
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(0, size.height / 2);
      path.lineTo(size.width, size.height);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
