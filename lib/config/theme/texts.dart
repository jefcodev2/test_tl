import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeText {
  static TextStyle thin(double sizeFont, Color color) {
    return GoogleFonts.montserrat(
      textStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w100,
        fontSize: sizeFont,
      ),
    );
  }

  static TextStyle extraLight(double sizeFont, Color color) {
    return GoogleFonts.montserrat(
      textStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w200,
        fontSize: sizeFont,
      ),
    );
  }

  static TextStyle light(double sizeFont, Color color) {
    return GoogleFonts.montserrat(
      textStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w300,
        fontSize: sizeFont,
      ),
    );
  }

  static TextStyle normal(double sizeFont, Color color) {
    return GoogleFonts.montserrat(
      textStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: sizeFont,
      ),
    );
  }

  static TextStyle medium(double sizeFont, Color color) {
    return GoogleFonts.montserrat(
      textStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: sizeFont,
      ),
    );
  }

  static TextStyle semiBold(double sizeFont, Color color) {
    return GoogleFonts.montserrat(
      textStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: sizeFont,
      ),
    );
  }

  static TextStyle bold(double sizeFont, Color color) {
    return GoogleFonts.montserrat(
      textStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w700,
        fontSize: sizeFont,
      ),
    );
  }

  static TextStyle extraBold(double sizeFont, Color color) {
    return GoogleFonts.montserrat(
      textStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w800,
        fontSize: sizeFont,
      ),
    );
  }

  static TextStyle black(double sizeFont, Color color) {
    return GoogleFonts.montserrat(
      textStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w900,
        fontSize: sizeFont,
      ),
    );
  }
}
