import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _googleSignIn = googleSignIn;

  Stream<UserEntity> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : UserModel.anonymous();
    });
  }

  UserEntity get currentUser {
    return _firebaseAuth.currentUser != null
        ? UserModel.fromFirebaseUser(_firebaseAuth.currentUser!)
        : UserModel.anonymous();
  }

  Future<UserEntity> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const ValidationException('Sign-in cancelled by user');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (error) {
      throw FirebaseAuthException(code: error.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (error) {
      throw FirebaseAuthException(code: error.toString());
    }
  }
}
