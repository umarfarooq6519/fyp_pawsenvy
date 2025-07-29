import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:fyp_pawsenvy/core/models/reminder.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/theme/color.styles.dart';
import '../../../../core/theme/text.styles.dart';
import '../../../../core/utils/datetime.util.dart';

class OwnerReminders extends StatefulWidget {
  const OwnerReminders({super.key});

  @override
  State<OwnerReminders> createState() => _OwnerRemindersState();
}

class _OwnerRemindersState extends State<OwnerReminders> {
  late AuthService _auth;
  late DBService _db;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthService>(context, listen: false);
    _db = Provider.of<DBService>(context, listen: false);

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

        // ######################################### Calendar
        Column(
          children: [
            SizedBox(
              height: 90,
              child: TableCalendar(
                firstDay: DateTime.now().subtract(const Duration(days: 2)),
                lastDay: DateTime.now().add(const Duration(days: 20)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                calendarFormat: CalendarFormat.week,
                availableCalendarFormats: const {CalendarFormat.week: 'Week'},
                headerVisible: false,
                daysOfWeekVisible: true,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  // your styling...
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 👇 Display reminders for selected day
            StreamBuilder<List<Reminder>>(
              stream: _db.getRemindersForDate(
                uid: _auth.currentUser!.uid,
                date: _selectedDay,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final reminders = snapshot.data ?? [];

                if (reminders.isEmpty) {
                  return const Text('No reminders for this day');
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    final isComplete =
                        reminder.status == ReminderStatus.completed;

                    return Slidable(
                      key: ValueKey(reminder.id),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              await _db.deleteReminder(reminder.id);
                            },
                            backgroundColor: AppColorStyles.pastelRed,
                            foregroundColor: AppColorStyles.black,
                            icon: LineIcons.trash,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: IconButton(
                          onPressed: () {
                            if (isComplete) {
                              _db.updateReminderStatus(
                                reminderId: reminder.id,
                                newStatus: ReminderStatus.pending,
                              );
                            } else {
                              _db.updateReminderStatus(
                                reminderId: reminder.id,
                                newStatus: ReminderStatus.completed,
                              );
                            }
                          },
                          icon: Icon(
                            isComplete
                                ? LineIcons.checkCircle
                                : LineIcons.circle,
                          ),
                        ),
                        title: Text(reminder.title),
                        subtitle: Text(reminder.description),
                        trailing: Text(
                          DateFormat.jm().format(reminder.due.toDate()),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 10), // Reminders List
      ],
    );
  }
}

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  late DBService _db;
  late AuthService _auth;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _db = Provider.of<DBService>(context, listen: false);
    _auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter a description'
                            : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Due Date: ${DateFormat.yMMMd().format(_dueDate)}'),
                trailing: const Icon(Icons.calendar_today),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      _dueDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _db.createReminder(
                      uid: _auth.currentUser!.uid,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      dueDate: _dueDate,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reminder saved!')),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text(
                  'Save Reminder',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
