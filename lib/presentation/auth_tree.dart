import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/presentation/pages/role_selection_page.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/pet_owner.dart';
import 'package:fyp_pawsenvy/presentation/pages/veterinary/veterinary.dart';
import 'package:fyp_pawsenvy/presentation/pages/welcome.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthTree extends StatelessWidget {
  const AuthTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        // use authStateChange to check if user authenticated or not
        return StreamBuilder<User?>(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final user = snapshot.data;

            if (user == null) {
              return const Welcome();
            } // Initialize UserProvider with user ID
            final userProvider = context.read<UserProvider>();
            userProvider.listenToUser(user.uid);

            return Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                final appUser = userProvider.user;

                if (appUser == null) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                // check the userRole and display accordingly
                switch (appUser.userRole) {
                  case UserRole.owner:
                    return const PetOwner();
                  case UserRole.vet:
                    return const Veterinary();
                  case UserRole.undefined:
                    return const RoleSelectionPage();
                }
              },
            );
          },
        );
      },
    );
  }
}
