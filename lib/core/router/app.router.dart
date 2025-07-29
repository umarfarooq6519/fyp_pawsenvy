import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/community/adoption_pets.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/pet/create_pet_profile.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/community/lost_found_pets.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/community/pet_partner_finder.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/settings.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/complete_user_profile/complete_user_profile.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/owner_reminders.dart';
import 'package:fyp_pawsenvy/presentation/pages/role_selection_page.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/user/user_profile_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:fyp_pawsenvy/presentation/pages/welcome.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/pet_owner.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/pet/pet_profile_screen.dart';
import 'package:fyp_pawsenvy/presentation/auth_tree.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.authTree,
    routes: [
      // ################### Fundamentals ###################
      GoRoute(
        path: Routes.authTree,
        name: 'authTree',
        builder: (context, state) => const AuthTree(),
      ),
      GoRoute(
        path: Routes.welcome,
        name: 'welcome',
        builder: (context, state) => const Welcome(),
      ),
      GoRoute(
        path: Routes.petOwner,
        name: 'petOwner',
        builder: (context, state) => const PetOwner(),
      ),
      GoRoute(
        path: Routes.veterinary,
        name: 'veterinary',
        builder:
            (context, state) => const Scaffold(
              body: Center(child: Text('Veterinary Page - Coming Soon')),
            ),
      ),
      GoRoute(
        path: Routes.roleSelectionPage,
        name: 'roleSelectionPage',
        builder: (context, state) => const RoleSelectionPage(),
      ),

      // ################### Create  ###################
      GoRoute(
        path: Routes.createPetProfile,
        name: 'createPetProfile',
        builder: (context, state) => const CreatePetProfile(),
      ),
      GoRoute(
        path: Routes.createUserProfile,
        name: 'createUserProfile',
        builder:
            (context, state) =>
                const CompleteUserProfile(isProfileIncomplete: true),
      ),
      GoRoute(
        path: Routes.addReminder,
        name: 'createReminder',
        builder: (context, state) => const AddReminderScreen(),
      ),

      // ################### Profiles ###################
      GoRoute(
        path: Routes.petProfile,
        name: 'petProfile',
        builder: (context, state) {
          final Pet pet = state.extra as Pet;
          return PetProfileScreen(pet: pet);
        },
      ),
      GoRoute(
        path: Routes.userProfile,
        name: 'userProfile',
        builder: (context, state) {
          final AppUser appUser = state.extra as AppUser;
          return UserProfileScreen(user: appUser);
        },
      ),

      // ################### Feature/Services ###################
      GoRoute(
        path: Routes.adoptionPets,
        name: 'adoptionPets',
        builder: (context, state) => const AdoptionPets(),
      ),
      GoRoute(
        path: Routes.lostFoundPets,
        name: 'lostFoundPets',
        builder: (context, state) => const LostFoundPets(),
      ),
      GoRoute(
        path: Routes.petPartnerFinder,
        name: 'petPartnerFinder',
        builder: (context, state) => const PetPartnerFinder(),
      ),

      // ################### Other ###################
      GoRoute(
        path: Routes.settings,
        name: 'settings',
        builder: (context, state) => const Settings(),
      ),
    ],
  );
}
