import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // // Determine which collection to use based on the user role
  // static String getUserCollection(String role) {
  //   return role == 'psychologist' ? 'psychologist' : 'users';
  // }

  // // Fetch user document from users or psychologists collection
  // static Future<DocumentSnapshot?> getUserDocument(String? uid) async {
  //   if (uid == null) return null;

  //   try {
  //     final userRole = await getUserRole(uid);
  //     final collection = getUserCollection(userRole);
  //     return await _firestore.collection(collection).doc(uid).get();
  //   } catch (e) {
  //     print('Error fetching user document: $e');
  //     return null;
  //   }
  // }

  // // Get user role (from either users or psychologists collection)
  // static Future<String> getUserRole(String? uid) async {
  //   try {
  //     final userDoc = await _firestore.collection('users').doc(uid).get();
  //     if (userDoc.exists) {
  //       return userDoc['role'] ?? 'user';
  //     } else {
  //       final psychDoc = await _firestore.collection('psychologist').doc(uid).get();
  //       if (psychDoc.exists) {
  //         return 'psychologist';
  //       }
  //     }
  //   } catch (e) {
  //     print('Error getting user role: $e');
  //   }
  //   return 'user'; // Default to 'user'
  // }

  // // Update user document (in either users or psychologists collection)
  // static Future<bool> updateUserDocument(String uid, Map<String, dynamic> data) async {
  //   try {
  //     final userRole = await getUserRole(uid);
  //     final collection = getUserCollection(userRole);
  //     await _firestore.collection(collection).doc(uid).update(data);
  //     return true;
  //   } catch (e) {
  //     print('Error updating user document: $e');
  //     return false;
  //   }
  // }

  // // Add document to a collection (either users or psychologists)
  static Future<DocumentReference?> addDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    try {
      return await _firestore.collection(collection).add(data);
    } catch (e) {
      debugPrint('Error adding document to $collection: $e');
      return null;
    }
  }

  // // Get document by ID from a specific collection
  static Future<DocumentSnapshot?> getDocument(String collection, String docId) async {
    try {
      return await _firestore
          .collection(collection)
          .doc(docId)
          .get(const GetOptions(source: Source.cache));
    } catch (e) {
      debugPrint('Error fetching document from $collection: $e');
      return null;
    }
  }

  // // Query documents in a specific collection
  // static Future<QuerySnapshot?> queryDocuments(
  //   String collection, {
  //   Query Function(Query)? queryBuilder,
  // }) async {
  //   try {
  //     Query query = _firestore.collection(collection);

  //     if (queryBuilder != null) {
  //       query = queryBuilder(query);
  //     }

  //     return await query.get();
  //   } catch (e) {
  //     print('Error querying documents in $collection: $e');
  //     return null;
  //   }
  // }

  // // Stream documents from a specific collection
  // static Stream<QuerySnapshot> streamDocuments(
  //   String collection, {
  //   Query Function(Query)? queryBuilder,
  // }) {
  //   Query query = _firestore.collection(collection);

  //   if (queryBuilder != null) {
  //     query = queryBuilder(query);
  //   }

  //   return query.snapshots();
  // }
}
