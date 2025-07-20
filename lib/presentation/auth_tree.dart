import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/role_selection_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth.service.dart';
import 'pages/welcome.dart';
import 'pages/pet_owner/pet_owner.dart';

class AuthTree extends StatelessWidget {
  const AuthTree({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DBService();
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return StreamBuilder<User?>(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _loadingInterface();
            }

            final user = snapshot.data;

            if (user == null) {
              return const Welcome();
            }

            // User is signed in, check their role
            return FutureBuilder<UserRole>(
              future: db.getUserRole(user.uid),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return _loadingInterface();
                }

                final role = roleSnapshot.data ?? UserRole.undefined;

                if (role == UserRole.undefined) {
                  // Replace with your actual profile creation page
                  return RoleSelectionPage();
                }
                if (role == UserRole.owner) {
                  return const PetOwner();
                }
                // Add more role checks as needed
                return const Welcome();
              },
            );
          },
        );
      },
    );
  }

  Scaffold _loadingInterface() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator()],
        ),
      ),
    );
  }
}
