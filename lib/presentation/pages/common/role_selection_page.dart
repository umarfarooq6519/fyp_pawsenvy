import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:go_router/go_router.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  final AuthService auth = AuthService();
  final DBService db = DBService();
  bool isLoading = false;

  get firstName => auth.currentUser?.displayName?.split(' ')[0] ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColorStyles.profileGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ~ header
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
              const SizedBox(height: 30),
              // ~ content
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          onPressed: () async {
                            setState(() => isLoading = true);
                            await handleSelection(
                              context,
                              UserRole.owner,
                              '/pet-owner',
                            );
                            setState(() => isLoading = false);
                          },
                          child:
                              isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    'Pet Owner',
                                    style: AppTextStyles.bodyBase,
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
                        ),
                        onPressed: () {},
                        child: Text(
                          'Veterinarian',
                          style: AppTextStyles.bodyBase,
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
              // ~ footer
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
      ),
    );
  }

  Future<void> handleSelection(
    BuildContext context,
    UserRole role,
    String path,
  ) async {
    await db.setUserRole(auth.currentUser!.uid, role);
    // ignore: use_build_context_synchronously
    context.go(path);
  }
}
