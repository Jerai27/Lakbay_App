class TaskItem {
  final String id;
  final String title;
  final String? description;
  final String? dueDate;
  final String? assignedTo;
  final bool isCompleted;
  final int priority; // 0 = Low, 1 = Medium, 2 = High

  TaskItem({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.assignedTo,
    this.isCompleted = false,
    this.priority = 1,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    String? dueDate,
    String? assignedTo,
    bool? isCompleted,
    int? priority,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      assignedTo: assignedTo ?? this.assignedTo,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}
