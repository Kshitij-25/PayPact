import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/providers/group_providers.dart';
import '../../../data/model/group_model.dart';
import '../../../data/model/user_model.dart';
import '../../state/group_notifier.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/members_search_delegate.dart';

class GroupSettingsScreen extends HookConsumerWidget {
  const GroupSettingsScreen({super.key, required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupStream = ref.watch(groupRepositoryProvider).getGroup(group.id);
    final membersState = ref.watch(groupMembersNotifierProvider(group.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Settings'),
        actions: [
          PopupMenuButton(
            enableFeedback: true,
            position: PopupMenuPosition.under,
            color: Theme.of(context).colorScheme.surface,
            elevation: 50,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'leave',
                  child: Text('Leave Group'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete Group'),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'edit') {
                // Navigate to edit group screen
              } else if (value == 'delete') {
                // Handle group deletion
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: StreamBuilder<GroupModel>(
          stream: groupStream,
          builder: (context, groupSnapshot) {
            if (groupSnapshot.hasError) {
              return Center(child: Text('Error: ${groupSnapshot.error}'));
            }
            if (!groupSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Group Members',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: membersState.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Text('Error: $error'),
                    ),
                    data: (members) => _buildMembersList(
                      ref,
                      members,
                      // groupSnapshot.data!,
                      context,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),

      //  snapshot.connectionState != ConnectionState.done
      //     ? const Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(
      //             'Group Members',
      //             style: Theme.of(context).textTheme.titleSmall,
      //           ),
      //           const SizedBox(height: 10),
      //           Expanded(
      //             child: ListView.builder(
      //               itemCount: snapshot.data!.length + 1,
      //               itemBuilder: (context, index) {
      //                 // First item: Add people tile
      //                 if (index == 0) {
      //                   return GestureDetector(
      //                     onTap: () {
      //                       showSearch(
      //                         context: context,
      //                         delegate: MembersSearchDelegate(
      //                           groupId: group.id,
      //                           existingMemberIds: group.members,
      //                           ref: ref,
      //                         ),
      //                       );
      //                     },
      //                     child: CustomContainer(
      //                       padding: const EdgeInsets.all(25),
      //                       child: Row(
      //                         spacing: 25,
      //                         children: [
      //                           const Icon(CupertinoIcons.person_add_solid, size: 25),
      //                           Text(
      //                             'Add people to group',
      //                             style: Theme.of(context).textTheme.titleMedium,
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   );
      //                 }

      //                 final member = snapshot.data![index - 1];
      //                 final name = member['name'] ?? 'No Name';
      //                 final email = member['email'] ?? 'No Email';
      //                 return Padding(
      //                   padding: const EdgeInsets.symmetric(vertical: 5),
      //                   child: CustomContainer(
      //                     padding: const EdgeInsets.all(10),
      //                     child: Row(
      //                       children: [
      //                         CircleAvatar(
      //                           radius: 25,
      //                           backgroundImage: member['photoUrl'] != null && member['photoUrl'].isNotEmpty
      //                               ? CachedNetworkImageProvider(
      //                                   member['photoUrl'],
      //                                   cacheKey: member['id'],
      //                                 )
      //                               : AssetImage('assets/default_avatar.png') as ImageProvider,
      //                         ),
      //                         SizedBox(width: 15),
      //                         Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             Text(
      //                               name,
      //                               style: Theme.of(context).textTheme.titleMedium,
      //                             ),
      //                             Text(
      //                               email,
      //                               style: Theme.of(context).textTheme.bodySmall?.copyWith(
      //                                 color: Colors.grey,
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 );
      //               },
      //             ),
      //           ),
      //         ],
      //       ),
    );
  }

  Widget _buildMembersList(WidgetRef ref, List<UserModel> members, BuildContext context) {
    return ListView.builder(
      itemCount: members.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildAddMemberTile(ref, context);
        return _buildMemberTile(members[index - 1], context);
      },
    );
  }

  Widget _buildAddMemberTile(WidgetRef ref, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: MembersSearchDelegate(
            groupId: group.id,
            existingMemberIds: group.members,
            ref: ref,
          ),
        );
      },
      child: CustomContainer(
        padding: const EdgeInsets.all(25),
        child: Row(
          children: [
            const Icon(Icons.person_add, size: 25),
            const SizedBox(width: 25),
            Text(
              'Add people to group',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(UserModel member, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: CustomContainer(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // ProfileAvatar(userId: member.userId, radius: 25),
            CircleAvatar(
              radius: 25,
              backgroundImage: member.photoUrl != null && member.photoUrl!.isNotEmpty
                  ? CachedNetworkImageProvider(
                      member.photoUrl!,
                      cacheKey: member.userId,
                    )
                  : AssetImage('assets/default_avatar.png') as ImageProvider,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name ?? 'No Name',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  member.email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (group.createdBy == member.userId)
              Icon(
                CupertinoIcons.star_fill,
                color: Colors.amber,
              ),
          ],
        ),
      ),
    );
  }

  // Future<void> _handleLeaveGroup(WidgetRef ref, BuildContext context) async {
  //   final currentUserId = ref.read(authNotifierProvider).value?.id;
  //   if (currentUserId == null) return;

  //   final confirmed = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Leave Group'),
  //       content: const Text('Are you sure you want to leave this group?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, true),
  //           child: const Text('Leave'),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (confirmed == true) {
  //     await ref.read(groupNotifierProvider.notifier).removeMemberFromGroup(group.id, currentUserId);
  //     if (context.mounted) Navigator.pop(context);
  //   }
  // }

  // Future<void> _handleDeleteGroup(WidgetRef ref, BuildContext context) async {
  //   final confirmed = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Delete Group'),
  //       content: const Text('Are you sure you want to delete this group?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, true),
  //           child: const Text('Delete'),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (confirmed == true) {
  //     await ref.read(groupNotifierProvider.notifier).deleteGroup(group.id);
  //     if (context.mounted) Navigator.pop(context);
  //   }
  // }
}
