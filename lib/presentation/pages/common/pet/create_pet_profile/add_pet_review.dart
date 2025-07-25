import 'package:flutter/material.dart';
import '../../../../../core/theme/text.styles.dart';
import '../../../../../core/theme/color.styles.dart';
import '../../../../../core/models/pet.dart';

class AddPetStepThree extends StatelessWidget {
  final String? petName;
  final String? petBio;
  final String? selectedGender;
  final PetSpecies? selectedSpecies;
  final String? avatarPath;
  final List<PetTemperament>? selectedTemperaments;
  final Map<String, dynamic>? additionalData;
  final VoidCallback onSubmit;

  const AddPetStepThree({
    super.key,
    required this.petName,
    required this.petBio,
    required this.selectedGender,
    required this.selectedSpecies,
    required this.avatarPath,
    this.selectedTemperaments,
    this.additionalData,
    required this.onSubmit,
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
            'Review Pet Profile',
            style: AppTextStyles.headingLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40), // Avatar preview
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
          _buildReviewItem('Name', petName ?? 'Not provided'),
          _buildReviewItem(
            'Species',
            selectedSpecies?.toString().split('.').last.toUpperCase() ??
                'Not selected',
          ),
          _buildReviewItem(
            'Gender',
            selectedGender?.toUpperCase() ?? 'Not selected',
          ),
          _buildReviewItem('Bio', petBio ?? 'No bio provided'),

          // Additional information from step two
          if (additionalData != null) ...[
            const SizedBox(height: 12),
            Text(
              'Additional Information',
              style: AppTextStyles.bodyBase.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColorStyles.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            _buildReviewItem(
              'Breed',
              additionalData!['breed'] ?? 'Not provided',
            ),
            _buildReviewItem('Age', additionalData!['age'] ?? 'Not provided'),
            _buildReviewItem(
              'Color',
              additionalData!['color'] ?? 'Not provided',
            ),
            _buildReviewItem(
              'Weight',
              additionalData!['weight'] ?? 'Not provided',
            ),
            _buildReviewItem(
              'Health Records',
              additionalData!['healthRecords'] != null
                  ? 'Uploaded'
                  : 'Not uploaded',
            ),
          ],

          // Temperament information
          if (selectedTemperaments != null &&
              selectedTemperaments!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Temperament',
              style: AppTextStyles.bodyBase.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColorStyles.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            _buildTemperamentDisplay(selectedTemperaments!),
          ],

          const SizedBox(height: 30),

          // Summary card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColorStyles.profileGradient,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColorStyles.lightPurple),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Summary', style: AppTextStyles.headingSmall),
                const SizedBox(height: 8),
                Text(
                  'Please review the information above. Once you submit, your pet profile will be created.',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColorStyles.purple,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }

  Widget _getAvatarWidget() {
    // Show uploaded image if available (network image from Firebase)
    if (avatarPath != null && avatarPath!.startsWith('http')) {
      return Image.network(
        avatarPath!,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        errorBuilder: (context, error, stackTrace) {
          return _getDefaultAvatar();
        },
      );
    }

    // Show species default or placeholder
    if (selectedSpecies == PetSpecies.cat) {
      return Image.asset(
        'assets/images/cat.png',
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    } else if (selectedSpecies == PetSpecies.dog) {
      return Image.asset(
        'assets/images/dog.png',
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    }

    return _getDefaultAvatar();
  }

  Widget _getDefaultAvatar() {
    return Image.asset(
      'assets/images/placeholder.png',
      fit: BoxFit.cover,
      width: 100,
      height: 100,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.pets, size: 40, color: AppColorStyles.purple);
      },
    );
  }

  Widget _buildTemperamentDisplay(List<PetTemperament> temperaments) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          temperaments.map((temperament) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColorStyles.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                petTemperamentToString(temperament),
                style: AppTextStyles.bodyExtraSmall.copyWith(
                  color: AppColorStyles.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
    );
  }
}
