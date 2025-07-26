import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/color.styles.dart';
import '../../../../core/theme/text.styles.dart';
import '../../../../core/utils/datetime.util.dart';

class OwnerReminders extends StatefulWidget {
  const OwnerReminders({super.key});

  @override
  State<OwnerReminders> createState() => _OwnerRemindersState();
}

class _OwnerRemindersState extends State<OwnerReminders> {
  DateTime _selectedDay = DateTime.now();

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
      ],
    );
  }
}
