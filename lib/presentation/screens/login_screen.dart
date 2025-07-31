import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:paypact/core/extensions/context_extensions.dart';

import '../../core/constants/firebase_helper.dart';
import '../../core/constants/routes_constants.dart';
import '../state/auth/auth_notifier.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color shadowColor = isDarkMode ? Colors.black54 : Colors.white;
    Color lightShadow = isDarkMode ? Colors.black38 : Colors.grey.shade400;

    // final authNotifier = ref.watch(authStateNotifierProvider.notifier);
    // final authState = ref.watch(authStateNotifierProvider);

    final state = ref.watch(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);

    if (state.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.showSnackBar(
          state.error!,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              notifier.state = state.copyWith(error: null);
            },
          ),
        );
      });
    }

    return Stack(
      children: [
        Scaffold(
          // backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Text(
                  'PAYPACT',
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),

                // ElevatedButton.icon(
                //   onPressed: () {
                //     // ref.read(loginProvider).login();
                //   },
                //   style: ElevatedButton.styleFrom(
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                //   ),
                //   label: Text('Continue with Google'),
                //   icon: Icon(Bootstrap.google),
                // ),
                GestureDetector(
                  onTap: () async {
                    // await authNotifier.signInWithGoogle();
                    await notifier.signInWithGoogle();
                    if (FirebaseHelper.currentUserId != null) {
                      if (context.mounted) {
                        context.goNamed(Routes.homeScreen);
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Theme.of(context).cardColor : const Color(0xFFE7EBF0),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: lightShadow,
                          offset: Offset(2.5, 2.5),
                          blurRadius: 5,
                          inset: false,
                        ),
                        BoxShadow(
                          color: shadowColor,
                          offset: Offset(-2.5, -2.5),
                          blurRadius: 5,
                          inset: false,
                        ),
                      ],
                    ),
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Brand(Brands.google),
                        Text(
                          'Continue with Google',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (state.isLoading)
          Container(
            color: Colors.black87,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
      ],
    );
  }
}
