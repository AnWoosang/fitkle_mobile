import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';
import 'core/config/env_config.dart';
import 'core/config/supabase_client.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/error/error_handler.dart';
import 'core/error/error_widget.dart';
import 'core/utils/app_debug.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  // Run app in error zone to catch all errors
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // 1. 환경변수 로드
      await EnvConfig.initialize();

      // 2. 환경변수 유효성 검사
      EnvConfig.validate();

      // 3. Set up comprehensive debugging system (개발 환경에서만)
      if (EnvConfig.isDevelopment) {
        AppDebug.initialize();
        EnvConfig.printDebugInfo();
      }

      // 4. Set up custom error widget for release mode
      ErrorWidget.builder = (FlutterErrorDetails details) {
        return AppErrorWidget(errorDetails: details);
      };

      // 5. Supabase 초기화
      await SupabaseClientManager.initialize();

      runApp(
        DevicePreview(
          enabled: EnvConfig.isDevelopment, // 개발 환경에서만 활성화
          builder: (context) => const ProviderScope(
            child: FitkleApp(),
          ),
        ),
      );
    },
    (error, stack) {
      // Catch errors not caught by Flutter framework
      if (EnvConfig.isDevelopment) {
        AppDebug.logError(error, stack, context: 'Uncaught Zone Error');
      }
      ErrorHandler.handleError(error, stack);
    },
  );
}

class FitkleApp extends ConsumerStatefulWidget {
  const FitkleApp({super.key});

  @override
  ConsumerState<FitkleApp> createState() => _FitkleAppState();
}

class _FitkleAppState extends ConsumerState<FitkleApp> {
  @override
  void initState() {
    super.initState();
    // 앱 시작 시 현재 사용자 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: EnvConfig.appName,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      // Device Preview 설정
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
    );
  }
}
