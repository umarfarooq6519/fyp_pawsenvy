import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/vet_profile.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:line_icons/line_icons.dart';

class VetAppointmentSchedule extends StatefulWidget {
  final Map<Weekday, OperatingHours> operatingHours;
  final Function(Weekday, String?, String?) onOperatingHoursChanged;

  const VetAppointmentSchedule({
    super.key,
    required this.operatingHours,
    required this.onOperatingHoursChanged,
  });

  @override
  State<VetAppointmentSchedule> createState() => _VetAppointmentScheduleState();
}

class _VetAppointmentScheduleState extends State<VetAppointmentSchedule> {
  final Map<Weekday, bool> _dayEnabled = {};
  final Map<Weekday, List<TimeSlot>> _timeSlots = {};

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _initializeState() {
    for (final weekday in Weekday.values) {
      final hours = widget.operatingHours[weekday];
      final isEnabled = hours?.open != null && hours?.close != null;
      _dayEnabled[weekday] = isEnabled;

      if (isEnabled) {
        _timeSlots[weekday] = [
          TimeSlot(
            openController: TextEditingController(text: hours?.open ?? ''),
            closeController: TextEditingController(text: hours?.close ?? ''),
          ),
        ];
      } else {
        _timeSlots[weekday] = [];
      }
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (final slots in _timeSlots.values) {
      for (final slot in slots) {
        slot.openController.dispose();
        slot.closeController.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Operating Hours', style: AppTextStyles.headingSmall),
          SizedBox(height: 16),
          Text(
            'Set your operating hours for each day of the week',
            style: AppTextStyles.bodySmall.copyWith(color: AppColorStyles.grey),
          ),
          SizedBox(height: 20),
          ...Weekday.values.map((weekday) => _buildWeekdayCard(weekday)),
          SizedBox(height: 20), // Extra bottom padding for better scrolling
        ],
      ),
    );
  }

  Widget _buildWeekdayCard(Weekday weekday) {
    final dayName = _getFullDayName(weekday);
    final isEnabled = _dayEnabled[weekday] ?? false;
    final timeSlots = _timeSlots[weekday] ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColorStyles.lightGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dayName,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isEnabled,
                    onChanged: (value) {
                      setState(() {
                        _dayEnabled[weekday] = value;
                        if (value) {
                          // Add first time slot when enabling
                          _timeSlots[weekday] = [
                            TimeSlot(
                              openController: TextEditingController(
                                text: '09:00',
                              ),
                              closeController: TextEditingController(
                                text: '17:00',
                              ),
                            ),
                          ];
                          widget.onOperatingHoursChanged(
                            weekday,
                            '09:00',
                            '17:00',
                          );
                        } else {
                          // Clear time slots when disabling
                          _timeSlots[weekday]?.forEach((slot) {
                            slot.openController.dispose();
                            slot.closeController.dispose();
                          });
                          _timeSlots[weekday] = [];
                          widget.onOperatingHoursChanged(weekday, null, null);
                        }
                      });
                    },
                    activeColor: AppColorStyles.deepPurple,
                  ),
                ),
              ],
            ),
            if (isEnabled) ...[
              SizedBox(height: 16),
              ...timeSlots.asMap().entries.map((entry) {
                final index = entry.key;
                final slot = entry.value;
                return _buildTimeSlotRow(weekday, slot, index);
              }),
              SizedBox(height: 8),
              _buildAddTimeSlotButton(weekday),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotRow(Weekday weekday, TimeSlot slot, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap:
                  () => _showTimePicker(
                    context,
                    slot.openController,
                    'Select opening time',
                  ),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: slot.openController,
                  decoration: InputDecoration(
                    labelText: 'From',
                    hintText: '09:00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    prefixIcon: Icon(LineIcons.clock, size: 20),
                  ),
                  onChanged: (value) {
                    _updateOperatingHours(weekday);
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap:
                  () => _showTimePicker(
                    context,
                    slot.closeController,
                    'Select closing time',
                  ),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: slot.closeController,
                  decoration: InputDecoration(
                    labelText: 'To',
                    hintText: '17:00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    prefixIcon: Icon(LineIcons.clock, size: 20),
                  ),
                  onChanged: (value) {
                    _updateOperatingHours(weekday);
                  },
                ),
              ),
            ),
          ),
          if ((_timeSlots[weekday]?.length ?? 0) > 1) ...[
            SizedBox(width: 8),
            IconButton(
              onPressed: () {
                setState(() {
                  final slots = _timeSlots[weekday]!;
                  slots[index].openController.dispose();
                  slots[index].closeController.dispose();
                  slots.removeAt(index);
                  _updateOperatingHours(weekday);
                });
              },
              icon: Icon(LineIcons.trash, color: Colors.red),
              style: IconButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddTimeSlotButton(Weekday weekday) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          setState(() {
            _timeSlots[weekday]?.add(
              TimeSlot(
                openController: TextEditingController(text: '09:00'),
                closeController: TextEditingController(text: '17:00'),
              ),
            );
          });
        },
        icon: Icon(LineIcons.plus, size: 18),
        label: Text('Add Time Slot'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorStyles.deepPurple,
          side: BorderSide(color: AppColorStyles.deepPurple),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  void _updateOperatingHours(Weekday weekday) {
    final slots = _timeSlots[weekday];
    if (slots == null || slots.isEmpty) {
      widget.onOperatingHoursChanged(weekday, null, null);
      return;
    }

    // For now, we'll use the first time slot for compatibility
    // In the future, you might want to modify the model to support multiple slots
    final firstSlot = slots.first;
    final openTime = firstSlot.openController.text.trim();
    final closeTime = firstSlot.closeController.text.trim();

    widget.onOperatingHoursChanged(
      weekday,
      openTime.isEmpty ? null : openTime,
      closeTime.isEmpty ? null : closeTime,
    );
  }

  String _getFullDayName(Weekday weekday) {
    switch (weekday) {
      case Weekday.mon:
        return 'Monday';
      case Weekday.tue:
        return 'Tuesday';
      case Weekday.wed:
        return 'Wednesday';
      case Weekday.thu:
        return 'Thursday';
      case Weekday.fri:
        return 'Friday';
      case Weekday.sat:
        return 'Saturday';
      case Weekday.sun:
        return 'Sunday';
    }
  }

  Future<void> _showTimePicker(
    BuildContext context,
    TextEditingController controller,
    String title,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          _parseTimeOfDay(controller.text) ?? TimeOfDay(hour: 9, minute: 0),
      helpText: title,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColorStyles.deepPurple),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedTime = _formatTimeOfDay(picked);
      controller.text = formattedTime;
      // Find the weekday this controller belongs to and update
      for (final weekday in Weekday.values) {
        final slots = _timeSlots[weekday];
        if (slots != null) {
          for (final slot in slots) {
            if (slot.openController == controller ||
                slot.closeController == controller) {
              _updateOperatingHours(weekday);
              return;
            }
          }
        }
      }
    }
  }

  TimeOfDay? _parseTimeOfDay(String timeString) {
    if (timeString.isEmpty) return null;
    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      // Return null if parsing fails
    }
    return null;
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class TimeSlot {
  final TextEditingController openController;
  final TextEditingController closeController;

  TimeSlot({required this.openController, required this.closeController});
}
