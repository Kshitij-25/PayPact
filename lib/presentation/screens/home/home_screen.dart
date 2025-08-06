import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/constants/routes_constants.dart';
import '../../../data/model/friend_model.dart';
import '../../state/friend_notifier.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/friends_search_delegate.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsState = ref.watch(friendNotifierProvider(FirebaseConstants.currentUserId!));

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              showSearch(context: context, delegate: FriendsSearchDelegate());
            },
            child: const Text('Add Friend'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: friendsState.when(
          data: (friends) => friends.isEmpty ? _buildEmptyState(context) : _buildFriendList(context, friends),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
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
              showSearch(context: context, delegate: FriendsSearchDelegate());
            },
            child: CustomContainer(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                'Add Friend',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendList(BuildContext context, List<FriendModel> friends) {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: friends.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final friend = friends[index];
        return GestureDetector(
          onTap: () {
            context.pushNamed(
              Routes.participantDetailsScreen,
              extra: friend,
            );
          },
          child: CustomContainer(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: friend.photoUrl != null && friend.photoUrl!.isNotEmpty
                      ? CachedNetworkImageProvider(
                          friend.photoUrl!,
                          cacheKey: friend.userId,
                        )
                      : const AssetImage('assets/default_avatar.png') as ImageProvider,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend.name ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        friend.email ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
