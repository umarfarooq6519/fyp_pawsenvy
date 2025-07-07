import 'package:flutter/material.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({super.key, required this.profile});

  final Map<String, dynamic> profile;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          // Main content with scroll
          Column(
            children: [
              // ####### Profile image with full width and fixed height
              Container(
                width: double.infinity,
                height: 340,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9E9E0),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Stack(
                  children: [
                    // Show cat or dog image based on profile type
                    Align(
                      alignment: Alignment.center,
                      child: _displayImage(profile),
                    ),
                    // Top bar
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
              // ############# Details (scrollable)
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
                                  profile['name'] as String,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
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
                                      profile['location'] as String,
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
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.orange,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const SizedBox(height: 16),
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
                            (profile['attributes'] as List).length,
                            (i) {
                              final attr =
                                  (profile['attributes'] as List)[i]
                                      as Map<String, dynamic>;
                              return Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      attr['icon'] as IconData,
                                      color: Colors.orange,
                                    ),
                                  ),
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
                        'About this pet',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile['about'] as String,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Text(
                      //     'Read More',
                      //     style: TextStyle(
                      //       color: Colors.orange[700],
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Sticky Adopt button
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {},
                child: const Text(
                  'Adopt this pet',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Image _displayImage(Map<String, Object?> profile) {
    final type = profile['type'];

    return Image.asset(
      type == 'Dog'
          ? 'assets/images/dog.png'
          : type == 'Cat'
          ? 'assets/images/cat.png'
          : 'assets/images/placeholder.png',
      // height: 250,
      fit: BoxFit.cover,
    );
  }
}
