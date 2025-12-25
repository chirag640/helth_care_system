import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/auth/token_storage.dart';
import 'core/config/env_loader.dart';
import 'core/database/hive_database.dart';
import 'core/services/system_ui_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize edge-to-edge transparent system UI
  SystemUIService.initialize(isDark: false);

  await EnvLoader.load();
  await HiveDatabase.instance.init();
  await TokenStorage.instance.init();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
