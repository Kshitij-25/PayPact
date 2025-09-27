import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/network_helper.dart';
import '../../../core/constants/theme_constants.dart';

class NoInternetScreen extends ConsumerWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie/no-connection.json'),
              Text('No Connection', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 15),
              Text(
                'We can’t sync your expenses right now.\nCheck your internet connection.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  if (await NetworkHelper.hasInternet()) {
                    context.pop();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    color: ThemeConstants(context).isDarkMode ? Theme.of(context).cardColor : const Color(0xFFE7EBF0),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeConstants(context).lightShadow,
                        offset: const Offset(2.5, 2.5),
                        blurRadius: 5,
                        inset: false,
                      ),
                      BoxShadow(
                        color: ThemeConstants(context).shadowColor,
                        offset: const Offset(-2.5, -2.5),
                        blurRadius: 5,
                        inset: false,
                      ),
                    ],
                  ),
                  child: Text(
                    'Retry Connection',
                    style: Theme.of(context).textTheme.titleMedium,
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
