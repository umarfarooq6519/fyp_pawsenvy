import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final db = DBService();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithGoogle() async {
    try {
      if (kDebugMode) print('signInWithGoogle() function started');
      final GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut(); // Ensure previous sessions are cleared

      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({'prompt': 'select_account'});

      // Sign in and get user data
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return; // User canceled login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);

      // If new user, add to Firestore
      if (result.additionalUserInfo!.isNewUser) {
        final user = result.user;

        final appUser = AppUser(
          id: user!.uid,
          userRole: UserRole.undefined,
          name: user.displayName ?? '',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          avatar: user.photoURL ?? '',
          bio: '',
          location: const GeoPoint(0, 0),
          createdAt: Timestamp.now(),
          ownedPets: [],
          likedPets: [],
          vetProfile: null,
        );
        db.addUserToFirestore(appUser);
      }

      if (kDebugMode) print('signInWithGoogle() function completed');
      notifyListeners();
    } catch (e) {
      throw Exception('signInWithGoogle() error: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
