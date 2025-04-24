// widgets/todo_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../cubits/task/task_cubit.dart';
import '../models/task_model.dart';
import '../routes/app_router.dart';

class TodoItem extends StatelessWidget {
  final Task task;

  const TodoItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted ?? false;
    final dueDate = task.dueDate;
    final isPastDue = dueDate != null &&
        dueDate.isBefore(DateTime.now()) &&
        !isCompleted;

    return GestureDetector(
      onTap: () {
        context.router.push(EditTaskRoute(task: task));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        elevation: isPastDue ? 3 : 1,
        color: isPastDue ? Colors.red.shade50 : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPastDue
              ? BorderSide(color: Colors.red.shade300, width: 1.0)
              : BorderSide.none,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: Checkbox(
            value: isCompleted,
            activeColor: isPastDue ? Colors.red : null,
            onChanged: (bool? value) {
              if (value == true && !isCompleted) {
                context.read<TaskCubit>().completeTask(task);
                Future.delayed(const Duration(milliseconds: 800), () {
                  context.read<TaskCubit>().deleteTask(task);
                });
              }
            },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isPastDue && !isCompleted ? FontWeight.bold : null,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted
                  ? Colors.grey
                  : isPastDue ? Colors.red.shade700 : null,
            ),
          ),
          subtitle: dueDate != null
              ? _buildDueDateSubtitle(dueDate, isPastDue)
              : null,
          trailing: isPastDue
              ? Container(
            width: 4,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(4),
            ),
          )
              : null,
        ),
      ),
    );
  }

  Widget _buildDueDateSubtitle(DateTime dueDate, bool isPastDue) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          if (isPastDue)
            Icon(
              Icons.warning_rounded,
              color: Colors.red.shade700,
              size: 16,
            ),
          if (isPastDue) const SizedBox(width: 4),
          Text(
            isPastDue
                ? 'Past due: ${dueDate.day}/${dueDate.month}/${dueDate.year}'
                : 'Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}',
            style: TextStyle(
              fontSize: 14,
              color: isPastDue ? Colors.red.shade700 : Colors.grey.shade600,
              fontWeight: isPastDue ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}