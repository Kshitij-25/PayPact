import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

import 'app.dart';
import 'core/routes/app_router.dart';
import 'core/services/firebase_service.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferences.getInstance();

  await FirebaseService().initialize();

  await init();

  await AppRouter.setupRoutes();

  // NetworkHelper.initialize();

  if (kDebugMode) {
    HttpOverrides.global = CustomHttpOverrides();
  }

  runApp(ProviderScope(child: const MainApp()));
}

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}



// dipil10828@isorax.com