import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/network_helper.dart';

class NoInternetScreen extends ConsumerWidget {
  // Changed to ConsumerWidget
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color shadowColor = isDarkMode ? Colors.black54 : Colors.white;
    Color lightShadow = isDarkMode ? Colors.black38 : Colors.grey.shade400;

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
                    // Use Navigator instead of GoRouter for basic pop
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Theme.of(context).cardColor : const Color(0xFFE7EBF0),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: lightShadow,
                        offset: const Offset(2.5, 2.5),
                        blurRadius: 5,
                        inset: false,
                      ),
                      BoxShadow(
                        color: shadowColor,
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
