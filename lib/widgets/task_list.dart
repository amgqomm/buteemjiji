// widgets/task_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/task/task_cubit.dart';
import '../models/task_model.dart';
import '../utils/app_enums.dart';
import 'empty_task_state.dart';
import 'habit_item.dart';
import 'daily_item.dart';
import 'todo_item.dart';
import 'reward_item.dart';

class TaskList extends StatelessWidget {
  final TaskType taskType;
  final Function(TaskType) onAddPressed;

  const TaskList({
    super.key,
    required this.taskType,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state.status == TaskStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == TaskStatus.error) {
          return Center(
            child: Text(
              'Error: ${state.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final tasks = context.read<TaskCubit>().getTasksByType(taskType);

        if (tasks.isEmpty) {
          return EmptyTaskState(
            taskType: taskType,
            onAddPressed: () => onAddPressed(taskType),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _buildTaskItem(task);
          },
        );
      },
    );
  }

  Widget _buildTaskItem(Task task) {
    switch (task.type) {
      case TaskType.habit:
        return HabitItem(task: task);
      case TaskType.daily:
        return DailyItem(task: task);
      case TaskType.todo:
        return TodoItem(task: task);
      case TaskType.reward:
        return RewardItem(task: task);
    }
  }
}