import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/trip_model.dart';

class CreateTripModal extends StatefulWidget {
  final Function(Trip) onTripCreated;

  const CreateTripModal({super.key, required this.onTripCreated});

  @override
  State<CreateTripModal> createState() => _CreateTripModalState();
}

class _CreateTripModalState extends State<CreateTripModal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    destinationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.text = '${picked.month}/${picked.day}/${picked.year}';
    }
  }

    void _createTrip() {
    if (titleController.text.isEmpty ||
        destinationController.text.isEmpty ||
        startDateController.text.isEmpty ||
        endDateController.text.isEmpty ||
        budgetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      final int budget = int.parse(budgetController.text);
      
      Trip newTrip = Trip(
        title: titleController.text,
        destination: destinationController.text,
        startDate: startDateController.text,
        endDate: endDateController.text,
        budget: budget,  
        image: 'assets/images/default_trip.jpg',
      );

      widget.onTripCreated(newTrip);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid budget format')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.brownPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Plan New Trip',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trip Title
                    Text(
                      'Trip Title',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Summer Cebu Adventure',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.grey.shade400,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14.sp),
                    ),

                    SizedBox(height: 20.h),

                    // Destination
                    Text(
                      'Destination',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: destinationController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Cebu, Philippines',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.grey.shade400,
                        ),
                        prefixIcon: Icon(Icons.location_on,
                            color: AppColors.brownPrimary),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14.sp),
                    ),

                    SizedBox(height: 20.h),

                    // Start & End Dates
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              TextField(
                                controller: startDateController,
                                readOnly: true,
                                onTap: () => _selectDate(startDateController),
                                decoration: InputDecoration(
                                  hintText: 'Select date',
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: Colors.grey.shade400,
                                  ),
                                  prefixIcon: Icon(Icons.calendar_today,
                                      color: AppColors.brownPrimary),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 14.h,
                                  ),
                                ),
                                style: GoogleFonts.poppins(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'End Date',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              TextField(
                                controller: endDateController,
                                readOnly: true,
                                onTap: () => _selectDate(endDateController),
                                decoration: InputDecoration(
                                  hintText: 'Select date',
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: Colors.grey.shade400,
                                  ),
                                  prefixIcon: Icon(Icons.calendar_today,
                                      color: AppColors.brownPrimary),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 14.h,
                                  ),
                                ),
                                style: GoogleFonts.poppins(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                  // Budget
                    Text(
                      'Initial Budget (₱)',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: budgetController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '10000',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.grey.shade400,
                        ),
                        prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 12.w, right: 8.w),
                        child: Text(
                          '₱',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.brownPrimary,
                          ),
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 40.w),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14.sp),
                    ),

                    SizedBox(height: 24.h),

                    // Start Adventure Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _createTrip,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brownPrimary,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Start Adventure',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
