import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class ProfileMedium extends StatelessWidget {
  final String name;
  final String? image;
  final String? type;
  final String? about;
  final bool verified;
  final bool isFavorite;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;
  final String? tag1;
  final String? tag2;

  const ProfileMedium({
    super.key,
    required this.name,
    this.image,
    this.type,
    this.about,
    this.verified = false,
    this.isFavorite = false,
    this.onFavorite,
    this.onTap,
    this.tag1,
    this.tag2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple.withOpacity(0.1)),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFF6D6E6), Color(0xFFE6FBFA)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Color(0xFFF6D6E6), blurRadius: 10)],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(
                      image ?? 'assets/images/placeholder.png',
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 24),
                // Removed Expanded, just using Column directly
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Just use a Column, no Expanded
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                        if (type != null && type!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              type!,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (verified)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          LineIcons.checkCircle,
                          color: Colors.deepPurple,
                          size: 28,
                        ),
                      ),
                  ],
                ),
                // New row for tag1 and tag2
                if ((tag1 != null && tag1!.isNotEmpty) ||
                    (tag2 != null && tag2!.isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (tag1 != null && tag1!.isNotEmpty) ...[
                          Icon(
                            tag1!.toLowerCase() == 'male'
                                ? LineIcons.mars
                                : tag1!.toLowerCase() == 'female'
                                ? LineIcons.venus
                                : LineIcons.tag,
                            color:
                                tag1!.toLowerCase() == 'male'
                                    ? Colors.blue
                                    : tag1!.toLowerCase() == 'female'
                                    ? Colors.pink
                                    : Colors.deepPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tag1!,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        if (tag1 != null &&
                            tag1!.isNotEmpty &&
                            tag2 != null &&
                            tag2!.isNotEmpty)
                          const SizedBox(width: 18),
                        if (tag2 != null && tag2!.isNotEmpty) ...[
                          Icon(
                            Icons.location_on,
                            color: Colors.deepPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            tag2!,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                if (about != null && about!.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    about!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Favorite icon inside the card, top right, always on top
          Positioned(
            top: 10,
            right: 10,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  isFavorite ? LineIcons.heartAlt : LineIcons.heart,
                  color: Colors.red,
                  size: 28,
                ),
                splashRadius: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
