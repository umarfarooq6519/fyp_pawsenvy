import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';

class CreateUserRoleSelection extends StatelessWidget {
  final UserRole? selectedRole;
  final Function(UserRole) onRoleChanged;
  final AuthService auth;

  const CreateUserRoleSelection({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.auth,
  });

  String get firstName => auth.currentUser?.displayName?.split(' ')[0] ?? '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColorStyles.profileGradient),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome, $firstName',
              textAlign: TextAlign.center,
              style: AppTextStyles.headingLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Please define your role to continue',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 40),

            // Role selection buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColorStyles.lightGrey.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          backgroundColor:
                              selectedRole == UserRole.owner
                                  ? AppColorStyles.deepPurple
                                  : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        onPressed: () => onRoleChanged(UserRole.owner),
                        child: Text(
                          'Pet Owner',
                          style: AppTextStyles.bodyBase.copyWith(
                            color:
                                selectedRole == UserRole.owner
                                    ? AppColorStyles.white
                                    : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor:
                            selectedRole == UserRole.vet
                                ? AppColorStyles.deepPurple.withOpacity(0.1)
                                : null,
                        side: BorderSide(
                          color:
                              selectedRole == UserRole.vet
                                  ? AppColorStyles.deepPurple
                                  : AppColorStyles.lightGrey,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      onPressed: () => onRoleChanged(UserRole.vet),
                      child: Text(
                        'Veterinarian',
                        style: AppTextStyles.bodyBase.copyWith(
                          color:
                              selectedRole == UserRole.vet
                                  ? AppColorStyles.deepPurple
                                  : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '*As a veterinarian, we would prompt you to provide your certification.',
                    style: AppTextStyles.bodyExtraSmall.copyWith(
                      color: Colors.black45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // Sign out button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 18,
                ),
              ),
              onPressed: () async {
                await auth.signOut();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.logout,
                    size: 16,
                    color: AppColorStyles.black,
                  ),
                  const SizedBox(width: 8),
                  Text('Sign Out', style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
