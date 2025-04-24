import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../cubits/task/task_cubit.dart';
import '../models/task_model.dart';
import '../routes/app_router.dart';
import '../utils/theme_constants.dart';

class DailyItem extends StatelessWidget {
  final Task task;

  const DailyItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted ?? false;

    return GestureDetector(
      onTap: () {
        context.router.push(EditTaskRoute(task: task));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.dailyPurple, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Checkbox(
            value: isCompleted,
            checkColor: AppTheme.cardBackground,
            activeColor: AppTheme.dailyPurple,
            onChanged: (bool? value) {
              if (value == true && !isCompleted) {
                context.read<TaskCubit>().completeTask(task);
              }
            },
          ),
          title: Text(
            task.title,
            style: isCompleted
                ? const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: AppTheme.dailyPurple,
            )
                : null,
          ),
        ),
      ),
    );
  }
}