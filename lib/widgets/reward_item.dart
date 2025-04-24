// widgets/reward_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../cubits/task/task_cubit.dart';
import '../cubits/user/user_cubit.dart';
import '../models/task_model.dart';
import '../routes/app_router.dart';

class RewardItem extends StatelessWidget {
  final Task task;

  const RewardItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final hasEnoughCoins = userState.user != null &&
            userState.user!.coin >= (task.cost ?? 0);

        return GestureDetector(
          onTap: () {
            context.router.push(EditTaskRoute(task: task));
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: hasEnoughCoins
                    ? () => _purchaseReward(context)
                    : () => _showInsufficientCoinsMessage(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.attach_money,
                    color: Colors.yellow,
                  ),
                ),
              ),
              title: Text(task.title),
              subtitle: Text('${task.cost ?? 0} зоос'),
            ),
          ),
        );
      },
    );
  }

  void _purchaseReward(BuildContext context) {
    context.read<TaskCubit>().completeTask(task);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${task.title} шагналыг амжилттай авлаа!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showInsufficientCoinsMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Худалдан авахад зоос хүрэхгүй байна!'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}