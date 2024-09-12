import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_tl/presentation/widgets/shared/custom_button.dart';
import 'package:test_tl/config/helpers/toast_notifications.dart';
import 'package:test_tl/presentation/providers/main_provider.dart';
import 'package:test_tl/config/router/routes_names.dart';
import 'package:test_tl/config/theme/colors.dart';
import 'package:test_tl/config/theme/texts.dart';
import 'package:toastification/toastification.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool check = false;
  bool finishActive = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<ProviderGeneral>(context);
    return Container(
      width: size.width * 1,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (finishActive == false)
            _areReady(
              size,
            ),
          if (finishActive == true) _finish(size, provider)
        ],
      ),
    );
  }

  _areReady(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("¡Estamos listos!",
            style: ThemeText.medium(25, ThemeColors.titleOne)),
        /* Image.asset("assets/img/summary.png",
            height: size.height * 0.2, width: size.width * 0.4), */
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Se enviarán los documentos a:",
                style: ThemeText.normal(15, ThemeColors.septenary)),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text("Jefferson Pinchao",
                style: ThemeText.medium(13, ThemeColors.titleOne)),
            Text("japinchaoc@gmail.com",
                style: ThemeText.medium(15, ThemeColors.septenary)),
            Text("Mario Salas",
                style: ThemeText.medium(13, ThemeColors.titleOne)),
            Text("@admin@asb.com",
                style: ThemeText.medium(15, ThemeColors.septenary)),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text("Documento",
                style: ThemeText.normal(15, ThemeColors.septenary)),
            Text("Contrato de Arrendamiento",
                style: ThemeText.normal(15, ThemeColors.septenary)),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              children: [
                Checkbox(
                  value: check,
                  onChanged: (value) => setState(() {
                    check = !check;
                  }),
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: RichText(
                      maxLines: 2,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'He leído y acepto los ',
                              style: ThemeText.normal(12, ThemeColors.text)),
                          const TextSpan(
                            text:
                                'Términos del Servicio y Aviso de la Pólitica de Privacidad',
                            style: TextStyle(
                                color: ThemeColors.text,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        GestureDetector(
          onTap: () {
            if (check == false) {
              ToastNotifications.showNotification(
                context: context,
                  msg:
                      "Acepte los Términos del Servicio y Aviso de la Pólitica de Privacidad",
                      type: ToastificationType.error);
              return;
            }
            setState(() {
              finishActive = true;
            });
          },
          child: const CustomButton(
              color: ThemeColors.titleOne,
              colorBorder: ThemeColors.titleOne,
              colorText: ThemeColors.textAlt,
              title: "Enviar"),
        ),
      ],
    );
  }

  _finish(Size size, ProviderGeneral provider) {
    return Column(
      children: [
        Text(
          "¡Tus documentos se han enviado con éxito!",
          style: ThemeText.medium(25, ThemeColors.titleOne),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Container(
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: size.height * 0.1,
            )),
        SizedBox(
          height: size.height * 0.03,
        ),
        GestureDetector(
          onTap: () => provider.activeStep = 0,
          child: const CustomButton(
              color: ThemeColors.titleOne,
              colorBorder: ThemeColors.titleOne,
              colorText: ThemeColors.textAlt,
              title: "Firmar otro documento"),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        GestureDetector(
          onTap: () => context.pushReplacementNamed(RouteNames.home),
          child: const CustomButton(
              color: Colors.transparent,
              colorBorder: ThemeColors.titleOne,
              colorText: ThemeColors.titleOne,
              title: "Volver al dashboard"),
        ),
      ],
    );
  }
}
