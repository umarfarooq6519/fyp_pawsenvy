import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/create_pet_profile/create_pet_profile.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/create_user_profile/create_user_profile.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/role_selection_page.dart';
import 'package:go_router/go_router.dart';
import 'package:fyp_pawsenvy/presentation/pages/welcome.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/pet_owner.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/search_list.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/pet_profile_large.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/user_profile_large.dart';
import 'package:fyp_pawsenvy/presentation/auth_tree.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.authTree,
    routes: [
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
        path: Routes.searchList,
        name: 'searchList',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return SearchList(
            onSearch: () {},
            onFilter: () {},
            searchController: TextEditingController(),
            title: extra?['title'] ?? 'Search',
            components: extra?['components'] ?? [],
          );
        },
      ),
      GoRoute(
        path: Routes.petProfile,
        name: 'petProfile',
        builder: (context, state) {
          final pet = state.extra as Map<String, dynamic>?;
          if (pet == null) {
            return const Scaffold(body: Center(child: Text('Pet not found')));
          }
          return PetProfileLarge(profile: pet);
        },
      ),
      GoRoute(
        path: Routes.userProfile,
        name: 'userProfile',
        builder: (context, state) {
          final user = state.extra as Map<String, dynamic>?;
          if (user == null) {
            return const Scaffold(body: Center(child: Text('User not found')));
          }
          return UserProfileLarge(user: user);
        },
      ),
      GoRoute(
        path: Routes.roleSelectionPage,
        name: 'roleSelectionPage',
        builder: (context, state) => const RoleSelectionPage(),
      ),
      GoRoute(
        path: Routes.createPetProfile,
        name: 'createPetProfile',
        builder: (context, state) => const CreatePetProfile(),
      ),
      GoRoute(
        path: Routes.createUserProfile,
        name: 'createUserProfile',
        builder: (context, state) => const CreateUserProfile(
          isProfileIncomplete: true, // Hide back button for standalone route
        ),
      ),
    ],
  );
}
