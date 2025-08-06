import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/constants/network_helper.dart';
import 'core/routes/app_router.dart';
import 'core/themes/theme.dart';
import 'core/themes/util.dart';
import 'presentation/screens/misc/no_internet_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(context, "Nunito Sans", "Montserrat");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return InternetWrapper(
          child: child ?? const SizedBox(), // Handle null child case
        );
      },
    );
  }
}

class InternetWrapper extends ConsumerWidget {
  final Widget child;

  const InternetWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<bool>(
      stream: NetworkHelper.internetStatusStream,
      builder: (context, snapshot) {
        // Show loading while checking connection
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Show no internet screen if no connection
        if (snapshot.data == false) {
          return const NoInternetScreen();
        }

        // Show child if connected
        return child;
      },
    );
  }
}
