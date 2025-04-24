// widgets/habit_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../cubits/task/task_cubit.dart';
import '../models/task_model.dart';
import '../routes/app_router.dart';

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
        child: ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPositive)
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: () {
                    context.read<TaskCubit>().completeTask(task);
                  },
                ),
              if (!isPositive)
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.red),
                  onPressed: () {
                    context.read<TaskCubit>().completeTask(task);
                  },
                ),
            ],
          ),
          title: Text(task.title),
        ),
      ),
    );
  }
}