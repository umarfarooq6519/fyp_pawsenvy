import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/search_bar.dart';
import 'package:provider/provider.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  late AuthService _auth;

  @override
  void initState() {
    super.initState();
    _auth = Provider.of<AuthService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Evening,',
                    style: AppTextStyles.headingLarge.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    _auth.currentUser?.displayName ?? 'Guest',
                    style: AppTextStyles.headingLarge,
                  ),
                ],
              ),
              SizedBox(height: 30),

              CustomSearchBar(),

              SizedBox(height: 30),

              Text('Upcoming Events', style: AppTextStyles.headingMedium),
            ],
          ),
        ),
      ],
    );
  }
}
