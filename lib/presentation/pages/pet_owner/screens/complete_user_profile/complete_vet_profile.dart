import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/vet_profile.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';

class CompleteVetProfile extends StatelessWidget {
  final TextEditingController clinicNameController;
  final TextEditingController licenseNumberController;
  final TextEditingController experienceController;
  final List<Specialization> selectedSpecializations;
  final List<Service> selectedServices;
  final Function(List<Specialization>) onSpecializationsChanged;
  final Function(List<Service>) onServicesChanged;

  const CompleteVetProfile({
    super.key,
    required this.clinicNameController,
    required this.licenseNumberController,
    required this.experienceController,
    required this.selectedSpecializations,
    required this.selectedServices,
    required this.onSpecializationsChanged,
    required this.onServicesChanged,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: clinicNameController,
            decoration: InputDecoration(
              labelText: 'Clinic Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: licenseNumberController,
            decoration: InputDecoration(
              // labelText: 'License Number',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: experienceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Years of Experience',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          Text('Specializations', style: AppTextStyles.headingSmall),
          Wrap(
            spacing: 8.0,
            children:
                Specialization.values.map((specialization) {
                  return FilterChip(
                    label: Text(specialization.name),
                    selected: selectedSpecializations.contains(specialization),
                    onSelected: (isSelected) {
                      final updatedSpecializations = List<Specialization>.from(
                        selectedSpecializations,
                      );
                      if (isSelected) {
                        updatedSpecializations.add(specialization);
                      } else {
                        updatedSpecializations.remove(specialization);
                      }
                      onSpecializationsChanged(updatedSpecializations);
                    },
                  );
                }).toList(),
          ),
          SizedBox(height: 16),
          Text('Services', style: AppTextStyles.headingSmall),
          Wrap(
            spacing: 8.0,
            children:
                Service.values.map((service) {
                  return FilterChip(
                    label: Text(service.name),
                    selected: selectedServices.contains(service),
                    onSelected: (isSelected) {
                      final updatedServices = List<Service>.from(
                        selectedServices,
                      );
                      if (isSelected) {
                        updatedServices.add(service);
                      } else {
                        updatedServices.remove(service);
                      }
                      onServicesChanged(updatedServices);
                    },
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
