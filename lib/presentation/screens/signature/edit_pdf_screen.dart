import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_tl/presentation/widgets/widgets.dart';
import 'package:test_tl/config/helpers/toast_notifications.dart';
import 'package:test_tl/presentation/providers/main_provider.dart';
import 'package:test_tl/config/theme/colors.dart';
import 'package:test_tl/config/theme/texts.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:toastification/toastification.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as path;

class EditPdfScreen extends StatefulWidget {
  final String pdfPath;
  final String imgPath;
  const EditPdfScreen(
      {super.key, required this.pdfPath, required this.imgPath});

  @override
  State<EditPdfScreen> createState() => _EditPdfScreenState();
}

class _EditPdfScreenState extends State<EditPdfScreen> {
  Offset imagePosition = const Offset(50, 50);
  GlobalKey pdfViewerKey = GlobalKey();
  String pdfPathToEdit = '';
  PdfViewerController pdfViewerController = PdfViewerController();
  int pageNumber = 1;
  double pdfHeight = 0;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  _loadPdf() async {
    final contextBeforeAsync = context;
    try {
      final file = File(widget.pdfPath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        final directory = await getApplicationDocumentsDirectory();
        final path = directory.path;
        final tempFile = File('$path/temp_sample.pdf');
        await tempFile.writeAsBytes(bytes, flush: true);

        PdfDocument document = PdfDocument(inputBytes: bytes);
        PdfPage page = document.pages[0];
        Size pageSize = page.size;
        double aspectRatio = pageSize.height / pageSize.width;

        if (mounted) {
          setState(() {
            pdfPathToEdit = tempFile.path;
            pdfHeight = (MediaQuery.of(context).size.width * 0.9) * aspectRatio;
          });
        }
        document.dispose();
      } else {
        if (mounted) {
          ToastNotifications.showNotification(
              // ignore: use_build_context_synchronously
              context: contextBeforeAsync,
              msg:
                  "El archivo no existe en la ruta especificada: ${widget.pdfPath}",
              type: ToastificationType.error);
        }
      }
    } catch (e) {
      if (mounted) {
        ToastNotifications.showNotification(
            // ignore: use_build_context_synchronously
            context: contextBeforeAsync,
            msg: "Error cargando el PDF: $e",
            type: ToastificationType.error);
      }
    }
  }

  _editPdf(Size size) async {
    final contextBeforeAsync = context;
    try {
      File file = File(pdfPathToEdit);
      List<int> bytes = await file.readAsBytes();
      PdfDocument document = PdfDocument(inputBytes: bytes);

      int currentPageIndex = pdfViewerController.pageNumber - 1;
      PdfPage page = document.pages[currentPageIndex];

      File imgFile = File(widget.imgPath);
      PdfBitmap? image;
      if (await imgFile.exists()) {
        Uint8List imageBytes = await imgFile.readAsBytes();
        image = PdfBitmap(imageBytes);
      } else {
        if (mounted) {
          ToastNotifications.showNotification(
              // ignore: use_build_context_synchronously
              context: contextBeforeAsync,
              msg:
                  "El archivo de imagen no existe en la ruta especificada: ${widget.imgPath}",
              type: ToastificationType.error);
        }
      }

      const double width = 80;
      const double height = 80;
      Size pageSize = page.size;
      double y = ((imagePosition.dy) * (pageSize.height) / (size.height * 0.6));
      double x = ((imagePosition.dx) * (pageSize.width) / (size.width * 0.9));
      page.graphics
          .drawImage(image!, Rect.fromLTWH(x - 80, y - 120, width, height));

      List<int> editedPdfBytes = await document.save();
      document.dispose();

      final directory = await getApplicationDocumentsDirectory();
      String originalFileName = path.basenameWithoutExtension(widget.pdfPath);
      String newFileName = '$originalFileName-signed.pdf';
      final editedFile = File('${directory.path}/$newFileName');
      final documentSign =
          await editedFile.writeAsBytes(editedPdfBytes, flush: true);
      await _savePdfToPrefs(documentSign.path, newFileName);

      if (mounted) {
        ToastNotifications.showNotification(
            // ignore: use_build_context_synchronously
            context: contextBeforeAsync,
            msg: "PDF firmado en: ${directory.path}/$newFileName",
            type: ToastificationType.error);
      }
    } catch (e) {
      if (mounted) {
        ToastNotifications.showNotification(
            // ignore: use_build_context_synchronously
            context: contextBeforeAsync,
            msg: "Error al firmar el PDF: $e",
            type: ToastificationType.error);
      }
    }
  }

  _savePdfToPrefs(String path, String name) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? pdfsPath = prefs.getStringList('pdfs_sign_path') ?? [];
    List<String>? pdfsName = prefs.getStringList('pdfs_sign_name') ?? [];
    pdfsPath.add(path);
    pdfsName.add(name);
    await prefs.setStringList('pdfs_sign_path', pdfsPath);
    await prefs.setStringList('pdfs_sign_name', pdfsName);
  }

  _goToPreviousPage() {
    if (pdfViewerController.pageNumber > 1) {
      pdfViewerController.previousPage();
      setState(() {
        pageNumber = pdfViewerController.pageNumber;
      });
    }
  }

  _goToNextPage() {
    if (pdfViewerController.pageNumber < pdfViewerController.pageCount) {
      pdfViewerController.nextPage();
      setState(() {
        pageNumber = pdfViewerController.pageNumber;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<ProviderGeneral>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size.height * 0.05,
          width: size.width * 0.9,
          child: const CustomText(
              color: ThemeColors.quaternary,
              fontSize: 3,
              fontWeight: FontWeight.w600,
              text: 'Posicionar la firma',
              textAlign: TextAlign.center),
        ),
        SizedBox(
          width: size.width * 0.9,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      imagePosition = const Offset(50, 50);
                    });
                  },
                  icon: const Icon(Icons.refresh)),
              SizedBox(
                  width: size.width * 0.75,
                  child: const CustomText(
                    color: ThemeColors.borderBlack,
                    fontSize: 1.4,
                    fontWeight: FontWeight.w500,
                    text:
                        "Seleccione el firmante y pincha en donde deseas que se estampen las firmas e iniciales",
                    textAlign: TextAlign.justify,
                  )),
            ],
          ),
        ),
        Stack(
          children: [
            SizedBox(
              height: pdfHeight,
              width: size.width * 0.9,
              child: pdfPathToEdit.isNotEmpty
                  ? SfPdfViewer.file(
                      File(pdfPathToEdit),
                      key: pdfViewerKey,
                      controller: pdfViewerController,
                      enableDoubleTapZooming: false,
                      canShowScrollHead: false,
                      canShowPaginationDialog: false,
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            SizedBox(
              height: pdfHeight,
              width: size.width * 0.9,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    imagePosition = details.localPosition;
                  });
                },
                child: Stack(
                  children: [
                    Positioned(
                      left: imagePosition.dx - 50,
                      top: imagePosition.dy - 50,
                      child: Opacity(
                          opacity: 0.5,
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ThemeColors.quaternary,
                                      width: 0.2 * size.height / 100),
                                  borderRadius: BorderRadius.circular(5)),
                              height: 5 * size.height / 100,
                              width: 8 * size.height / 100,
                              child: const Icon(
                                FontAwesomeIcons.signature,
                                color: ThemeColors.borderBlack,
                              ))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: _goToPreviousPage,
              icon: const Icon(Icons.keyboard_arrow_left),
            ),
            Text(pageNumber.toString()),
            IconButton(
              onPressed: _goToNextPage,
              icon: const Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        RichText(
            text: TextSpan(
          children: [
            TextSpan(
                text: 'Importante: ',
                style: ThemeText.extraBold(12, ThemeColors.text)),
            TextSpan(
                text:
                    'el certificado de Firma Electrónica, solo se podrá posicionar una vez en el documento. Toma en cuenta que el certificado firma todo el documento y no sólo una hoja en particular',
                style: ThemeText.normal(12, ThemeColors.text)),
          ],
        )),
        SizedBox(
          height: size.height * 0.02,
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        GestureDetector(
          onTap: () {
            _editPdf(size);
            provider.activeStep = 3;
          },
          child: const CustomButton(
              color: ThemeColors.titleOne,
              colorText: ThemeColors.textAlt,
              title: "Finalizar",
              colorBorder: ThemeColors.titleOne),
        ),
      ],
    );
  }
}
