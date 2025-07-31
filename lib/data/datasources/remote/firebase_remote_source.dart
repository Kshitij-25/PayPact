import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Auth service provider
final authServiceProvider = Provider<FirebaseRemoteSource>((ref) {
  return FirebaseRemoteSource(FirebaseAuth.instance, GoogleSignIn());
});

class FirebaseRemoteSource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FirebaseRemoteSource(this._auth, this._googleSignIn);

  // Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw 'Google sign in aborted';

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      await _createUserInFirestore(userCredential.user!);

      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> _createUserInFirestore(User user) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    if (!(await userRef.get()).exists) {
      await userRef.set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName,
        'photoUrl': user.photoURL,
        'friends': [],
        'groups': [],
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      }, SetOptions(merge: true));
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      // await Future.wait([]);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Exception _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        // Email Validation Errors
        case 'invalid-email':
          return Exception('Invalid email address format');

        // Account Existence Errors
        case 'email-already-in-use':
          return Exception('Email is already registered');
        case 'account-exists-with-different-credential':
          return Exception('Account exists with different sign-in method');

        // Authentication Errors
        case 'wrong-password':
        case 'invalid-credential':
        case 'INVALID_LOGIN_CREDENTIALS':
          return Exception('Invalid login credentials');

        // User Account Errors
        case 'user-not-found':
          return Exception('No account found with this email');
        case 'user-disabled':
          return Exception('User account has been disabled');

        // Password Errors
        case 'weak-password':
          return Exception('Password is too weak');

        // Network and Request Errors
        case 'network-request-failed':
          return Exception('Network error. Check your connection');
        case 'too-many-requests':
          return Exception('Too many requests. Please try again later');

        // Token and Authentication Flow Errors
        case 'user-token-expired':
          return Exception('Session expired. Please log in again');
        case 'operation-not-allowed':
          return Exception('Sign-in method not enabled');

        // Verification and Credential Errors
        case 'invalid-verification-code':
          return Exception('Invalid verification code');
        case 'invalid-verification-id':
          return Exception('Invalid verification ID');

        // Miscellaneous Errors
        case 'missing-android-pkg-name':
          return Exception('Android package name missing');
        case 'missing-continue-uri':
          return Exception('Continue URL is missing');
        case 'invalid-continue-uri':
          return Exception('Invalid continue URL');
        case 'unauthorized-continue-uri':
          return Exception('Unauthorized continue URL domain');

        default:
          return Exception(e.message ?? 'Authentication error occurred');
      }
    }
    return Exception('An unexpected error occurred');
  }
}
