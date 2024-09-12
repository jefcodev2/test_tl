import 'package:flutter/material.dart';
import 'package:test_tl/config/theme/colors.dart';
import 'package:test_tl/config/theme/texts.dart';
import 'package:test_tl/config/theme/image_asests.dart';

class MainTheme extends StatelessWidget {
  final Widget screenToShow;
  const MainTheme({super.key, required this.screenToShow});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(),
        body: Container(
          color: ThemeColors.senary,
          child: Column(
            children: [
              Expanded(child: screenToShow),
              _buildFooterText(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLogoSection(),
          const CircleAvatar(
            backgroundImage: NetworkImage(
              ImageAssets.avatarUrl,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Row(
      children: [
        const IconButton(onPressed: null, icon: Icon(Icons.menu)),
        Image.network(
          width: 80,
          height: 50,
          fit: BoxFit.contain,
          ImageAssets.logoTodoLegal,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      ],
    );
  }

  Widget _buildFooterText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Smart Contracts Suite - Un Producto de ',
              style: ThemeText.normal(11, ThemeColors.text),
            ),
            TextSpan(
              text: 'Todolegal SAS ',
              style: ThemeText.normal(11, ThemeColors.titleOne),
            ),
            TextSpan(
              text: '- 2023',
              style: ThemeText.normal(11, ThemeColors.text),
            ),
          ],
        ),
      ),
    );
  }
}
