import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, required this.user});
  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Avatar section
              Container(
                width: double.infinity,
                height: 320,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF6F6),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage(
                          user['avatar'] ?? 'assets/images/placeholder.png',
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Details section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name'] ?? '',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      user['role'] == 'veterinary'
                                          ? Icons.medical_services
                                          : Icons.pets,
                                      size: 18,
                                      color: Colors.teal,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      user['role'] == 'veterinary'
                                          ? 'Veterinary'
                                          : 'Pet Owner',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      user['location'] ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Attributes
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            (user['attributes'] as List).length,
                            (i) {
                              final attr =
                                  (user['attributes'] as List)[i]
                                      as Map<String, dynamic>;
                              return Column(
                                children: [
                                  _buildAttributeIcon(attr['icon']),
                                  const SizedBox(height: 6),
                                  Text(
                                    attr['label'] as String,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user['about'] ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Sticky contact button
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement contact action
                },
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                ),
                label: const Text(
                  'Contact',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: Colors.teal.withOpacity(0.18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeIcon(dynamic icon) {
    if (icon == null) {
      return const SizedBox(height: 36, width: 36);
    }
    if (icon is String) {
      return CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.asset(icon, width: 28, height: 28),
      );
    }
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: Icon(icon as IconData, color: Colors.teal, size: 24),
    );
  }
}
