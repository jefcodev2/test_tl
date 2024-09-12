import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_tl/presentation/providers/main_provider.dart';
import 'package:test_tl/config/router/routes_names.dart';
import 'package:test_tl/presentation/widgets/widgets.dart';
import 'package:test_tl/config/theme/colors.dart';
import 'package:test_tl/config/theme/texts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainTheme(
      screenToShow: HomeBody(),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<ProviderGeneral>(context);
    return Container(
      width: size.width * 1,
      height: size.height * 0.8,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
              color: ThemeColors.title,
              fontSize: 3,
              fontWeight: FontWeight.w600,
              text: 'Dashboard',
              textAlign: TextAlign.left),
          const CustomText(
              color: ThemeColors.titleOne,
              fontSize: 1.9,
              fontWeight: FontWeight.w500,
              text: 'Bienvenido Paul',
              textAlign: TextAlign.left),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomText(
                    color: ThemeColors.text,
                    fontSize: 2,
                    fontWeight: FontWeight.w600,
                    text: '¿Qué quieres hacer?',
                    textAlign: TextAlign.center),
                options(
                    context,
                    provider,
                    RouteNames.signdocuments,
                    size,
                    Icons.document_scanner_outlined,
                    "Firmar Documentos",
                    "Firma documentos electrónicos y solicita la firma de terceros."),
                /* options(
                    context,
                    provider,
                    RouteNames.signatures,
                    size,
                    Icons.edit_outlined,
                    "Firmas",
                    "Administra tus firmas: agrégalas, revísalas y elimínalas."), */
                options(
                    context,
                    provider,
                    RouteNames.signedocuments,
                    size,
                    Icons.edit_note_rounded,
                    "Documentos Firmados",
                    "Revisa y envia tus documentos firmados."),
              ],
            ),
          ),
        ],
      ),
    );
  }

 Widget options(BuildContext context, ProviderGeneral provider, String route,
    Size size, IconData icon, String title, String description) {
  return GestureDetector(
    onTap: () {
      if (route != '') {
        context.pushNamed(route);
        provider.activeStep = 0;
      }
    },
    child: Container(
      height: size.height * 0.13, 
      padding: const EdgeInsets.all(16), 
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: ThemeColors.borderWhite,
        border: Border.all(color: ThemeColors.border),
        borderRadius: const BorderRadius.all(Radius.circular(8)), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07), 
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: ThemeColors.titleOne,
              size: 35, 
            ),
          ),
          SizedBox(
            width: size.width * 0.6, 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ThemeText.medium(16, ThemeColors.text), 
                ),
                Text(
                  description,
                  style: ThemeText.normal(13, ThemeColors.text),
                ),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_right, size: 28) 
        ],
      ),
    ),
  );
}

}
