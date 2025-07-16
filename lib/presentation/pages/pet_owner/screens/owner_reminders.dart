import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/presentation/widgets/reminders/reminder_tile.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:line_icons/line_icons.dart';
import '../../../../core/theme/color.styles.dart';
import '../../../../core/theme/text.styles.dart';
import '../../../../core/utils/datetime.util.dart';
import '../../../../core/models/reminder.dart';
import '../../../../core/models/booking.dart';
import '../../../widgets/reminders/booking_tile.dart';

class OwnerReminders extends StatefulWidget {
  const OwnerReminders({super.key});

  @override
  State<OwnerReminders> createState() => _OwnerRemindersState();
}

class _OwnerRemindersState extends State<OwnerReminders> {
  DateTime _selectedDay = DateTime.now();

  final List<dynamic> _reminders = [
    Reminder(
      title: "Daria's 20th Birthday",
      time: "2:30",
      icon: Icons.star,
      iconColor: Colors.red,
      isCompleted: false,
    ),
    Booking(
      petName: "Fluffy",
      petAvatar: "assets/images/cat.png",
      vetName: "Dr.Smith",
      vetAvatar: "assets/images/person2.png",
      time: "14:30",
    ),
    Reminder(
      title: "Wake up",
      time: "09:00",
      icon: Icons.star,
      iconColor: Colors.orange,
      isCompleted: false,
    ),
    Reminder(
      title: "Design Crit",
      time: "10:00",
      icon: Icons.circle_outlined,
      iconColor: AppColorStyles.grey,
      isCompleted: false,
    ),
    Booking(
      petName: "Buddy",
      petAvatar: "assets/images/dog.png",
      vetName: "Dr Johnson",
      vetAvatar: "assets/images/person3.png",
      time: "16:15",
    ),
    Reminder(
      title: "Haircut with Vincent",
      time: "13:00",
      icon: Icons.circle_outlined,
      iconColor: AppColorStyles.grey,
      isCompleted: false,
    ),
    Booking(
      petName: "Charlie",
      petAvatar: "assets/images/cat.png",
      vetName: "Dr Williams",
      vetAvatar: "assets/images/person4.png",
      time: "11:00",
    ),

    Reminder(
      title: "Wind down",
      time: "21:00",
      icon: Icons.nightlight_round,
      iconColor: Colors.blue,
      isCompleted: false,
    ),
  ];

  void _completeItem(int index) {
    setState(() {
      final item = _reminders[index];
      if (item is Reminder) {
        _reminders[index] = Reminder(
          title: item.title,
          time: item.time,
          icon: item.icon,
          iconColor: item.iconColor,
          isCompleted: true,
        );
      }
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        DateTimeUtils.getWeekdayName(_selectedDay),
                        style: AppTextStyles.headingLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8, top: 8),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${DateTimeUtils.getMonthName(_selectedDay)} ${_selectedDay.day}',
                    style: AppTextStyles.bodyBase.copyWith(
                      color: AppColorStyles.lightGrey,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '2025',
                    style: AppTextStyles.bodyBase.copyWith(
                      color: AppColorStyles.lightGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Today you have',
                    style: AppTextStyles.bodyBase.copyWith(
                      color: AppColorStyles.lightGrey,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '0 reminders',
                    style: AppTextStyles.bodyBase.copyWith(
                      color: AppColorStyles.lightGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 23,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index - 2));
              final isSelected = isSameDay(date, _selectedDay);
              final isToday = isSameDay(date, DateTime.now());

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = date;
                  });
                },
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColorStyles.purple : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        isToday
                            ? Border.all(color: AppColorStyles.purple, width: 2)
                            : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date.day.toString(),
                        style: AppTextStyles.bodyBase.copyWith(
                          color:
                              isSelected ? Colors.white : AppColorStyles.black,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        DateTimeUtils.getAbbreviatedWeekdayName(date),
                        style: AppTextStyles.bodySmall.copyWith(
                          color:
                              isSelected
                                  ? Colors.white
                                  : AppColorStyles.lightGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10), // Reminders List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _reminders.length,
            itemBuilder: (context, index) {
              final item = _reminders[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Slidable(
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SizedBox(width: 6),
                      if (item is Reminder && !item.isCompleted)
                        SlidableAction(
                          onPressed: (context) => _completeItem(index),
                          backgroundColor: AppColorStyles.pastelGreen,
                          foregroundColor: Colors.black,
                          icon: LineIcons.check,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      SizedBox(width: 6),
                      // Delete action
                      SlidableAction(
                        onPressed: (context) => _deleteItem(index),
                        backgroundColor: AppColorStyles.pastelRed,
                        foregroundColor: Colors.black,
                        icon: LineIcons.trash,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ],
                  ),
                  child:
                      item is Reminder
                          ? Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColorStyles.lightGrey.withOpacity(
                                  0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: ReminderTile(reminder: item),
                          )
                          : item is Booking
                          ? BookingTile(booking: item)
                          : const SizedBox.shrink(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
