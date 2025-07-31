import 'package:flutter/material.dart';
import 'package:paypact/presentation/screens/no_internet_screen.dart';
import 'package:paypact/core/constants/network_helper.dart';
import 'package:paypact/core/routes/app_router.dart';
import 'package:paypact/core/themes/theme.dart';
import 'package:paypact/core/themes/util.dart';

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
      builder: (context, child) => InternetWrapper(child: child!),
    );
  }
}

class InternetWrapper extends StatelessWidget {
  final Widget child;

  const InternetWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: NetworkHelper.internetStatusStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.data!) {
          return NoInternetScreen();
        }
        return child;
      },
    );
  }
}
