import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._auth, this._firestore);

  @override
  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception('Google Sign In cancelled');

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;
    if (user == null) throw Exception('User not found');

    // Convert image to base64
    String? base64Image;
    if (user.photoURL != null) {
      final response = await http.get(Uri.parse(user.photoURL!));
      base64Image = base64Encode(response.bodyBytes);
    }

    final userModel = UserModel(
      userId: user.uid,
      email: user.email!,
      name: user.displayName,
      photoUrl: user.photoURL,
      base64Image: base64Image,
    );

    // Save user to Firestore
    await _firestore.collection('users').doc(user.uid).set(userModel.toFirebase());

    return userModel;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
