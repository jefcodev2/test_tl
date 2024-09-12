import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_tl/presentation/screens/signature/signature_screen.dart';
import 'package:test_tl/presentation/widgets/documents/signed_documents_screen.dart';
import 'package:test_tl/presentation/widgets/documents/pdf_view_screen.dart';
import 'package:test_tl/presentation/screens/home/home_screen.dart';
import 'package:test_tl/presentation/widgets/documents/sign_documents_screen.dart';
import 'package:test_tl/config/router/routes_names.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      getGoRouter(
        path: RouteNames.home,
        widget: (state) => const HomeScreen(),
      ),
      getGoRouter(
        path: RouteNames.signdocuments,
        widget: (state) => const SignDocumentsPage(),
      ),
      getGoRouter(
          name: RouteNames.pdf,
          path: "${RouteNames.pdf}/:path/:title",
          widget: (state) {
            return PdfViewerPage(
              pdfPath: state.pathParameters['path']!,
              title: state.pathParameters['title']!,
            );
          }),
      getGoRouter(
        path: RouteNames.signedocuments,
        widget: (state) => const SignedDocumentsScreen(),
      ),
      getGoRouter(
        path: RouteNames.signatures,
        widget: (state) => const SignatureScreen(),
      ),
    ],
    redirectLimit: 5,
    redirect: (context, state) async {
      final currentRoute = state.matchedLocation;

      if (currentRoute == "/") {
        return RouteNames.home;
      }

      if (currentRoute != "/") {
        return currentRoute;
      }

      return null;
    },
  );

  static GoRoute getGoRouter({
    required String path,
    required Widget Function(GoRouterState) widget,
    String? name,
  }) {
    return GoRoute(
        name: name ?? path,
        path: path,
        pageBuilder: (context, goState) => CustomTransitionPage(
              key: goState.pageKey,
              child: widget(goState),
              transitionsBuilder: (context, animation, secondaryAnimation,
                      child) =>
                  FadeTransition(
                      opacity: CurveTween(curve: Curves.easeInOut)
                          .animate(animation),
                      alwaysIncludeSemantics: true,
                      child: child),
            ));
  }
}
