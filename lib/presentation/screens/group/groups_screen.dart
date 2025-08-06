import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/routes_constants.dart';
import '../../../data/model/group_model.dart';
import '../../../domain/entities/group_entity.dart';
import '../../state/group_notifier.dart';
import '../../widgets/custom_container.dart';

class GroupsScreen extends HookConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupState = ref.watch(groupNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => context.pushNamed(Routes.createGroupScreen),
            child: const Text('Create Group'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: groupState.when(
          data: (groups) {
            if (groups.isEmpty) return _buildEmptyState(context);

            return ListView.separated(
              itemCount: groups.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _GroupTile(group: groups[index]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You\'re all squared away, champ! 💸 No debts, no worries—just vibes. Keep the peace with PayPact! ✌️😎',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.pushNamed(Routes.createGroupScreen),
            child: CustomContainer(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Text(
                'Create a group',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final GroupModel group;

  const _GroupTile({required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    IconData icon;
    switch (group.type) {
      case GroupType.trip:
        icon = CupertinoIcons.airplane;
        break;
      case GroupType.home:
        icon = CupertinoIcons.house_fill;
        break;
      case GroupType.couple:
        icon = CupertinoIcons.heart_fill;
        break;
      default:
        icon = CupertinoIcons.doc_text_fill;
        break;
    }

    return GestureDetector(
      onTap: () => context.pushNamed(Routes.groupDetailsScreen, extra: group),
      child: CustomContainer(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        child: Row(
          children: [
            CustomContainer(
              height: 50,
              width: 50,
              shape: BoxShape.circle,
              inset: true,
              child: Icon(
                icon,
                color: theme.colorScheme.secondaryContainer,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                group.name,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
