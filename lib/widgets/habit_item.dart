import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../cubits/task/task_cubit.dart';
import '../models/task_model.dart';
import '../routes/app_router.dart';
import '../utils/theme_constants.dart';

class HabitItem extends StatelessWidget {
  final Task task;

  const HabitItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isPositive = task.isPositive ?? true;

    return GestureDetector(
      onTap: () {
        context.router.push(EditTaskRoute(task: task));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.habitBlue, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isPositive ? AppTheme.positiveGreen : AppTheme.negativeRed,
                    width: 2,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    isPositive ? Icons.add : Icons.remove,
                    color: isPositive ? AppTheme.positiveGreen : AppTheme.negativeRed,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    context.read<TaskCubit>().completeTask(task);
                  },
                ),
              ),
            ],
          ),
          title: Text(task.title),
        ),
      ),
    );
  }
}