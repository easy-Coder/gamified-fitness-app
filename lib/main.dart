import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/app.dart';
import 'package:media_kit/media_kit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  await Supabase.initialize(
    url: 'https://eufwwscytiylpdklfztt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV1Znd3c2N5dGl5bHBka2xmenR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjUyMDQxNDUsImV4cCI6MjA0MDc4MDE0NX0.NWPYf4K2h75bR2WNoMGGioXMaT1WyiuRXN9IwiD499s',
  );
  runApp(
    ProviderScope(
      child: MainApp(),
    ),
  );
}
