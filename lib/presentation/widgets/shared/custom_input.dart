import 'package:flutter/material.dart';
import 'package:test_tl/config/theme/colors.dart';
import 'package:test_tl/config/theme/texts.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool visible;
  const CustomInput(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.visible});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TextFormField(
      controller: controller,
      obscureText: visible,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: ThemeText.normal(15, ThemeColors.borderInput),
        labelStyle: ThemeText.normal(size.height * 0.012, ThemeColors.borderInput),
        enabledBorder: _getBorder(ThemeColors.borderInput),
        border: _getBorder(ThemeColors.sucess),
        focusedBorder: _getBorder(ThemeColors.borderInput),
        errorBorder: _getBorder(ThemeColors.sucess),
        focusedErrorBorder: _getBorder(ThemeColors.sucess),
      ),
    );
  }

  InputBorder? _getBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(5),
    );
  }
}
