import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_tl/presentation/screens/screens.dart';
import 'package:test_tl/presentation/widgets/widgets.dart';
import 'package:test_tl/presentation/providers/main_provider.dart';
import 'package:test_tl/config/theme/colors.dart';

class SignDocumentsPage extends StatelessWidget {
  const SignDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainTheme(
      screenToShow: SignPageBody(),
    );
  }
}

class SignPageBody extends StatelessWidget {
  const SignPageBody({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<ProviderGeneral>(context);
    return SizedBox(
      width: size.width * 1,
      height: size.height * 0.8,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.keyboard_arrow_left)),
                const CustomText(
                    color: ThemeColors.titleOne,
                    fontSize: 2.5,
                    fontWeight: FontWeight.w600,
                    text: 'Firmar Documentos',
                    textAlign: TextAlign.left),
              ],
            ),
            EasyStepper(
              activeStep: provider.activeStep,
              stepShape: StepShape.rRectangle,
              stepBorderRadius: 50,
              borderThickness: 0,
              showStepBorder: false,
              padding:
                  const EdgeInsets.symmetric(vertical: 20), // Ajuste de padding
              stepRadius: 30, 
              finishedStepTextColor: ThemeColors.sucess,
              finishedStepIconColor: ThemeColors.bodyWhite,
              finishedStepBackgroundColor: ThemeColors.sucess,
              activeStepBackgroundColor: ThemeColors.activate, 
              activeStepTextColor: Colors.white, 
              showLoadingAnimation: true,
              steps: [
                step(provider, "Cargar documentos", Icons.document_scanner),
                step(provider, "Indicar firmantes", Icons.supervisor_account_outlined),
                step(provider, "Personalización", Icons.bookmark_add_outlined),
                step(provider, "Resumen", Icons.description_outlined),
              ],
            ),
            if (provider.activeStep == 0) const LoadPdfScreen(),
            if (provider.activeStep == 1) const LoadImgScreen(),
            if (provider.activeStep == 2) const PersonalizeScreen(),
            if (provider.activeStep == 3) const SummaryScreen(),
          ],
        ),
      ),
    );
  }

  EasyStep step(ProviderGeneral provider, String title, IconData icon) {
    return EasyStep(
      customStep: ClipRRect(
        borderRadius: BorderRadius.circular(1),
        child: Opacity(
            opacity: provider.activeStep >= 0 ? 1 : 0.3, child: Icon(icon)),
      ),
      customTitle: Text(
        title,
        textAlign: TextAlign.center,
      ),
    );
  }
}
