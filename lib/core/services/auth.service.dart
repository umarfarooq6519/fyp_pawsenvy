import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final DBService _db = DBService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut(); // Ensure previous sessions are cleared

      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({'prompt': 'select_account'});

      // Sign in and get user data
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);

      // If new user, add to Firestore
      if (result.additionalUserInfo!.isNewUser) {
        _handleUserAddToDB(result);
      }
      notifyListeners();

      return result;
    } catch (e) {
      debugPrint('signInWithGoogle() error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> updateUserAvatar(String newUrl) async {
    if (currentUser == null) return;

    await currentUser!.updateProfile(photoURL: newUrl);
    await currentUser!.reload();

    await _db.users.doc(currentUser!.uid).update({'avatar': newUrl});
  }

  Future<void> _handleUserAddToDB(UserCredential result) async {
    final user = result.user;
    final appUser = AppUser(
      userRole: UserRole.undefined,
      name: user?.displayName ?? '',
      email: user?.email ?? '',
      phone: user?.phoneNumber ?? '',
      avatar: user?.photoURL ?? '',
      bio: '',
      gender: Gender.undefined,
      location: const GeoPoint(0, 0),
      createdAt: Timestamp.now(),
      dob: Timestamp(0, 0).toDate(),
      ownedPets: [],
      likedPets: [],
      vetProfile: null,
    );

    await _db.addUserToDB(appUser, result.user!.uid);
  }
}
