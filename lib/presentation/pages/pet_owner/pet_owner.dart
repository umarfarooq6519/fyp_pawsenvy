import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/data/pets.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/user_profile.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/your_pets_screen.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/dashboard.dart';
import 'package:fyp_pawsenvy/presentation/widgets/pet_profile_screen.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profile_medium.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/community.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';

class PetOwner extends StatefulWidget {
  const PetOwner({super.key});

  @override
  State<PetOwner> createState() => _PetOwnerState();
}

class _PetOwnerState extends State<PetOwner> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    PetOwnerDashboard(),
    Community(),
    // Placeholder for Services and Profile screens
    Center(
      child: Text(
        'Services',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      ),
    ),
    YourPetsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 10,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,

            onTap: () {
              showPopupCard(
                context: context,
                builder:
                    (context) => PopupCard(
                      elevation: 0,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 400,
                            height: 500,
                            child: ProfileMedium(
                              name: 'Umar Farooq',
                              image: 'assets/images/person1.png',
                              type: 'Pet Owner',
                              tag1: 'Male',
                              tag2: 'Lahore',
                              about:
                                  'Pet lover, community member, and animal welfare advocate.',
                              verified: true,
                              isFavorite: false,
                              onFavorite: () {},
                            ),
                          ),
                          SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color(0xFFF6D6E6),
                                        Color(0xFFE6FBFA),
                                      ],
                                    ),
                                  ),
                                  child: IconButton(
                                    color: Colors.black,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(LineIcons.pen, size: 22),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: IconButton(
                                    color: Colors.black,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(LineIcons.times, size: 22),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                alignment: Alignment.center,
                dimBackground: true,
                useSafeArea: true,
              );
            },
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/person1.png'),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetProfileScreen(profile: pets[0]),
                  ),
                );
              },
              child: IconButton(
                onPressed: () {},
                icon: Icon(LineIcons.bell, size: 30),
              ),
            ),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: _bottomNav(),
      ),
    );
  }

  GNav _bottomNav() {
    return GNav(
      gap: 6,
      backgroundColor: Colors.transparent,
      color: Colors.black,
      activeColor: Colors.black,
      iconSize: 24,
      tabBackgroundColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      selectedIndex: _selectedIndex,
      onTabChange: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      tabActiveBorder: Border.all(color: Colors.black54, width: 1),
      tabs: [
        const GButton(
          icon: LineIcons.home,
          text: 'Home',
          iconColor: Colors.black,
          iconActiveColor: Colors.black,
          border: Border.fromBorderSide(BorderSide.none),
        ),
        const GButton(
          icon: LineIcons.users,
          text: 'Community',
          iconColor: Colors.black,
          iconActiveColor: Colors.black,
          border: Border.fromBorderSide(BorderSide.none),
        ),
        const GButton(
          icon: LineIcons.paw,
          text: 'Services',
          iconColor: Colors.black,
          iconActiveColor: Colors.black,
          border: Border.fromBorderSide(BorderSide.none),
        ),
        GButton(
          icon: Icons.person_outline,
          text: 'Your Pets',
          iconColor: Colors.black,
          iconActiveColor: Colors.black,
          border: Border.fromBorderSide(BorderSide.none),
          leading: const CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage('assets/images/person1.png'),
          ),
        ),
      ],
    );
  }
}
