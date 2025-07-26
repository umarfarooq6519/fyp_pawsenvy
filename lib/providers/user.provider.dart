import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';

class UserProvider with ChangeNotifier {
  final DBService _dbService = DBService();

  AppUser? _user; // setter
  AppUser? get user => _user; // getter

  StreamSubscription<AppUser>? _subscription;

  void listenToUser(String uid) {
    _subscription?.cancel();

    _subscription = _dbService
        .getUserStream(uid)
        .listen(
          (appUser) {
            _user = appUser;
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Error listening to user stream: $error');
          },
        );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
