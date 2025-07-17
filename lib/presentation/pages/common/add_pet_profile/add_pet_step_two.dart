import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../../../../core/theme/color.styles.dart';
import '../../../../core/theme/text.styles.dart';

class AddPetStepTwo extends StatelessWidget {
  final TextEditingController breedController;
  final TextEditingController ageController;
  final TextEditingController colorController;
  final TextEditingController weightController;
  final String? healthRecordsPath;
  final VoidCallback onPickHealthRecords;
  final Function(String, dynamic)? onDataChanged;

  const AddPetStepTwo({
    super.key,
    required this.breedController,
    required this.ageController,
    required this.colorController,
    required this.weightController,
    required this.healthRecordsPath,
    required this.onPickHealthRecords,
    this.onDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Additional Information',
            style: AppTextStyles.headingLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Breed and Age row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: breedController,
                  label: 'Breed',
                  hint: 'e.g. Golden Retriever',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: ageController,
                  label: 'Age',
                  hint: 'Age in years',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Color and Weight row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: colorController,
                  label: 'Color',
                  hint: 'e.g. Golden, Black',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: weightController,
                  label: 'Weight (kg)',
                  hint: 'Weight in kg',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Health Records image picker
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Health Records',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onPickHealthRecords,
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColorStyles.lightPurple,
                border: Border.all(color: AppColorStyles.purple, width: 2),
              ),
              child:
                  healthRecordsPath != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          healthRecordsPath!,
                          fit: BoxFit.cover,
                        ),
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LineIcons.fileUpload,
                            size: 40,
                            color: AppColorStyles.purple,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to add health records',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColorStyles.purple,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload vaccination records, medical history, etc.',
            style: AppTextStyles.bodyExtraSmall.copyWith(
              color: AppColorStyles.lightGrey,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColorStyles.lightGrey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColorStyles.lightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColorStyles.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColorStyles.purple, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
