import 'package:flutter/material.dart';
const userMarks = [
  Color(0xFFFFFFFF),
  Color(0xFFE108E9),
  Color(0xFF5BB91C),
  Color(0xFFFF9900),
  Color(0xFF444444),
  Color(0xFF008FFF),
  Color(0xFF6C432B),
  Color(0xFF1cb992), //content:'\25C6';margin-left:0.4em;}
  Color(0xFFd23c22), //content:'\25A7';margin-left:0.4em;}
  Color(0xFF1cb992),
  Color(0xFFaddc8d),
  Color(0xFF7fc7ff),
  Color(0xFFc52b2f), // content:'\2764';margin-left:0.4em;}
  Color(0xFF10366f),
  Color(0xFFffc166),
];

class UserMark extends StatelessWidget {
  final int userMark;

  final double radius;
  UserMark({Key key, this.userMark, this.radius}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5),
      child: CustomPaint(painter: DrawCircle(userMarks[userMark], radius)),
    );
  }
}

class DrawCircle extends CustomPainter {
  Paint _paint;
  double radius;
  DrawCircle(Color color, this.radius) {
    radius = radius ?? 2.5;
    _paint = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, 0.0), radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
