class ScheduleItemModel {
  final String id;
  final String title;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String reminder;
  final String repeat;
  final String? note;
  final bool isCompleted;
  final String category;

  const ScheduleItemModel({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.reminder = '10 phút trước',
    this.repeat = 'Không lặp lại',
    this.note,
    this.isCompleted = false,
    this.category = 'Cá nhân',
  });

  ScheduleItemModel copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? reminder,
    String? repeat,
    String? note,
    bool? isCompleted,
    String? category,
  }) {
    return ScheduleItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reminder: reminder ?? this.reminder,
      repeat: repeat ?? this.repeat,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
    );
  }
}
