import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/trip_model.dart';
import '../widgets/create_trip_modal.dart';
import 'profile_screen.dart';
import 'trip_detail_screen.dart';



class HomeScreen extends StatefulWidget {
  final String? userName;

  const HomeScreen({super.key, this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String displayName;
  late List<Trip> trips;

@override
  void initState() {
    super.initState();
    displayName = widget.userName ?? 'Stefani';
    trips = [];
  }
  
  void _showCreateTripModal() {
    showDialog(
      context: context,
      builder: (context) => CreateTripModal(
        onSave: (Trip newTrip) {
          setState(() {
            trips.add(newTrip);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.brownPrimary,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 35.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Kamusta, ',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        '$displayName!',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text('👋', style: TextStyle(fontSize: 18.sp)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Plan your next adventure',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey.shade400),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search trips by name or destination...',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: Colors.grey.shade400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: trips.isEmpty
                  ? Center(
                      child: Text(
                        'No trips yet. Create one!',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(24.w),
                      itemCount: trips.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            _buildTripCard(trips[index]),
                            if (index < trips.length - 1) SizedBox(height: 16.h),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.brownPrimary,
        onPressed: _showCreateTripModal,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.card_travel), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }

 Widget _buildTripCard(Trip trip) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TripDetailScreen(trip: trip)),
        );
      },
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150.h,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: Image.asset(
                trip.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    trip.destination,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14.sp, color: Colors.grey.shade600),
                          SizedBox(width: 6.w),
                          Text(
                            '${trip.startDate} - ${trip.endDate}',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₱${trip.budget}',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brownPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}