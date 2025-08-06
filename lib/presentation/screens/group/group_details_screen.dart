import 'package:flutter/cupertino.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/routes_constants.dart';
import '../../../data/model/group_model.dart';
import '../../widgets/custom_container.dart';

class GroupDetailsScreen extends HookConsumerWidget {
  const GroupDetailsScreen({super.key, required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color shadowColor = isDarkMode ? Colors.black54 : Color(0xFFF9FAFF);
    Color lightShadow = isDarkMode ? Colors.black38 : Color(0xFFA6AABC);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.gear_solid),
            onPressed: () {
              context.pushNamed(Routes.groupSettingsScreen, extra: group);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              group.name,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Settle up',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Remind...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Total',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Export',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDarkMode ? Theme.of(context).cardColor : const Color(0xFFE7EBF0),
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
        child: IconButton(
          color: isDarkMode ? Color(0xFFE7EBF0) : const Color(0xFF1F2937),
          icon: Icon(CupertinoIcons.add),
          onPressed: () => context.pushNamed(
            Routes.addExpenseScreen,
          ),
        ),
      ),
    );
  }
}
