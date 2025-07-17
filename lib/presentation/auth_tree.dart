import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth.service.dart';
import 'pages/welcome.dart';
import 'pages/pet_owner/pet_owner.dart';

class AuthTree extends StatelessWidget {
  const AuthTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return StreamBuilder<User?>(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            // Show loading while checking auth state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _loadingInterface();
            }

            // If user is authenticated, show pet owner page
            if (snapshot.hasData && snapshot.data != null) {
              return const PetOwner();
            }

            // If user is not authenticated, show welcome page
            return const Welcome();
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
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
