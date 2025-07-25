import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late final CollectionReference users;

  UserService() {
    users = _db.collection('users');
  }

  Stream<AppUser> streamUser(String uid) {
    return users.doc(uid).snapshots().map((doc) => AppUser.fromFirestore(doc));
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) {
    return _db.collection('users').doc(uid).update(data);
  }

  Future<void> deleteUser(String uid) {
    return _db.collection('users').doc(uid).delete();
  }
}
