import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:test_tl/presentation/providers/main_provider.dart';
import 'package:test_tl/config/router/router.dart';
import 'package:test_tl/config/theme/colors.dart';
import 'package:test_tl/utils/size_config.dart';

void main()  {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProviderGeneral()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return MaterialApp.router(
          title: 'PDF APP',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: ThemeColors.background,
          ),
          builder: FlutterSmartDialog.init(
            builder: (context, child) {
              return child ?? Container();
            },
          ),
          routeInformationParser: AppRouter.router.routeInformationParser,
          routerDelegate: AppRouter.router.routerDelegate,
          routeInformationProvider: AppRouter.router.routeInformationProvider,
        );
      });
    });
  }
}
