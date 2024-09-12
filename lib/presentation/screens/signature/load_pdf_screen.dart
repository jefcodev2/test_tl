import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_tl/presentation/widgets/shared/custom_button.dart';
import 'package:test_tl/config/helpers/toast_notifications.dart';
import 'package:test_tl/presentation/providers/main_provider.dart';
import 'package:test_tl/config/router/routes_names.dart';
import 'package:test_tl/config/theme/colors.dart';
import 'package:test_tl/config/theme/texts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class LoadPdfScreen extends StatefulWidget {
  const LoadPdfScreen({super.key});

  @override
  State<LoadPdfScreen> createState() => _LoadPDFViewState();
}

class _LoadPDFViewState extends State<LoadPdfScreen> {
  List<String> pdfPathsToShow = [];
  List<String> pdfNamesToShow = [];
  List<String> pdfSizeToShow = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdfs();
  }

  _loadPdfs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pdfPathsToShow = prefs.getStringList('pdfs_path') ?? [];
      pdfNamesToShow = prefs.getStringList('pdfs_name') ?? [];
      pdfSizeToShow = prefs.getStringList('pdfs_size') ?? [];
      isLoading = false;
    });
  }

  Future<Map<String, String>?> _pickPdf() async {
  final contextBeforeAsync = context; // Captura el contexto antes de la operación async
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null && result.files.isNotEmpty) {
    final file = result.files.first;
    if (pdfNamesToShow.contains(file.name)) {
      if (mounted) {
        ToastNotifications.showNotification(
          // ignore: use_build_context_synchronously
          context: contextBeforeAsync,
          msg: "No puede subir documento con nombre duplicado",
          type: ToastificationType.error,
        );
      }
      return null;
    }

    return {
      'path': file.path.toString(),
      'name': file.name,
      'size': (file.size / (1024 * 1024)).toStringAsFixed(2),
    };
  }
  return null;
}


  _savePdfToPrefs(Map<String, String>? document) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? pdfsPath = prefs.getStringList('pdfs_path') ?? [];
    List<String>? pdfsName = prefs.getStringList('pdfs_name') ?? [];
    List<String>? pdfsSize = prefs.getStringList('pdfs_size') ?? [];
    pdfsPath.add(document?['path'] ?? '');
    pdfsName.add(document?['name'] ?? '');
    pdfsSize.add(document?['size'] ?? '');
    await prefs.setStringList('pdfs_path', pdfsPath);
    await prefs.setStringList('pdfs_name', pdfsName);
    await prefs.setStringList('pdfs_size', pdfsSize);
    await _loadPdfs();
  }

  _deletePdfToPrefs(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? pdfsPath = prefs.getStringList('pdfs_path') ?? [];
    List<String>? pdfsName = prefs.getStringList('pdfs_name') ?? [];
    List<String>? pdfsSize = prefs.getStringList('pdfs_size') ?? [];
    pdfsPath.removeAt(index);
    pdfsName.removeAt(index);
    pdfsSize.removeAt(index);
    await prefs.setStringList('pdfs_path', pdfsPath);
    await prefs.setStringList('pdfs_name', pdfsName);
    await prefs.setStringList('pdfs_size', pdfsSize);
    await _loadPdfs();
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
                  children: [
                    Text("Sube tus documentos"),
                    Icon(Icons.help_outline_outlined)
                  ],
                ),
                if (pdfPathsToShow.isEmpty)
                  GestureDetector(
                    onTap: () async {
                      Map<String, String>? document = await _pickPdf();
                      if (document != null) {
                        await _savePdfToPrefs(document);
                      }
                    },
                    child: Container(
                      color: ThemeColors.background,
                      width: size.width * 0.8,
                      height: size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.upload_file,
                            size: 60,
                          ),
                          Text("Subir documento",
                              style: ThemeText.semiBold(17, ThemeColors.titleOne)),
                          const Text(
                            "PDF 20MB",
                            style: TextStyle(color: ThemeColors.septenary),
                          )
                        ],
                      ),
                    ),
                  ),
                if (pdfPathsToShow.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: size.width * 0.8,
                          height: size.height * 0.30,
                          child: ListView.builder(
                            itemCount: pdfPathsToShow.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  _option(
                                    size,
                                    pdfPathsToShow[index],
                                    pdfNamesToShow[index],
                                    pdfSizeToShow[index],
                                    index
                                  ),
                                  if (index == pdfPathsToShow.length - 1) // Añadir aquí el botón al final
                                    GestureDetector(
                                      onTap: () async {
                                        Map<String, String>? document = await _pickPdf();
                                        if (document != null) {
                                          await _savePdfToPrefs(document);
                                        }
                                      },
                                      child: const CustomButton(
                                        color: ThemeColors.background,
                                        colorBorder: ThemeColors.septenary,
                                        colorText: ThemeColors.titleOne,
                                        title: "+ Añadir más documentos"
                                      ),
                                    ),
                                ],
                              );
                            },
                          )),
                    ],
                  ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const CustomButton(
                      color: Colors.transparent,
                      colorBorder: ThemeColors.titleOne,
                      colorText: ThemeColors.titleOne,
                      title: "Cancelar"),
                ),
                if (pdfPathsToShow.isNotEmpty)
                  GestureDetector(
                      onTap: () => provider.activeStep = 1,
                      child: const CustomButton(
                          color: ThemeColors.titleOne,
                          colorBorder: ThemeColors.borderWhite,
                          colorText: ThemeColors.textAlt,
                          title: "Continuar")),
                if (pdfPathsToShow.isEmpty)
                  GestureDetector(
                    onTap: () => ToastNotifications.showNotification(
                        context: context,
                        msg: "Suba un documento para continuar",
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

  Widget _option(
      Size size, String path, String name, String sizeDoc, int index) {
    return GestureDetector(
      onTap: () async {
        context.pushNamed(
          RouteNames.pdf,
          pathParameters: {
            'path': path,
            'title': name,
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.004, horizontal: size.width * 0.05),
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
          ],
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            width: size.width * 0.4,
            child: Text(
              name,
              style: ThemeText.medium(12, ThemeColors.septenary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () async {
                    await SmartDialog.show(
                      builder: (context) {
                        return Container(
                          height: size.height * 0.1,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              color: ThemeColors.background,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text("El tamaño es de $sizeDoc MB")),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.info)),
              IconButton(
                  onPressed: () async {
                    await _deletePdfToPrefs(index);
                  },
                  icon: const Icon(Icons.delete_outline_outlined)),
            ],
          )
        ]),
      ),
    );
  }
}
