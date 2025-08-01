import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/booking.dart';
import 'package:fyp_pawsenvy/core/services/booking.service.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/providers/booking.provider.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';
import 'package:provider/provider.dart';

class VetBookingsScreen extends StatefulWidget {
  const VetBookingsScreen({super.key});

  @override
  State<VetBookingsScreen> createState() => _VetBookingsScreenState();
}

class _VetBookingsScreenState extends State<VetBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Start listening to bookings when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookings();
    });
  }

  void _loadBookings() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(
      context,
      listen: false,
    );

    if (userProvider.user != null) {
      // Use the actual user ID as the vet ID
      bookingProvider.listenToVetBookings(userProvider.user!.name);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings', style: AppTextStyles.headingMedium),
        backgroundColor: AppColorStyles.white,
        foregroundColor: AppColorStyles.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColorStyles.purple,
          unselectedLabelColor: AppColorStyles.lightGrey,
          indicatorColor: AppColorStyles.purple,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          if (bookingProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (bookingProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${bookingProvider.error}',
                    style: AppTextStyles.bodyBase,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      bookingProvider.clearError();
                      _loadBookings();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildBookingsList(
                _filterBookingsByStatus(
                  bookingProvider.vetBookings,
                  BookingStatus.pending,
                ),
              ),
              _buildBookingsList(
                _filterBookingsByStatus(
                  bookingProvider.vetBookings,
                  BookingStatus.accepted,
                ),
              ),
              _buildBookingsList(bookingProvider.vetBookings),
            ],
          );
        },
      ),
    );
  }

  List<Booking> _filterBookingsByStatus(
    List<Booking> bookings,
    BookingStatus status,
  ) {
    return bookings.where((booking) => booking.status == status).toList();
  }

  Widget _buildBookingsList(List<Booking> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 64, color: AppColorStyles.lightGrey),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: AppTextStyles.bodyBase.copyWith(
                color: AppColorStyles.lightGrey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final bookingDateTime = booking.dateTime.toDate();
    final isExpired = BookingService.isBookingExpired(bookingDateTime);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pet ID: ${booking.petID}',
                        style: AppTextStyles.bodyBase.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        BookingService.formatBookingDate(bookingDateTime),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColorStyles.grey,
                        ),
                      ),
                      Text(
                        BookingService.formatTimeSlot(
                          bookingDateTime,
                          booking.duration,
                        ),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColorStyles.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(
                      int.parse(
                        BookingService.getStatusColor(
                          booking.status,
                        ).replaceFirst('#', '0xFF'),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    BookingService.getStatusText(booking.status),
                    style: AppTextStyles.bodyExtraSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Duration: ${BookingService.formatDuration(booking.duration)}',
              style: AppTextStyles.bodySmall,
            ),
            if (!isExpired && booking.status == BookingStatus.pending) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _acceptBooking(booking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorStyles.pastelGreen,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _declineBooking(booking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorStyles.pastelRed,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                ],
              ),
            ],
            if (isExpired) ...[
              const SizedBox(height: 8),
              Text(
                'This booking has expired',
                style: AppTextStyles.bodyExtraSmall.copyWith(
                  color: AppColorStyles.lightGrey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _acceptBooking(Booking booking) async {
    if (booking.bookingID == null) return;

    final bookingProvider = Provider.of<BookingProvider>(
      context,
      listen: false,
    );
    final success = await bookingProvider.acceptBooking(booking.bookingID!);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking accepted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _declineBooking(Booking booking) async {
    if (booking.bookingID == null) return;

    final bookingProvider = Provider.of<BookingProvider>(
      context,
      listen: false,
    );
    final success = await bookingProvider.declineBooking(booking.bookingID!);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking declined'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
