import 'package:flutter/material.dart';

class ExtendedCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<String>? tags;
  final String? trailing;
  final String? avatar;
  const ExtendedCard({
    super.key,
    required this.title,
    this.subtitle,
    this.tags,
    this.trailing,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.deepPurple.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.transparent,
            backgroundImage: avatar != null ? AssetImage(avatar!) : null,
            child:
                avatar == null
                    ? const Icon(Icons.pets, color: Color(0xFFBDB8E2), size: 28)
                    : null,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 0,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 0),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
                if (tags != null && tags!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    tags!.join(' | '),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.black87),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (trailing != null)
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                trailing!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
