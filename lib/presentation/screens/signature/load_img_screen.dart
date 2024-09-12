import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:test_tl/presentation/widgets/widgets.dart';
import 'package:test_tl/config/helpers/toast_notifications.dart';
import 'package:test_tl/presentation/providers/main_provider.dart';
import 'package:test_tl/config/theme/colors.dart';
import 'package:test_tl/config/theme/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class LoadImgScreen extends StatefulWidget {
  const LoadImgScreen({super.key});

  @override
  State<LoadImgScreen> createState() => _LoadIMGViewState();
}

class _LoadIMGViewState extends State<LoadImgScreen> {
  List<String> imagePathsToShow = [];
  List<String> imageNamesToShow = [];
  List<String> imagePasswordToShow = [];

  bool isLoading = true;

  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePathsToShow = prefs.getStringList('image_path_list') ?? [];
      imageNamesToShow = prefs.getStringList('image_name_list') ?? [];
      imagePasswordToShow = prefs.getStringList('image_pw_list') ?? [];
      isLoading = false;
    });
  }

  Future<XFile?> _pickImage() async {
    final picker = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);
    return picker;
  }

  Future<String?> _saveImageToFile(XFile file) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().toIso8601String()}.jpg';
    final newFile = File('${directory.path}/$fileName}');
    await file.saveTo(newFile.path);
    return newFile.path;
  }

  _saveImageToPrefs(String path, String name, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? imagePaths = prefs.getStringList('image_path_list') ?? [];
    List<String>? imageNames = prefs.getStringList('image_name_list') ?? [];
    List<String>? imagePassword = prefs.getStringList('image_pw_list') ?? [];
    imagePaths.add(path);
    imageNames.add(name);
    imagePassword.add(password);
    await prefs.setStringList('image_path_list', imagePaths);
    await prefs.setStringList('image_name_list', imageNames);
    await prefs.setStringList('image_pw_list', imagePassword);
    await _loadImages();
  }

  _deleteImageToPrefs(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? imagePaths = prefs.getStringList('image_path_list') ?? [];
    List<String>? imageNames = prefs.getStringList('image_name_list') ?? [];
    List<String>? imagePassword = prefs.getStringList('image_pw_list') ?? [];
    imagePaths.removeAt(index);
    imageNames.removeAt(index);
    imagePassword.removeAt(index);
    await prefs.setStringList('image_path_list', imagePaths);
    await prefs.setStringList('image_name_list', imageNames);
    await prefs.setStringList('image_pw_list', imagePassword);
    await _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<ProviderGeneral>(context);
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            height: size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Sube tus firmas"), Icon(Icons.info_outline)],
                ),
                if (imagePathsToShow.isEmpty)
                  GestureDetector(
                    onTap: () {
                      _uploadImage(size, provider);
                    },
                    child: Container(
                      color: ThemeColors.background,
                      width: size.width * 0.9, 
                      height: size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image,
                            size: 80,
                          ),
                          Text("Subir firma",
                              style:
                                  ThemeText.medium(18, ThemeColors.titleOne)),
                          const Text(
                            "JPG/PNG 20MB",
                            style: TextStyle(color: ThemeColors.septenary),
                          )
                        ],
                      ),
                    ),
                  ),
                if (imagePathsToShow.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: size.width * 0.9, 
                          height: size.height * 0.2,
                          child: ListView.builder(
                            itemCount: imagePathsToShow.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  _option(size, imagePathsToShow[index],
                                      imageNamesToShow[index], index),
                                  if (index == imagePathsToShow.length - 1)
                                    GestureDetector(
                                        onTap: () {
                                          _uploadImage(size, provider);
                                        },
                                        child: const CustomButton(
                                            color: ThemeColors.background,
                                            colorBorder: ThemeColors.septenary,
                                            colorText: ThemeColors.titleOne,
                                            title: "+ Añadir más firmas")),
                                ],
                              );
                            },
                          )),
                    ],
                  ),
                GestureDetector(
                  onTap: () => provider.activeStep = 0,
                  child: const CustomButton(
                      color: Colors.transparent,
                      colorBorder: ThemeColors.titleOne,
                      colorText: ThemeColors.titleOne,
                      title: "Cancelar"),
                ),
                if (imagePathsToShow.isNotEmpty)
                  GestureDetector(
                      onTap: () {
                        provider.activeStep = 2;
                      },
                      child: const CustomButton(
                          color: ThemeColors.titleOne,
                          colorBorder: ThemeColors.borderWhite,
                          colorText: ThemeColors.textAlt,
                          title: "Continuar")),
                if (imagePathsToShow.isEmpty)
                  GestureDetector(
                    onTap: () => ToastNotifications.showNotification(
                        context: context,
                        msg: "Suba una firma para continuar",
                        type: ToastificationType.error),
                    child: const CustomButton(
                        color: ThemeColors.background,
                        colorBorder: ThemeColors.borderWhite,
                        colorText: ThemeColors.septenary,
                        title: "Continuar"),
                  ),
              ],
            ),
          );
  }

 _uploadImage(Size size, ProviderGeneral provider) async {
  bool isDialogClosed = false;

  await SmartDialog.show(
    clickMaskDismiss: false,
    backDismiss: false,
    builder: (context) {
      return Container(
        height: size.height * 0.45,
        width: size.width * 0.9,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ThemeColors.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nueva firma",
                  style: ThemeText.semiBold(20, ThemeColors.titleOne),
                ),
                const SizedBox(height: 10),
                CustomInput(
                  controller: nameController,
                  hintText: "Nombre Certificado",
                  visible: false,
                ),
                CustomInput(
                  controller: passwordController,
                  hintText: "Contraseña",
                  visible: true,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      if (nameController.text == '' || passwordController.text == '') {
                        ToastNotifications.showNotification(
                          context: context,
                          msg: "Algunos campos se encuentran vacíos",
                          type: ToastificationType.error,
                        );
                        return;
                      }
                      if (imageNamesToShow.contains(nameController.text)) {
                        ToastNotifications.showNotification(
                          context: context,
                          msg: "No puede subir firma con nombre duplicado",
                          type: ToastificationType.error,
                        );
                        return;
                      }
                      SmartDialog.dismiss();
                    },
                    child: const CustomButton(
                      color: ThemeColors.titleOne,
                      colorBorder: ThemeColors.borderWhite,
                      colorText: ThemeColors.textAlt,
                      title: "Continuar",
                    ),
                  ),
                ),
              ],
            ),
            // Botón de cerrar en la parte superior derecha
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: ThemeColors.titleOne),
                onPressed: () {
                  isDialogClosed = true; // Indica que el diálogo fue cerrado
                  SmartDialog.dismiss(); // Cierra el diálogo
                },
              ),
            ),
          ],
        ),
      );
    },
  );

  // Verificar si el diálogo fue cerrado manualmente
  if (isDialogClosed) {
    return; // Detener el flujo si el usuario cierra el diálogo
  }

  // Continuar solo si el usuario no cerró el diálogo manualmente
  XFile? file = await _pickImage();
  if (file != null) {
    String? path = await _saveImageToFile(file);
    if (path != null) {
      await _saveImageToPrefs(path, nameController.text, passwordController.text);
    }
  }

  nameController.text = "";
  passwordController.text = "";
}



  Widget _option(Size size, String path, String name, int index) {
    return GestureDetector(
      onTap: () async {
        await SmartDialog.show(
          builder: (context) {
            return Container(
              height: size.height * 0.4,
              width: size.width * 0.9, 
              decoration: BoxDecoration(
                  color: ThemeColors.background,
                  borderRadius: BorderRadius.circular(5)),
              child: Image.file(File(path)),
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.0004, horizontal: size.width * 0.05),
        width: size.width * 0.8, 
        decoration: BoxDecoration(
            color: ThemeColors.background,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ]),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            width: size.width * 0.5, 
            child: Text(
              name,
              style: ThemeText.medium(12, ThemeColors.septenary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
              onPressed: () async {
                await _deleteImageToPrefs(index);
              },
              icon: const Icon(Icons.delete))
        ]),
      ),
    );
  }
}
