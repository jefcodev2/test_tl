import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_tl/config/router/routes_names.dart';
import 'package:test_tl/presentation/widgets/widgets.dart';
import 'package:test_tl/config/theme/colors.dart';
import 'package:test_tl/config/theme/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignedDocumentsScreen extends StatelessWidget {
  const SignedDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainTheme(
      screenToShow: PDFCompleteBody(),
    );
  }
}

class PDFCompleteBody extends StatefulWidget {
  const PDFCompleteBody({super.key});

  @override
  State<PDFCompleteBody> createState() => _PDFCompleteBodyState();
}

class _PDFCompleteBodyState extends State<PDFCompleteBody> {
  List<String> pdfPathsToShow = [];
  List<String> pdfNamesToShow = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdfs();
  }

  _loadPdfs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pdfPathsToShow = prefs.getStringList('pdfs_sign_path') ?? [];
      pdfNamesToShow = prefs.getStringList('pdfs_sign_name') ?? [];
      isLoading = false;
    });
  }

  _deletePdfToPrefs(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? pdfsPath = prefs.getStringList('pdfs_sign_path') ?? [];
    List<String>? pdfsName = prefs.getStringList('pdfs_sign_name') ?? [];
    pdfsPath.removeAt(index);
    pdfsName.removeAt(index);
    await prefs.setStringList('pdfs_sign_path', pdfsPath);
    await prefs.setStringList('pdfs_sign_name', pdfsName);
    await _loadPdfs();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 1,
      height: size.height * 0.8,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.keyboard_arrow_left)),
                ),
                const CustomText(
                    color: ThemeColors.text,
                    fontSize: 3,
                    fontWeight: FontWeight.w600,
                    text: "Documentos Firmados",
                    textAlign: TextAlign.center),
                if (pdfPathsToShow.isEmpty)

                const CustomText(
                    color: Color.fromARGB(255, 224, 59, 59),
                    fontSize: 2,
                    fontWeight: FontWeight.w500,
                    text: "No hay documentos firmados",
                    textAlign: TextAlign.center),
                if (pdfPathsToShow.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: size.width * 0.8,
                          height: size.height * 0.6,
                          child: ListView.builder(
                            itemCount: pdfPathsToShow.length,
                            itemBuilder: (context, index) {
                              return option(size, pdfPathsToShow[index],
                                  pdfNamesToShow[index], index);
                            },
                          )),
                    ],
                  ),
              ],
            ),
    );
  }

  Widget option(Size size, String path, String name, int index) {
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
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ]),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            width: size.width * 0.45,
            child: Text(
              name,
              style: ThemeText.medium(12, ThemeColors.septenary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
              onPressed: () async {
                await _deletePdfToPrefs(index);
              },
              icon: const Icon(Icons.delete_outline))
        ]),
      ),
    );
  }
}
