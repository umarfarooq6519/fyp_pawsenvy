import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:line_icons/line_icons.dart';

class CreateUserDetails extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController bioController;
  final Gender? selectedGender;
  final String? avatarPath;
  final GeoPoint? location;
  final DateTime? dateOfBirth;
  final VoidCallback onAvatarChanged;
  final Function(Gender) onGenderChange;
  final Function(DateTime) onDobChanged;
  final Future<void> Function() onLocationChanged;

  const CreateUserDetails({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.bioController,
    required this.selectedGender,
    required this.avatarPath,
    required this.location,
    required this.dateOfBirth,
    required this.onAvatarChanged,
    required this.onDobChanged,
    required this.onGenderChange,
    required this.onLocationChanged,
  });

  @override
  State<CreateUserDetails> createState() => _CreateUserDetailsState();
}

class _CreateUserDetailsState extends State<CreateUserDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            'Complete Your Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Avatar
          Center(
            child: GestureDetector(
              onTap: () => {widget.onAvatarChanged()},
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColorStyles.lightGrey,
                backgroundImage: NetworkImage(widget.avatarPath!),
                child:
                    widget.avatarPath == null
                        ? const Icon(LineIcons.camera, size: 30)
                        : null,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Tap to add photo',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 32),

          // Name field
          TextField(
            controller: widget.nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Gender dropdown
          DropdownButtonFormField<Gender>(
            value: widget.selectedGender,
            decoration: const InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            items: const [
              DropdownMenuItem(value: Gender.male, child: Text('Male')),
              DropdownMenuItem(value: Gender.female, child: Text('Female')),
            ],
            onChanged: (Gender? value) {
              widget.onGenderChange(value!);
            },
          ),

          const SizedBox(height: 16),

          IntlPhoneField(
            controller: widget.phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUnfocus,
            initialCountryCode: 'PK',
            onChanged: (phone) {
              if (kDebugMode) print(phone.completeNumber);
            },
          ),

          const SizedBox(height: 16),

          // Bio field
          TextField(
            controller: widget.bioController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Bio',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Date of Birth
          ListTile(
            leading: const Icon(LineIcons.birthdayCake),
            title: Text(
              widget.dateOfBirth != null
                  ? '${widget.dateOfBirth!.day}/${widget.dateOfBirth!.month}/${widget.dateOfBirth!.year}'
                  : 'Select Date of Birth',
            ),
            trailing: const Icon(LineIcons.angleRight),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: widget.dateOfBirth ?? DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                widget.onDobChanged(date);
              }
            },
          ),
          const SizedBox(height: 16),

          // Location
          ListTile(
            leading: const Icon(LineIcons.mapMarker, size: 20),
            title: Text(
              widget.location != null
                  ? 'Lat: ${widget.location!.latitude.toStringAsFixed(4)}, Long: ${widget.location!.longitude.toStringAsFixed(4)}'
                  : 'Set Location',
            ),
            trailing: const Icon(LineIcons.angleRight, size: 20),
            onTap: () => widget.onLocationChanged(),
          ),
        ],
      ),
    );
  }
}
