import 'package:flutter/material.dart';
import 'package:test_tl/config/theme/colors.dart';
import 'package:test_tl/config/theme/texts.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String value;
  final Function(String?)? onChanged;
  const CustomDropdown(
      {super.key,
      required this.items,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      margin: EdgeInsets.only(bottom: size.height * 0.03),
      decoration: BoxDecoration(
          color: ThemeColors.background,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ]
          ),
      child: DropdownButton<String>(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        isExpanded: true,
        style: ThemeText.medium(15, ThemeColors.text),
        iconEnabledColor: ThemeColors.text,
        underline: Container(
          height: 2,
          color: ThemeColors.background,
        ),
        value: value,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          },
        ).toList(),
      ),
    );
  }
}
