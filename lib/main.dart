import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/app.dart';
import 'package:gamified/src/common/config/environment_config.dart';
import 'package:media_kit/media_kit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  final config = ClarityConfig(
    projectId: "sgrwd2iz77",
    logLevel: LogLevel
        .None, // Note: Use "LogLevel.Verbose" value while testing to debug initialization issues.
  );

  await Supabase.initialize(
    url: EnvironmentConfig.supabaseUrl,
    anonKey: EnvironmentConfig.supabaseAnonKey,
  );
  runApp(
    ClarityWidget(
      app: ProviderScope(child: MainApp()),
      clarityConfig: config,
    ),
  );
}
