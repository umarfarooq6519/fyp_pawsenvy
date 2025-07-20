import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_pawsenvy/core/services/storage.service.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';

class CreateUserDetails extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController bioController;
  final String? avatarPath;
  final GeoPoint? location;
  final Function(String)? onAvatarChanged;
  final Function(GeoPoint)? onLocationChanged;

  const CreateUserDetails({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.bioController,
    required this.avatarPath,
    required this.location,
    this.onAvatarChanged,
    this.onLocationChanged,
  });

  @override
  State<CreateUserDetails> createState() => _CreateUserDetailsState();
}

class _CreateUserDetailsState extends State<CreateUserDetails> {
  Future<void> _handleAvatarTap() async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    final String? uploadedUrl = await storageService.uploadUserAvatar();

    if (uploadedUrl != null && widget.onAvatarChanged != null) {
      widget.onAvatarChanged!(uploadedUrl);
    }
  }

  ImageProvider _getAvatarImage() {
    if (widget.avatarPath != null && widget.avatarPath!.startsWith('http')) {
      return NetworkImage(widget.avatarPath!);
    }

    if (widget.avatarPath != null) {
      return AssetImage(widget.avatarPath!);
    }

    return const AssetImage('assets/images/person1.png');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Complete Your Profile',
            style: AppTextStyles.headingLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Avatar section
          GestureDetector(
            onTap: _handleAvatarTap,
            child: Consumer<StorageService>(
              builder: (context, storageService, child) {
                return CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColorStyles.lightPurple,
                  backgroundImage: _getAvatarImage(),
                  child:
                      storageService.isUploading
                          ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                          : null,
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
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 20),

          // Phone field
          _buildTextField(
            controller: widget.phoneController,
            label: 'Phone Number',
            hint: 'Enter your phone number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 20), // Bio field
          _buildTextField(
            controller: widget.bioController,
            label: 'Bio',
            hint: 'Tell us about yourself',
            icon: Icons.edit_outlined,
            maxLines: 3,
          ),

          const SizedBox(height: 20),

          // Location section
          _buildLocationSection(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
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
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColorStyles.deepPurple),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColorStyles.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColorStyles.deepPurple),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColorStyles.lightGrey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColorStyles.lightGrey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColorStyles.deepPurple,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.location != null
                          ? 'Location set (${widget.location!.latitude.toStringAsFixed(4)}, ${widget.location!.longitude.toStringAsFixed(4)})'
                          : 'Tap to set your location',
                      style: AppTextStyles.bodySmall.copyWith(
                        color:
                            widget.location != null
                                ? AppColorStyles.black
                                : AppColorStyles.lightGrey,
                      ),
                    ),
                    if (widget.location != null)
                      Text(
                        'This helps us show nearby services',
                        style: AppTextStyles.bodyExtraSmall.copyWith(
                          color: AppColorStyles.lightGrey,
                        ),
                      ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _handleLocationTap,
                child: Text(
                  widget.location != null ? 'Change' : 'Set',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColorStyles.deepPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleLocationTap() {
    // TODO: Implement location picker
    // For now, set a default location
    if (widget.onLocationChanged != null) {
      widget.onLocationChanged!(
        const GeoPoint(37.7749, -122.4194),
      ); // San Francisco default
    }
  }
}
