import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:paypact/core/extensions/context_extensions.dart';

import '../../core/constants/firebase_constants.dart';
import '../../data/model/friend_model.dart';
import '../../domain/repositories/friend_repository.dart';
import '../../injection_container.dart';
import 'custom_container.dart';

class FriendsSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search by email ...';

  @override
  TextInputType get keyboardType => TextInputType.emailAddress;

  @override
  TextStyle get searchFieldStyle => TextStyle(color: Colors.black);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
        backgroundColor: Theme.of(context).colorScheme.surface,
        titleSpacing: 0.0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
        isDense: true,
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(CupertinoIcons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(CupertinoIcons.back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildUserList(context);
  @override
  Widget buildSuggestions(BuildContext context) => _buildUserList(context);

  Widget _buildUserList(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Start typing to search'));
    }

    // Only search when query has at least 3 characters to reduce flickering
    if (query.length < 3) {
      return SizedBox.shrink();
    }

    final friendRepository = getIt<FriendRepository>();

    return StreamBuilder<List<FriendModel>>(
      stream: friendRepository.searchUsersByEmail(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Handle error state
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Handle empty state
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Fall back to contains search if exact match fails
          return _buildFallbackSearch(context);
        }

        final results = snapshot.data!;

        if (results.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        return _buildUserListView(context, results);
      },
    );
  }

  Widget _buildFallbackSearch(BuildContext context) {
    return Center(
      child: Text('No exact match found. Searching for similar emails...'),
    );
  }

  Widget _buildUserListView(BuildContext context, List<FriendModel> users) {
    final friendRepository = getIt<FriendRepository>();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final userId = user.userId;
        final email = user.email;
        final name = user.name ?? email.split('@').first;
        final photoURL = user.photoUrl;
        return GestureDetector(
          onTap: () async {
            try {
              friendRepository.addFriend(FirebaseConstants.currentUserId!, user.userId);
              if (context.mounted) {
                close(context, userId);
              }
              context.showSnackBar(
                '$name added as friend',
                duration: Duration(seconds: 3),
              );
            } catch (e) {
              if (context.mounted) {
                context.showSnackBar(
                  'Failed to add friend: $e',
                  duration: Duration(seconds: 3),
                );
              }
            }
          },
          child: CustomContainer(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: photoURL != null
                      ? CachedNetworkImageProvider(
                          photoURL,
                          cacheKey: userId,
                        )
                      : null,
                  child: photoURL == null ? Text(name[0].toUpperCase()) : null,
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
