import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/constants/firebase_helper.dart';
import '../widgets/friends_search_delegate.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color shadowColor = isDarkMode ? Colors.black54 : Colors.white;
    Color lightShadow = isDarkMode ? Colors.black38 : Colors.grey[400]!;

    Stream<List<String>> fetchFriends() {
      final currentUser = FirebaseHelper.currentUser;
      if (currentUser == null) return Stream.value([]);

      return FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots()
          .map((doc) {
            if (doc.exists && doc.data() != null) {
              return List<String>.from(doc['friends'] ?? []);
            }
            return [];
          });
    }

    Future<Map<String, dynamic>?> fetchFriendDetails(String userId) async {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return doc.exists ? doc.data() : null;
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text('Add Friend'),
            onPressed: () {
              showSearch(context: context, delegate: FriendsSearchDelegate());
            },
          ),
        ],
      ),
      body: StreamBuilder<List<String>>(
        stream: fetchFriends(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final friends = snapshot.data ?? [];
          if (friends.isEmpty) {
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
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Theme.of(context).cardColor
                            : const Color(0xFFE7EBF0),
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

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return FutureBuilder<Map<String, dynamic>?>(
                future: fetchFriendDetails(friends[index]),
                builder: (context, friendSnapshot) {
                  if (friendSnapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(3, 3),
                              blurRadius: 5,
                            ),
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(-3, -3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  if (!friendSnapshot.hasData || friendSnapshot.data == null) {
                    return SizedBox.shrink(); // Skip if data is null
                  }

                  final friend = friendSnapshot.data!;
                  final name = friend['name'];
                  final email = friend['email'];
                  final photoURL = friend['photoUrl'];

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
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
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: photoURL != null && photoURL.isNotEmpty
                                ? NetworkImage(photoURL)
                                : AssetImage('assets/default_avatar.png')
                                      as ImageProvider,
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                email,
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Spacer(),
                          // IconButton(
                          //   icon: Icon(Icons.delete, color: Colors.red),
                          //   onPressed: () async {
                          //     await _removeFriend(email);
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 20),
      //   child: Column(
      //     spacing: 20,
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(
      //         'You\'re all squared away, champ! 💸 No debts, no worries—just vibes. Keep the peace with PayPact! ✌️😎',
      //         textAlign: TextAlign.center,
      //         style: Theme.of(context).textTheme.titleMedium,
      //       ),
      //       GestureDetector(
      //         onTap: () {
      //           showSearch(context: context, delegate: FriendsSearchDelegate());
      //         },
      //         child: Container(
      //           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      //           decoration: BoxDecoration(
      //             color:
      //                 isDarkMode ? Theme.of(context).cardColor : const Color(0xFFE7EBF0),
      //             borderRadius: BorderRadius.circular(10),
      //             boxShadow: [
      //               BoxShadow(
      //                 color: lightShadow,
      //                 offset: Offset(2.5, 2.5),
      //                 blurRadius: 5,
      //                 inset: false,
      //               ),
      //               BoxShadow(
      //                 color: shadowColor,
      //                 offset: Offset(-2.5, -2.5),
      //                 blurRadius: 5,
      //                 inset: false,
      //               ),
      //             ],
      //           ),
      //           child: Text(
      //             'Add Friend',
      //             style: Theme.of(context).textTheme.titleSmall,
      //             textAlign: TextAlign.center,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
