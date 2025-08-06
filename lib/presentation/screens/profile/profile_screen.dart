import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/constants/routes_constants.dart';
import '../../state/auth_notifier.dart';
import '../../widgets/custom_avatar_widget.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color shadowColor = isDarkMode ? Colors.black54 : Colors.white;
    Color lightShadow = isDarkMode ? Colors.black38 : Colors.grey[400]!;

    // final authNotifier = ref.watch(authStateNotifierProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('User Profile', style: Theme.of(context).textTheme.headlineLarge),
              Row(
                spacing: 20,
                children: [
                  CustomAvatarWidget(
                    photoURL: FirebaseConstants.currentUser?.photoURL,
                    height: 100,
                    width: 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FirebaseConstants.currentUser?.displayName ?? '',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        FirebaseConstants.currentUser?.email ?? '',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  await ref.read(authNotifierProvider.notifier).signOut();
                  if (FirebaseConstants.currentUserId == null) {
                    if (context.mounted) {
                      context.goNamed(Routes.loginScreen);
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
                  child: Text(
                    'Log out',
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
