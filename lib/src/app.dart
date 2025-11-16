import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flash/flash_helper.dart';
import 'package:gamified/src/common/theme/app_theme.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:gamified/src/router/app_startup.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MainApp extends ConsumerWidget {
  MainApp({super.key});

  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider(_rootNavigatorKey));
    return ScreenUtilInit(
      ensureScreenSize: true,
      builder:
          (context, child) =>
              Toast(navigatorKey: _rootNavigatorKey, child: child!),
      child: ShadApp.router(
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        routerDelegate: router.routerDelegate,
        theme: AppTheme.light(),
        builder: (_, child) => AppStartup(child: child!),
      ),
    );
  }
}
