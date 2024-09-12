import 'package:flutter/material.dart';
import 'package:test_tl/config/theme/texts.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final Color colorBorder;
  final Color colorText;
  final String title;
  const CustomButton(
      {super.key,
      required this.color,
      required this.colorBorder,
      required this.colorText,
      required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.height * 0.02, horizontal: size.width * 0.02),
      width: size.width * 0.8,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: colorBorder)),
      child: Center(
          child: Text(
        title,
        style: ThemeText.semiBold(12, colorText),
      )),
    );
  }
}
