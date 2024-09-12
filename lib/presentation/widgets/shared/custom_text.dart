import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_tl/utils/size_config.dart';

class CustomText extends StatelessWidget {
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final String text;
  const CustomText(
      {super.key,
      required this.color,
      required this.fontSize,
      required this.fontWeight,
      required this.text,
      required this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(
            color: color,
            fontSize: fontSize * SizeConfig.textMultiplier,
            fontWeight: fontWeight,
            letterSpacing: -0.5,
            height: 1.5),
      ),
      textAlign: textAlign,
    );
  }
}
