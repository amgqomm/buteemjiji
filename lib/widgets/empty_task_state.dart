import 'package:flutter/material.dart';
import '../utils/app_enums.dart';
import '../utils/theme_constants.dart';

class EmptyTaskState extends StatelessWidget {
  final TaskType taskType;
  final VoidCallback onAddPressed;

  const EmptyTaskState({
    super.key,
    required this.taskType,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    String message;
    IconData iconData;

    switch (taskType) {
      case TaskType.habit:
        message = 'Эерег зуршил суулгаж, сөрөг зуршлаасаа сал';
        iconData = Icons.assignment_outlined;
        break;
      case TaskType.daily:
        message = 'Өдөр тутмын бүтээмжээ удирд';
        iconData = Icons.calendar_today_outlined;
        break;
      case TaskType.todo:
        message = 'Хугацаатай зорилгоо төлөвлө';
        iconData = Icons.check_circle_outline;
        break;
      case TaskType.reward:
        message = 'Өөрийгөө урамшуул';
        iconData = Icons.emoji_events_outlined;
        break;
    }

    String taskTypeName;
    switch (taskType) {
      case TaskType.habit:
        taskTypeName = 'Зуршил';
        break;
      case TaskType.daily:
        taskTypeName = 'Даалгавар';
        break;
      case TaskType.todo:
        taskTypeName = 'Зорилго';
        break;
      case TaskType.reward:
        taskTypeName = 'Урамшуулал';
        break;
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              '$taskTypeName байхгүй',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}