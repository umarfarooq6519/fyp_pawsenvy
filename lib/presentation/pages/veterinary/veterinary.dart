import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/models/booking.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/services/booking.service.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/complete_user_profile/complete_user_profile.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/app_drawer.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/utils/datetime.util.dart';

class Veterinary extends StatefulWidget {
  const Veterinary({super.key});

  @override
  State<Veterinary> createState() => _VeterinaryState();
}

class _VeterinaryState extends State<Veterinary> {
  late AuthService _auth;
  late DBService _db;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  bool _isProfileComplete(AppUser user) {
    final defaultDob = Timestamp(0, 0).toDate();
    final isLocationSet =
        user.location.latitude != 0 || user.location.longitude != 0;

    // Basic profile validation
    final basicProfileComplete =
        user.name.trim().isNotEmpty &&
        user.phone.trim().isNotEmpty &&
        user.avatar.trim().isNotEmpty &&
        user.bio.trim().isNotEmpty &&
        user.gender != Gender.undefined &&
        user.dob != defaultDob &&
        isLocationSet;

    // Additional vet profile validation for vets
    if (user.userRole == UserRole.vet) {
      final vetProfileComplete =
          user.vetProfile != null &&
          user.vetProfile!.clinicName.trim().isNotEmpty &&
          user.vetProfile!.licenseNumber.trim().isNotEmpty &&
          user.vetProfile!.experience > 0 &&
          user.vetProfile!.specializations.isNotEmpty &&
          user.vetProfile!.services.isNotEmpty;

      return basicProfileComplete && vetProfileComplete;
    }

    return basicProfileComplete;
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthService>(context, listen: false);
    _db = Provider.of<DBService>(context, listen: false);

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final appUser = userProvider.user;

        // Show loading if user data is not available yet
        if (appUser == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check profile completeness in real-time
        if (!_isProfileComplete(appUser)) {
          return CompleteUserProfile(
            isProfileIncomplete: true,
            onProfileComplete: () {
              // The Consumer will automatically rebuild when UserProvider updates
            },
          );
        }

        return _buildVeterinaryInterface(context, appUser);
      },
    );
  }

  Widget _buildVeterinaryInterface(BuildContext context, AppUser user) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veterinary Dashboard'),
        backgroundColor: AppColorStyles.white,
        foregroundColor: AppColorStyles.black,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateTimeUtils.getMonthName(_selectedDay)} ${_selectedDay.day}',
                        style: AppTextStyles.bodyBase.copyWith(fontSize: 14),
                      ),
                      Text(
                        '2025',
                        style: AppTextStyles.bodyBase.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Today you have',
                        style: AppTextStyles.bodyBase.copyWith(fontSize: 14),
                      ),
                      StreamBuilder<List<Booking>>(
                        stream: _db.getVetBookingsForDate(
                          vetID: _auth.currentUser!.uid,
                          date: _selectedDay,
                        ),
                        builder: (context, snapshot) {
                          final bookingsCount = snapshot.data?.length ?? 0;
                          return Text(
                            '$bookingsCount booking${bookingsCount != 1 ? 's' : ''}',
                            style: AppTextStyles.bodyBase.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Calendar and Bookings
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 90,
                    child: TableCalendar(
                      firstDay: DateTime.now().subtract(
                        const Duration(days: 2),
                      ),
                      lastDay: DateTime.now().add(const Duration(days: 20)),
                      focusedDay: _focusedDay,
                      selectedDayPredicate:
                          (day) => isSameDay(day, _selectedDay),
                      calendarFormat: CalendarFormat.week,
                      availableCalendarFormats: const {
                        CalendarFormat.week: 'Week',
                      },
                      headerVisible: false,
                      daysOfWeekVisible: true,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        selectedDecoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        defaultTextStyle: AppTextStyles.bodyBase,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Display bookings for selected day
                  Expanded(
                    child: StreamBuilder<List<Booking>>(
                      stream: _db.getVetBookingsForDate(
                        vetID: _auth.currentUser!.uid,
                        date: _selectedDay,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        final bookings = snapshot.data ?? [];

                        if (bookings.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LineIcons.calendar,
                                  size: 64,
                                  color: AppColorStyles.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No bookings for this day',
                                  style: AppTextStyles.bodyBase.copyWith(
                                    color: AppColorStyles.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: bookings.length,
                          itemBuilder: (context, index) {
                            final booking = bookings[index];
                            return Slidable(
                              key: ValueKey(booking.bookingID),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  if (booking.status ==
                                      BookingStatus.pending) ...[
                                    SlidableAction(
                                      onPressed:
                                          (context) => _acceptBooking(booking),
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      icon: Icons.check,
                                      label: 'Accept',
                                    ),
                                    SlidableAction(
                                      onPressed:
                                          (context) => _declineBooking(booking),
                                      backgroundColor: AppColorStyles.pastelRed,
                                      foregroundColor: Colors.white,
                                      icon: Icons.close,
                                      label: 'Decline',
                                    ),
                                  ],
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColorStyles.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColorStyles.lightGrey,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColorStyles.black.withOpacity(
                                        0.05,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          BookingService.formatTimeSlot(
                                            booking.dateTime.toDate(),
                                            booking.duration,
                                          ),
                                          style: AppTextStyles.bodyBase
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(
                                              booking.status,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            BookingService.getStatusText(
                                              booking.status,
                                            ),
                                            style: AppTextStyles.bodySmall
                                                .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Pet ID: ${booking.petID}',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColorStyles.grey,
                                      ),
                                    ),
                                    Text(
                                      'Duration: ${BookingService.formatDuration(booking.duration)}',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColorStyles.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.accepted:
        return Colors.green;
      case BookingStatus.declined:
        return AppColorStyles.pastelRed;
    }
  }

  void _acceptBooking(Booking booking) async {
    try {
      await _db.updateBookingStatus(booking.bookingID!, BookingStatus.accepted);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking accepted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error accepting booking: $e')));
      }
    }
  }

  void _declineBooking(Booking booking) async {
    try {
      await _db.updateBookingStatus(booking.bookingID!, BookingStatus.declined);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Booking declined')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error declining booking: $e')));
      }
    }
  }
}
