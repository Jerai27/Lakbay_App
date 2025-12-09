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
  late TextEditingController budgetController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.trip.title);
    destinationController = TextEditingController(text: widget.trip.destination);
    startDateController = TextEditingController(text: widget.trip.startDate);
    endDateController = TextEditingController(text: widget.trip.endDate);
    budgetController = TextEditingController(text: widget.trip.budget.toString());
  }

  @override
  void dispose() {
    titleController.dispose();
    destinationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    budgetController.dispose();
    super.dispose();
  }

Future<void> _selectStartDate() async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2024),
    lastDate: DateTime(2030),
  );
  if (picked != null) {
    setState(() {
      startDateController.text = '${picked.month}/${picked.day}/${picked.year}';
      
      // Reset end date if it's before start date
      try {
        final endParts = endDateController.text.split('/');
        final currentEndDate = DateTime(
          int.parse(endParts[2]),
          int.parse(endParts[0]),
          int.parse(endParts[1]),
        );
        
        if (currentEndDate.isBefore(picked)) {
          endDateController.text = '';
        }
      } catch (e) {
        // If end date is not set, ignore
      }
    });
  }
}

Future<void> _selectEndDate() async {
  // End date picker should not allow dates before start date
  if (startDateController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select start date first')),
    );
    return;
  }

  try {
    // Parse start date carefully
    final startText = startDateController.text.trim();
    final startParts = startText.split('/');
    
    if (startParts.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid start date format. Use MM/DD/YYYY')),
      );
      return;
    }

    final startDate = DateTime(
      int.parse(startParts[2]), // Year
      int.parse(startParts[0]), // Month
      int.parse(startParts[1]), // Day
    );

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.add(Duration(days: 1)), // Default to day after start
      firstDate: startDate,
      lastDate: DateTime(2030),
    );
    
    if (picked != null) {
      setState(() {
        endDateController.text = '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  } catch (e) {
    print('Error selecting end date: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: Invalid start date. Please set start date first.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

void _saveTrip() {
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

  // Validate end date is not before start date
  try {
    final startParts = startDateController.text.split('/');
    final endParts = endDateController.text.split('/');
    
    final startDate = DateTime(
      int.parse(startParts[2]),
      int.parse(startParts[0]),
      int.parse(startParts[1]),
    );
    
    final endDate = DateTime(
      int.parse(endParts[2]),
      int.parse(endParts[0]),
      int.parse(endParts[1]),
    );
    
    if (endDate.isBefore(startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ End date must be the same or after start date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid date format')),
    );
    return;
  }

 try {
final updatedTrip = Trip(
      id: widget.trip.id,
      title: titleController.text,
      destination: destinationController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      budget: double.parse(budgetController.text),
      image: widget.trip.image,
      members: widget.trip.members,
      activities: widget.trip.activities,
      expenses: widget.trip.expenses,
    );
    
    widget.onSave(updatedTrip);
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
                                readOnly: true,
                                onTap: _selectStartDate,  // ← ADD THIS
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
                              readOnly: true,
                              onTap: _selectEndDate,
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
                  SizedBox(height: 16.h),

                  // Budget
                  Text(
                    'Initial Budget (₱)',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: budgetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '10000',
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
