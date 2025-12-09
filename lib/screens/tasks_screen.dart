import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/trip_model.dart';
import '../models/task_model.dart';
import '../models/member_model.dart';

class TasksScreen extends StatefulWidget {
  final Trip trip;
  final Function(Trip) onTripUpdated;

  const TasksScreen({
    super.key,
    required this.trip,
    required this.onTripUpdated,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late Trip currentTrip;

  @override
  void initState() {
    super.initState();
    currentTrip = widget.trip;
  }

  int get pendingCount =>
      currentTrip.tasks.where((t) => !t.isCompleted).length;
  int get completedCount =>
      currentTrip.tasks.where((t) => t.isCompleted).length;

  void _showAddTaskModal() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedDueDate;
    String? selectedAssignee;
    int selectedPriority = 1;

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
                    'Add Task',
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

              // Title
              Text(
                'Task Title',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'e.g., Book hotel rooms',
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
              ),
              SizedBox(height: 16.h),

              // Description
              Text(
                'Description (Optional)',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add more details...',
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
              ),
              SizedBox(height: 16.h),

              // Due Date
              Text(
                'Due Date (Optional)',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              StatefulBuilder(
                builder: (context, setModalState) => GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (picked != null) {
                      setModalState(() {
                        selectedDueDate =
                            '${picked.month}/${picked.day}/${picked.year}';
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDueDate ?? 'Select date',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: selectedDueDate != null
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                        ),
                        Icon(Icons.calendar_today,
                            size: 16.sp, color: Colors.grey.shade600),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Assign To
              Text(
                'Assign To (Optional)',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              StatefulBuilder(
                builder: (context, setModalState) =>
                    DropdownButtonFormField<String>(
                  value: selectedAssignee,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text('No one'),
                    ),
                    ...currentTrip.members
                        .map((member) => DropdownMenuItem(
                              value: member.fullName,
                              child: Text(member.fullName),
                            ))
                        .toList(),
                  ],
                  onChanged: (value) {
                    setModalState(() {
                      selectedAssignee = value;
                    });
                  },
                  decoration: InputDecoration(
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
                ),
              ),
              SizedBox(height: 16.h),

              // Priority
              Text(
                'Priority',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              StatefulBuilder(
                builder: (context, setModalState) => Row(
                  children: [
                    _buildPriorityButton('Low', 0, selectedPriority, (val) {
                      setModalState(() => selectedPriority = val);
                    }),
                    SizedBox(width: 8.w),
                    _buildPriorityButton('Medium', 1, selectedPriority, (val) {
                      setModalState(() => selectedPriority = val);
                    }),
                    SizedBox(width: 8.w),
                    _buildPriorityButton('High', 2, selectedPriority, (val) {
                      setModalState(() => selectedPriority = val);
                    }),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Add Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a task title')),
                      );
                      return;
                    }

                    final newTask = TaskItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      description: descriptionController.text.isEmpty
                          ? null
                          : descriptionController.text,
                      dueDate: selectedDueDate,
                      assignedTo: selectedAssignee,
                      priority: selectedPriority,
                    );

                    setState(() {
                      currentTrip.tasks.add(newTask);
                    });

                    widget.onTripUpdated(currentTrip);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ Task added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brownPrimary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Add Task',
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

  Widget _buildPriorityButton(String label, int value, int selected,
      Function(int) onTap) {
    final isSelected = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(value),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.brownPrimary : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color:
                    isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleTaskComplete(int index) {
    final task = currentTrip.tasks[index];
    setState(() {
      currentTrip.tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
    });
    widget.onTripUpdated(currentTrip);
  }

  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task?'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                currentTrip.tasks.removeAt(index);
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
    final pendingTasks =
        currentTrip.tasks.where((t) => !t.isCompleted).toList();
    final completedTasks = currentTrip.tasks.where((t) => t.isCompleted).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            margin: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tasks & Assignments',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Delegate and track responsibilities',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showAddTaskModal(),
                        icon: Icon(Icons.add, size: 16.sp, color: Colors.white),
                      label: Text(
                        'Add Task',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brownPrimary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Stats
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending',
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '$pendingCount',
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Completed',
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '$completedCount',
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Pending Tasks
          if (pendingTasks.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '● Pending (${pendingTasks.length})',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...pendingTasks.asMap().entries.map((e) {
                    final index = currentTrip.tasks.indexOf(e.value);
                    return _buildTaskCard(e.value, index, false);
                  }),
                  SizedBox(height: 20.h),
                ],
              ),
            ),

          // Completed Tasks
          if (completedTasks.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '● Completed (${completedTasks.length})',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...completedTasks.asMap().entries.map((e) {
                    final index = currentTrip.tasks.indexOf(e.value);
                    return _buildTaskCard(e.value, index, true);
                  }),
                  SizedBox(height: 20.h),
                ],
              ),
            ),

          // Empty State
          if (currentTrip.tasks.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Column(
                children: [
                  Icon(
                    Icons.checklist,
                    size: 64.sp,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No tasks yet',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskItem task, int index, bool isCompleted) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              GestureDetector(
                onTap: () => _toggleTaskComplete(index),
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted
                          ? AppColors.brownPrimary
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    color:
                        isCompleted ? AppColors.brownPrimary : Colors.transparent,
                  ),
                  child: isCompleted
                      ? Icon(Icons.check,
                          size: 14.sp, color: Colors.white)
                      : null,
                ),
              ),
              SizedBox(width: 12.w),

              // Title & Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    if (task.description != null && task.description!.isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      Text(
                        task.description!,
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Delete Button
              GestureDetector(
                onTap: () => _deleteTask(index),
                child: Icon(
                  Icons.close,
                  size: 18.sp,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Task Meta Info
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              // Priority Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  _getPriorityLabel(task.priority),
                  style: GoogleFonts.poppins(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: _getPriorityColor(task.priority),
                  ),
                ),
              ),

              // Due Date
              if (task.dueDate != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today,
                          size: 10.sp, color: Colors.grey.shade600),
                      SizedBox(width: 3.w),
                      Text(
                        'Due ${task.dueDate}',
                        style: GoogleFonts.poppins(
                          fontSize: 9.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

              // Assignee
              if (task.assignedTo != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person,
                          size: 10.sp, color: Colors.grey.shade600),
                      SizedBox(width: 3.w),
                      Text(
                        task.assignedTo!,
                        style: GoogleFonts.poppins(
                          fontSize: 9.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 2:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 0:
      default:
        return Colors.green;
    }
  }

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 2:
        return '🔴 High';
      case 1:
        return '🟠 Medium';
      case 0:
      default:
        return '🟢 Low';
    }
  }
}
