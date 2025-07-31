import 'package:flutter/cupertino.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasources/remote/group_remote_source.dart';
import '../../core/constants/routes_constants.dart';

class GroupsScreen extends HookConsumerWidget {
  const GroupsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsProvider);

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color shadowColor = isDarkMode ? Colors.black54 : Colors.white;
    Color lightShadow = isDarkMode ? Colors.black38 : Colors.grey[400]!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text('Create Group'),
            onPressed: () {
              context.pushNamed(Routes.createGroupScreen);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: groupsAsync.when(
          data: (groups) => groups.isEmpty
              ? Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You\'re all squared away, champ! 💸 No debts, no worries—just vibes. Keep the peace with PayPact! ✌️😎',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(Routes.createGroupScreen);
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
                          'Create a group',
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return ListTile(
                      // leading: Icon(
                      //   group.type == 'Trip'
                      //       ? CupertinoIcons.airplane
                      //       : group.type == 'Home'
                      //       ? CupertinoIcons.house_fill
                      //       : group.type == 'Couple'
                      //       ? CupertinoIcons.heart_fill
                      //       : CupertinoIcons.doc_text_fill,
                      //   color: Theme.of(context).colorScheme.secondaryContainer,
                      // ),
                      title: Text(group.name),
                      onTap: () {
                        context.pushNamed(Routes.groupDetailsScreen, extra: group);
                      },
                    );
                  },
                ),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("Error: $err")),
        ),
      ),
    );
  }
}
