import 'package:flutter/material.dart';


class RoundCornerShape extends StatelessWidget {
  final Widget child;
  final Color strokeColor;
  final double radius;
  final Color bgColor;

  const RoundCornerShape(
      {super.key, required this.child, required this.strokeColor, required this.radius,this.bgColor=Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: bgColor,
            border: Border.all(
              width: .8,
              color: strokeColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(radius))
        ),
        child: child,);
  }
}
