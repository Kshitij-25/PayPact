import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/group_model.dart';

class GroupDetailsScreen extends HookConsumerWidget {
  const GroupDetailsScreen({super.key, required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Group Details')),
      body: Column(
        children: [
          Text(group.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('No expenses here yet.'),
          ElevatedButton(onPressed: () {}, child: Text('Add members')),
          TextButton(onPressed: () {}, child: Text('Share a link')),
        ],
      ),
    );
  }
}
