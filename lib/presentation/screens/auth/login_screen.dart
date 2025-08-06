import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/constants/routes_constants.dart';
import '../../state/auth_notifier.dart';
import '../../widgets/custom_container.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'PAYPACT',
                    style: theme.textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  _GoogleSignInButton(ref: ref),
                ],
              ),
            ),
          ),
          if (authState.isLoading)
            Container(
              color: Colors.black87,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        await ref.read(authNotifierProvider.notifier).signInWithGoogle();
        if (FirebaseConstants.currentUserId != null) {
          if (context.mounted) {
            context.goNamed(Routes.homeScreen);
          }
        }
      },
      child: CustomContainer(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Brand(Brands.google),
            const SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
