import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

import '../../core/constants/firebase_helper.dart';
import 'custom_avatar_widget.dart';

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
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildUserList(context);
  @override
  Widget buildSuggestions(BuildContext context) => _buildUserList(context);

  Future<void> _addFriend(String userId) async {
    final currentUser = FirebaseHelper.currentUser;
    if (currentUser == null || currentUser.uid == userId) return;

    final batch = FirebaseFirestore.instance.batch();
    final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final friendRef = FirebaseFirestore.instance.collection('users').doc(userId);

    batch.update(userRef, {
      'friends': FieldValue.arrayUnion([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    batch.update(friendRef, {
      'friends': FieldValue.arrayUnion([currentUser.uid]),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Widget _buildUserList(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Start typing to search'));
    }

    // Only search when query has at least 3 characters to reduce flickering
    if (query.length < 3) {
      return SizedBox.shrink();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: query) // Exact match first
          .snapshots(),
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Handle error state
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Handle empty state
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // Fall back to contains search if exact match fails
          return _buildFallbackSearch(context);
        }

        // Process results
        final users = snapshot.data!.docs.where((doc) {
          final email = doc['email'] as String?;
          final currentUser = FirebaseHelper.currentUser;
          return email != null &&
              email.isNotEmpty &&
              (currentUser == null || email != currentUser.email);
        }).toList();

        if (users.isEmpty) {
          return Center(child: Text('No users found'));
        }

        return _buildUserListView(context, users);
      },
    );
  }

  Widget _buildFallbackSearch(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('email')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading users'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No users found'));
        }

        final users = snapshot.data!.docs.where((doc) {
          final email = doc['email'] as String?;
          final currentUser = FirebaseHelper.currentUser;
          return email != null &&
              email.isNotEmpty &&
              (currentUser == null || email != currentUser.email);
        }).toList();

        return _buildUserListView(context, users);
      },
    );
  }

  Widget _buildUserListView(BuildContext context, List<QueryDocumentSnapshot> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final userId = user.id;
        final email = user.get('email') as String;
        final name = user.get('name') as String? ?? email.split('@').first;
        final photoURL = user.get('photoUrl') as String?;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
              child: photoURL == null ? Text(name[0].toUpperCase()) : null,
            ),
            title: Text(name),
            subtitle: Text(email),
            onTap: () async {
              try {
                await _addFriend(userId);
                if (context.mounted) {
                  close(context, userId);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Failed to add friend: $e')));
                }
              }
            },
          ),
        );
      },
    );
  }
}
