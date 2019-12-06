import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/commonTypes/userMark.dart';

const userMarks = [
  Color(0xffffffff),
  Color(0xffe108e9),
  Color(0xff5bb91c),
  Color(0xffff9900),
  Color(0xff444444),
  Color(0xff008fff),
  Color(0xff6c432b),
  Color(0xff1cb992), //content:'\25C6';margin-left:0.4em;}
  Color(0xffd23c22), //content:'\25A7';margin-left:0.4em;}
  Color(0xff1cb992),
  Color(0xffaddc8d),
  Color(0xff7fc7ff),
  Color(0xffc52b2f), // content:'\2764';margin-left:0.4em;}
  Color(0xff10366f),
  Color(0xffffc166),
];

class UserMarkView extends StatelessWidget {
  final UserMark userMark;
  final double radius;

  UserMarkView({Key key, this.userMark, this.radius}) : super(key: key);

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
