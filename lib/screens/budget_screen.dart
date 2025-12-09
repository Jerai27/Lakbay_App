import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/trip_model.dart';

class BudgetScreen extends StatefulWidget {
  final Trip trip;
  final Function(Trip) onTripUpdated;

  const BudgetScreen({
    super.key,
    required this.trip,
    required this.onTripUpdated,
  });

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late Trip currentTrip;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedCategory = 'Food';

  final List<String> categories = [
    'Food',
    'Transportation',
    'Accommodation',
    'Activities',
    'Shopping',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    currentTrip = widget.trip;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

void _addExpense() {
  if (descriptionController.text.isEmpty || amountController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all fields')),
    );
    return;
  }

  try {
    final expense = Expense(
      description: descriptionController.text,
      category: selectedCategory,
      cost: double.parse(amountController.text),
      date: DateTime.now().toString().split(' ')[0],  // ← ADD DATE
    );

    setState(() {
      currentTrip.expenses.add(expense);
    });

    widget.onTripUpdated(currentTrip);
    descriptionController.clear();
    amountController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Expense added successfully'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid amount')),
    );
  }
}

  void _deleteExpense(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Expense?'),
        content: Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                currentTrip.expenses.removeAt(index);
              });
              widget.onTripUpdated(currentTrip);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalSpent = currentTrip.expenses.fold(0, (sum, e) => sum + e.cost);
    double remaining = currentTrip.budget - totalSpent;
    double percentageUsed = (totalSpent / currentTrip.budget * 100).clamp(0, 100);
    
    // Per-person share calculation (assuming trip members count, default to 1)
    int memberCount = currentTrip.members.isEmpty ? 1 : currentTrip.members.length;
    double perPersonShare = totalSpent / memberCount;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Budget Overview Card
          Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budget Overview',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 20.h),

                // Circular Progress with percentage
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140.w,
                        height: 140.w,
                        child: CircularProgressIndicator(
                          value: percentageUsed / 100,
                          strokeWidth: 8.w,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.brownPrimary,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Used',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '${percentageUsed.toStringAsFixed(0)}%',
                            style: GoogleFonts.poppins(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.brownPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Budget Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBudgetStat(
                      'Total Budget',
                      '₱${currentTrip.budget.toStringAsFixed(0)}',
                      Colors.grey.shade800,
                    ),
                    Container(
                      height: 40.h,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _buildBudgetStat(
                      'Spent',
                      '₱${totalSpent.toStringAsFixed(0)}',
                      Colors.orange,
                    ),
                    Container(
                      height: 40.h,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _buildBudgetStat(
                      'Remaining',
                      '₱${remaining.toStringAsFixed(0)}',
                      remaining < 0 ? Colors.red : Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),

// Per-Person Share Card - UPDATED DESIGN
Container(
  margin: EdgeInsets.symmetric(horizontal: 16.w),
  padding: EdgeInsets.all(16.w),
  decoration: BoxDecoration(
    color: Color(0xFFFFF3E0), // Light orange background
    borderRadius: BorderRadius.circular(12.r),
    border: Border.all(color: Color(0xFFFFE0B2)),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Per-Person Share',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Split among ${memberCount} member${memberCount > 1 ? 's' : ''}',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 12.h),
            // Total Trip Cost
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Trip Cost',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '₱${totalSpent.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Your Share
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Share',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '₱${perPersonShare.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brownPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Info Text
            Text(
              '⚠️ This amount updates automatically as expenses are added',
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: 16.w),
      // Icon Button - RIGHT SIDE
      Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.brownPrimary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.trending_up,
          color: Colors.white,
          size: 22.sp,
        ),
      ),
    ],
  ),
),



          SizedBox(height: 20.h),
// Add Expense Section
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expenses',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddExpenseModal(),
                  icon: Icon(Icons.add, size: 16.sp, color: Colors.white),
                  label: Text(
                    'Add Expense',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brownPrimary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Expenses List
          if (currentTrip.expenses.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64.sp,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No expenses yet',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: currentTrip.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = currentTrip.expenses[index];
                      return _buildExpenseCard(expense, index);
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
        ],
      ),
    );
  }
void _showEditExpenseModal(Expense expense, int index) {
  final editDescriptionController = TextEditingController(text: expense.description);
  final editAmountController = TextEditingController(text: expense.cost.toString());
  String editSelectedCategory = expense.category;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.r),
        topRight: Radius.circular(20.r),
      ),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.w,
        right: 16.w,
        top: 16.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Expense',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Amount
            Text(
              'Amount (₱)',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: editAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0.00',
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Category
            Text(
              'Category',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            DropdownButtonFormField<String>(
              value: editSelectedCategory,
              items: categories
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ))
                  .toList(),
              onChanged: (value) {
                editSelectedCategory = value ?? 'Food';
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.category, size: 16.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Note (Description)
            Text(
              'Note',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: editDescriptionController,
              decoration: InputDecoration(
                hintText: 'e.g., Taxi to hotel',
                prefixIcon: Icon(Icons.description, size: 16.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Date (read-only)
            Text(
              'Date',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: expense.date,
                prefixIcon: Icon(Icons.calendar_today, size: 16.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (editDescriptionController.text.isEmpty ||
                      editAmountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  try {
                    final updatedExpense = Expense(
                      description: editDescriptionController.text,
                      category: editSelectedCategory,
                      cost: double.parse(editAmountController.text),
                      date: expense.date,
                    );

                    setState(() {
                      currentTrip.expenses[index] = updatedExpense;
                    });

                    widget.onTripUpdated(currentTrip);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ Expense updated'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid amount')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brownPrimary,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Update Expense',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    ),
  );
}

  

  void _showAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.w,
          right: 16.w,
          top: 16.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Expense',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),

              // Description
              Text(
                'Description',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'e.g., Taxi to hotel',
                  prefixIcon: Icon(Icons.description, size: 16.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Category
              Text(
                'Category',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value ?? 'Food';
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.category, size: 16.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Amount
              Text(
                'Amount (₱)',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
    
              SizedBox(height: 20.h),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '0.00',
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                ),
              ),



              // Add Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _addExpense();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brownPrimary,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Add Expense',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetStat(String label, String amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          amount,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

Widget _buildExpenseCard(Expense expense, int index) {
  return GestureDetector(
    onTap: () => _showEditExpenseModal(expense, index),  // ← TAP TO EDIT
    child: Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Category Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _getCategoryColor(expense.category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              expense.category,
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: _getCategoryColor(expense.category),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.description,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  expense.date,  // ← SHOW DATE
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₱${expense.cost.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brownPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => _deleteExpense(index),
                child: Icon(
                  Icons.close,
                  size: 16.sp,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orange;
      case 'Transportation':
        return Colors.blue;
      case 'Accommodation':
        return Colors.purple;
      case 'Activities':
        return Colors.green;
      case 'Shopping':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
