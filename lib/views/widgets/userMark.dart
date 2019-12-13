import 'package:flutter/widgets.dart';
import 'package:pr0gramm/entities/commonTypes/userMark.dart';

class UserMarkWidget extends StatelessWidget {
  final UserMark userMark;
  final double radius;

  UserMarkWidget({Key key, this.userMark, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5),
      child: CustomPaint(
        painter: DrawCircle(
          color: userMark.color,
          radius: radius,
        ),
      ),
    );
  }
}

class DrawCircle extends CustomPainter {
  final Paint _paint;
  final double _radius;

  DrawCircle({Color color, radius})
      : _radius = radius,
        _paint = Paint()
          ..color = color
          ..strokeWidth = 10.0
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, 0.0), _radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}