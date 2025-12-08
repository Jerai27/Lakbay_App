import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/trip_model.dart';


class EditTripModal extends StatefulWidget {
  final Trip trip;
  final Function(Trip) onSave;

  const EditTripModal({
    super.key,
    required this.trip,
    required this.onSave,
  });

  @override
  State<EditTripModal> createState() => _EditTripModalState();
}

class _EditTripModalState extends State<EditTripModal> {
  late TextEditingController titleController;
  late TextEditingController destinationController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.trip.title);
    destinationController = TextEditingController(text: widget.trip.destination);
    startDateController = TextEditingController(text: widget.trip.startDate);
    endDateController = TextEditingController(text: widget.trip.endDate);
  }

  @override
  void dispose() {
    titleController.dispose();
    destinationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

void _saveTrip() {
  if (titleController.text.isEmpty ||
      destinationController.text.isEmpty ||
      startDateController.text.isEmpty ||
      endDateController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all fields')),
    );
    return;
  }

  final updatedTrip = Trip(
    title: titleController.text,
    destination: destinationController.text,
    startDate: startDateController.text,
    endDate: endDateController.text,
    image: widget.trip.image,
    budget: widget.trip.budget,
  );

  widget.onSave(updatedTrip);
  Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
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
                    'Edit Trip',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: Colors.white, size: 24.sp),
                  ),
                ],
              ),
            ),

            // Form Content
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trip Title
                  Text(
                    'Trip Title',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Cebu Trip',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.brownPrimary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Destination
                  Text(
                    'Destination',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: destinationController,
                    decoration: InputDecoration(
                      hintText: 'Cebu City',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.brownPrimary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Start Date and End Date Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextField(
                              controller: startDateController,
                              decoration: InputDecoration(
                                hintText: 'MM/DD/YYYY',
                                hintStyle:
                                    GoogleFonts.poppins(color: Colors.grey.shade400),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 12.h),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: AppColors.brownPrimary,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Date',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextField(
                              controller: endDateController,
                              decoration: InputDecoration(
                                hintText: 'MM/DD/YYYY',
                                hintStyle:
                                    GoogleFonts.poppins(color: Colors.grey.shade400),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 12.h),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: AppColors.brownPrimary,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveTrip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brownPrimary,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Update Trip',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
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
    );
  }
}

