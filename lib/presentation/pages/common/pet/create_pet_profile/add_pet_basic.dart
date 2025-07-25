import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/color.styles.dart';
import '../../../../../core/theme/text.styles.dart';
import '../../../../../core/models/pet.dart';
import '../../../../../core/services/storage.service.dart';

class AddPetStepOne extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController bioController;
  final String? selectedGender;
  final PetSpecies? selectedSpecies;
  final String? avatarPath;
  final Function(PetSpecies) onSpeciesChanged;
  final Function(String) onGenderChanged;
  final void Function(String) onAvatarChanged;

  const AddPetStepOne({
    super.key,
    required this.nameController,
    required this.bioController,
    required this.selectedGender,
    required this.selectedSpecies,
    required this.avatarPath,
    required this.onSpeciesChanged,
    required this.onGenderChanged,
    required this.onAvatarChanged,
  });

  @override
  State<AddPetStepOne> createState() => _AddPetStepOneState();
}

class _AddPetStepOneState extends State<AddPetStepOne> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Add a Pet Profile',
            style: AppTextStyles.headingLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () async {
              final String? uploadedUrl =
                  await Provider.of<StorageService>(
                    context,
                    listen: false,
                  ).uploadPetAvatar();

              if (uploadedUrl != null) {
                widget.onAvatarChanged(uploadedUrl);
              }
            },
            child: Consumer<StorageService>(
              builder: (context, storageService, child) {
                return CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColorStyles.lightPurple,
                  backgroundImage:
                      widget.avatarPath != null
                          ? NetworkImage(widget.avatarPath!)
                          : null,
                  child: Icon(
                    LineIcons.dog,
                    color: AppColorStyles.lightGrey,
                    size: 40,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to add photo',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColorStyles.lightGrey,
            ),
          ),

          const SizedBox(height: 40),

          // Name field
          _buildTextField(
            controller: widget.nameController,
            label: 'Pet Name',
            hint: 'Enter your pet\'s name',
          ),

          const SizedBox(height: 20),

          // Species choice chips
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Species',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ChoiceChip(
                label: Text('Dog'),
                iconTheme: IconThemeData(color: AppColorStyles.white),
                selected: widget.selectedSpecies == PetSpecies.dog,
                onSelected: (selected) {
                  if (selected) widget.onSpeciesChanged(PetSpecies.dog);
                },
                selectedColor: AppColorStyles.purple,
                labelStyle: TextStyle(
                  color:
                      widget.selectedSpecies == PetSpecies.dog
                          ? Colors.white
                          : AppColorStyles.black,
                ),
                backgroundColor: AppColorStyles.lightPurple,
              ),
              const SizedBox(width: 12),
              ChoiceChip(
                iconTheme: IconThemeData(color: AppColorStyles.white),
                label: Text('Cat'),
                selected: widget.selectedSpecies == PetSpecies.cat,
                onSelected: (selected) {
                  if (selected) widget.onSpeciesChanged(PetSpecies.cat);
                },
                selectedColor: AppColorStyles.purple,
                labelStyle: TextStyle(
                  color:
                      widget.selectedSpecies == PetSpecies.cat
                          ? Colors.white
                          : AppColorStyles.black,
                ),
                backgroundColor: AppColorStyles.lightPurple,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Gender choice chips
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Gender',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ChoiceChip(
                label: Text('Male'),
                selected: widget.selectedGender == 'male',
                onSelected: (selected) {
                  if (selected) widget.onGenderChanged('male');
                },
                selectedColor: AppColorStyles.purple,
                labelStyle: TextStyle(
                  color:
                      widget.selectedGender == 'male'
                          ? Colors.white
                          : AppColorStyles.black,
                ),
                backgroundColor: AppColorStyles.lightPurple,
              ),
              const SizedBox(width: 12),
              ChoiceChip(
                label: Text('Female'),
                selected: widget.selectedGender == 'female',
                onSelected: (selected) {
                  if (selected) widget.onGenderChanged('female');
                },
                selectedColor: AppColorStyles.purple,
                labelStyle: TextStyle(
                  color:
                      widget.selectedGender == 'female'
                          ? Colors.white
                          : AppColorStyles.black,
                ),
                backgroundColor: AppColorStyles.lightPurple,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Bio field
          _buildTextField(
            controller: widget.bioController,
            label: 'Bio',
            hint: 'Tell us about your pet',
            maxLines: 3,
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
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
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
