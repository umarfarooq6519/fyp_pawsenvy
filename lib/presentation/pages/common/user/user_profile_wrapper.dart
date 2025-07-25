import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/user/user_profile_screen.dart';

class UserProfileWrapper extends StatefulWidget {
  final String uID;

  const UserProfileWrapper({super.key, required this.uID});

  @override
  State<UserProfileWrapper> createState() => _UserProfileWrapperState();
}

class _UserProfileWrapperState extends State<UserProfileWrapper> {
  final DBService _dbService = DBService();

  StreamSubscription<AppUser>? _subscription;
  AppUser? _user;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _subscription = _dbService.getUserStream(widget.uID).listen((appUser) {
      if (mounted) {
        setState(() {
          _user = appUser;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return UserProfileScreen(user: _user!);
  }
}
