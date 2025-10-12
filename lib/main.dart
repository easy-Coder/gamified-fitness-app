import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/app.dart';
import 'package:gamified/src/common/providers/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = ClarityConfig(
    projectId: "sgrwd2iz77",
    logLevel: LogLevel
        .None, // Note: Use "LogLevel.Verbose" value while testing to debug initialization issues.
  );

  await dotenv.load();
  await AppDatabase.getInstance();

  runApp(
    ClarityWidget(
      app: ProviderScope(child: MainApp()),
      clarityConfig: config,
    ),
  );
}
