import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_tl/presentation/screens/screens.dart';
import 'package:test_tl/presentation/widgets/widgets.dart';
import 'package:test_tl/config/helpers/toast_notifications.dart';
import 'package:test_tl/presentation/providers/main_provider.dart';
import 'package:test_tl/config/theme/colors.dart';
import 'package:test_tl/config/theme/texts.dart';
import 'package:test_tl/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class PersonalizeScreen extends StatefulWidget {
  const PersonalizeScreen({super.key});

  @override
  State<PersonalizeScreen> createState() => _PersonalizeScreenState();
}

class _PersonalizeScreenState extends State<PersonalizeScreen>
    with SingleTickerProviderStateMixin {
  List<String> pdfPathsToShow = [];
  List<String> pdfNamesToShow = [];
  List<String> imagePathsToShow = [];
  List<String> imageNamesToShow = [];
  List<String> imagePasswordToShow = [];
  int imgIndex = 0;
  String signSelected = '';
  String documentSelected = '';
  String signPathSelected = '';
  String documentPathSelected = '';
  TextEditingController passwordController = TextEditingController(text: "");

  bool editPDF = false;
  bool isLoading = true;
  bool isWalletVisible = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pdfPathsToShow = prefs.getStringList('pdfs_path') ?? [];
      pdfNamesToShow = prefs.getStringList('pdfs_name') ?? [];
      imagePathsToShow = prefs.getStringList('image_path_list') ?? [];
      imageNamesToShow = prefs.getStringList('image_name_list') ?? [];
      imagePasswordToShow = prefs.getStringList('image_pw_list') ?? [];
      signSelected = imageNamesToShow[0];
      documentSelected = pdfNamesToShow[0];
      signPathSelected = imagePathsToShow[0];
      documentPathSelected = pdfPathsToShow[0];
      isLoading = false;
    });
  }

  _showPasswordDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const CustomText(
                color: ThemeColors.titleOne,
                fontSize: 2,
                fontWeight: FontWeight.bold,
                text: "Contraseña de la billetera",
                textAlign: TextAlign.center),
            content: CustomInput(
                controller: passwordController,
                hintText: "Ingrese contraseña",
                visible: true),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (passwordController.text == '1234') {
                    setState(() {
                      isWalletVisible = true;
                      passwordController.clear();
                    });
                    Navigator.of(context).pop();
                  } else {
                    ToastNotifications.showNotification(
                        context: context,
                        msg: "Contraseña incorrecta",
                        type: ToastificationType.error);
                  }
                },
                child: const CustomButton(
                      color: ThemeColors.titleOne,
                      colorBorder: ThemeColors.borderWhite,
                      colorText: ThemeColors.textAlt,
                      title: "Aceptar",
                    ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<ProviderGeneral>(context);
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            width: size.width * 1,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (editPDF == false)
                  SizedBox(
                    height: size.height * 0.6,
                    width: size.width * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          color: ThemeColors.titleOne,
                          fontSize: 3.3,
                          fontWeight: FontWeight.w500,
                          text: "Tu Firma",
                          textAlign: TextAlign.center,
                        ),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText(
                              color: ThemeColors.titleOne,
                              fontSize: 2,
                              fontWeight: FontWeight.w400,
                              text: "Seleccionar documento",
                              textAlign: TextAlign.center,
                            )),
                        CustomDropdown(
                            items: pdfNamesToShow,
                            value: documentSelected,
                            onChanged: (newValue) {
                              int index =
                                  pdfNamesToShow.indexOf(newValue ?? '');
                              documentPathSelected = pdfPathsToShow[index];
                              setState(() {
                                documentSelected = newValue ?? '';
                              });
                            }),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            !isWalletVisible
                                ? 'Desbloquea tu billetera'
                                : 'Seleccionar firma',
                            style: ThemeText.medium(15, ThemeColors.titleOne),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Visibility(
                          visible: !isWalletVisible,
                          child: SizedBox(
                            height: size.height * 0.15,
                            child: GestureDetector(
                              onTap: () {
                                _showPasswordDialog(context);
                              },
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _animation.value,
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.fingerprint,
                                          size: 25 *
                                              SizeConfig.imageSizeMultiplier,
                                          color: ThemeColors.titleOne,
                                        ),
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isWalletVisible,
                          child: Column(
                            children: [
                              CustomDropdown(
                                items: imageNamesToShow,
                                value: signSelected,
                                onChanged: (newValue) {
                                  imgIndex =
                                      imageNamesToShow.indexOf(newValue ?? '');
                                  signPathSelected = imagePathsToShow[imgIndex];
                                  setState(() {
                                    signSelected = newValue ?? '';
                                  });
                                },
                              ),
                              CustomInput(
                                  controller: passwordController,
                                  hintText: "Ingrese contraseña de la firma",
                                  visible: true),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        GestureDetector(
                          onTap: () => provider.activeStep = 1,
                          child: const CustomButton(
                              color: Colors.transparent,
                              colorBorder: ThemeColors.titleOne,
                              colorText: ThemeColors.titleOne,
                              title: "Cancelar"),
                        ),
                        if (signPathSelected != '' &&
                            documentPathSelected != '')
                          GestureDetector(
                              onTap: () {
                                if (passwordController.text !=
                                    imagePasswordToShow[imgIndex]) {
                                  ToastNotifications.showNotification(
                                      context: context,
                                      msg:
                                          "La contraseña de la firma no es la correcta",
                                      type: ToastificationType.error);
                                  return;
                                }
                                setState(() {
                                  editPDF = true;
                                });
                              },
                              child: const CustomButton(
                                  color: ThemeColors.titleOne,
                                  colorBorder: ThemeColors.borderWhite,
                                  colorText: ThemeColors.textAlt,
                                  title: "Continuar")),
                        if (signPathSelected == '' ||
                            documentPathSelected == '')
                          GestureDetector(
                            onTap: () => ToastNotifications.showNotification(
                                context: context,
                                msg:
                                    "Seleccione documento y firma para continuar",
                                type: ToastificationType.error),
                            child: const CustomButton(
                                color: ThemeColors.background,
                                colorBorder: ThemeColors.borderWhite,
                                colorText: ThemeColors.septenary,
                                title: "Continuar"),
                          ),
                      ],
                    ),
                  ),
                if (editPDF == true)
                  EditPdfScreen(
                      pdfPath: documentPathSelected, imgPath: signPathSelected)
              ],
            ),
          );
  }
}
