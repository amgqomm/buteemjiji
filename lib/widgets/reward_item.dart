import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../cubits/task/task_cubit.dart';
import '../cubits/user/user_cubit.dart';
import '../models/task_model.dart';
import '../routes/app_router.dart';
import '../utils/theme_constants.dart';

class RewardItem extends StatelessWidget {
  final Task task;

  const RewardItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final hasEnoughCoins =
            userState.user != null && userState.user!.coin >= (task.cost ?? 0);

        return GestureDetector(
          onTap: () {
            context.router.push(EditTaskRoute(task: task));
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppTheme.rewardOrange, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              leading: InkWell(
                onTap: hasEnoughCoins
                    ? () => _purchaseReward(context)
                    : () => _showInsufficientCoinsMessage(context),
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.coinOrange, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    color: AppTheme.coinOrange,
                    size: 20,
                  ),
                ),
              ),
              title: Text(task.title, style: const TextStyle(fontSize: 16)),
              subtitle: Text(
                'Үнэ: ${task.cost ?? 0}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
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
        backgroundColor: AppTheme.positiveGreen,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showInsufficientCoinsMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Худалдан авахад зоос хүрэхгүй байна!'),
        backgroundColor: AppTheme.negativeRed,
        duration: Duration(seconds: 1),
      ),
    );
  }
}
