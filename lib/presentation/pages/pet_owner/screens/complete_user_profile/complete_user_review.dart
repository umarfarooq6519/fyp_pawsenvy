import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';

class CompleteUserReview extends StatelessWidget {
  final String? userName;
  final String? userPhone;
  final String? userBio;
  final String? avatarPath;
  final GeoPoint? location;
  final DateTime? dateOfBirth;
  final VoidCallback onSubmit;
  final bool isLoading;

  const CompleteUserReview({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.userBio,
    required this.avatarPath,
    required this.location,
    required this.dateOfBirth,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Review Your Profile',
            style: AppTextStyles.headingLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Avatar preview
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColorStyles.lightPurple,
                border: Border.all(color: AppColorStyles.purple, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: _getAvatarWidget(),
              ),
            ),
          ),

          const SizedBox(height: 30), // Review information
          _buildReviewSection('Basic Information', [
            _buildReviewItem('Name', userName ?? 'Not provided'),
            _buildReviewItem('Phone', userPhone ?? 'Not provided'),
            _buildReviewItem('Bio', userBio ?? 'No bio provided'),
          ]),

          const SizedBox(height: 20),

          _buildReviewSection('Personal Information', [
            _buildReviewItem(
              'Date of Birth',
              dateOfBirth != null ? _formatDate(dateOfBirth!) : 'Not provided',
            ),
          ]),

          const SizedBox(height: 20),

          _buildReviewSection('Location Information', [
            _buildReviewItem(
              'Location',
              location != null
                  ? 'Set (${location!.latitude.toStringAsFixed(4)}, ${location!.longitude.toStringAsFixed(4)})'
                  : 'Not set',
            ),
          ]),

          const SizedBox(height: 30),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorStyles.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  isLoading
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Text(
                        'Create Profile',
                        style: AppTextStyles.bodyBase.copyWith(
                          color: AppColorStyles.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _getAvatarWidget() {
    if (avatarPath != null && avatarPath!.startsWith('http')) {
      return Image.network(
        avatarPath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, size: 40, color: Colors.white);
        },
      );
    }

    if (avatarPath != null) {
      return Image.asset(
        avatarPath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, size: 40, color: Colors.white);
        },
      );
    }

    return const Icon(Icons.person, size: 40, color: Colors.white);
  }

  Widget _buildReviewSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyBase.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColorStyles.deepPurple,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColorStyles.lightPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColorStyles.lightPurple),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColorStyles.deepPurple,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
