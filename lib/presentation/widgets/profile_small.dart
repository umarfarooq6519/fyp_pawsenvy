import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class ProfileSmall extends StatelessWidget {
  final String name;
  final String? image;
  final String? tag1;
  final String? tag2;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;

  const ProfileSmall({
    super.key,
    required this.name,
    this.image,
    this.tag1,
    this.tag2,
    this.onFavorite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple.withOpacity(0.1)),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFF6D6E6), Color(0xFFE6FBFA)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Color(0xFFF6D6E6), blurRadius: 7)],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          // Card body with tap using InkWell for full coverage
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(28),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 90,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            image ?? 'assets/images/placeholder.png',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Text(
                        name,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tag1 != null && tag2 != null && tag2!.isNotEmpty
                          ? '$tag1 - $tag2'
                          : tag1 ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Favorite icon inside the card, top right, always on top
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: onFavorite,
                  icon: Icon(LineIcons.heart, color: Colors.red),
                  splashRadius: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
