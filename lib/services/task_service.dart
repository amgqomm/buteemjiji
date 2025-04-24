import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import '../utils/app_enums.dart';
import 'user_service.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  Stream<List<Task>> streamTasksByType(String uid, TaskType type) {
    String typeString = type.toString().split('.').last;

    return _firestore
        .collection('tasks')
        .where('uid', isEqualTo: uid)
        .where('type', isEqualTo: typeString)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList(),
        );
  }

  Future<Task> createTask(Task task) async {
    try {
      final docRef = await _firestore.collection('tasks').add(task.toMap());
      return task.copyWith(taskId: docRef.id);
    } catch (e) {
      throw Exception('Error creating task: ${e.toString()}');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _firestore
          .collection('tasks')
          .doc(task.taskId)
          .update(task.toMap());
    } catch (e) {
      throw Exception('Error updating task: ${e.toString()}');
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      await _firestore.collection('tasks').doc(task.taskId).delete();
    } catch (e) {
      throw Exception('Error deleting task: ${e.toString()}');
    }
  }

  Future<void> completeTask(Task task, {bool isPenalty = false}) async {
    try {
      int healthChange = 0;
      int expChange = 0;
      int coinChange = 0;

      switch (task.type) {
        case TaskType.habit:
          if (task.isPositive!) {
            switch (task.difficulty) {
              case Difficulty.easy:
                expChange = 3;
                coinChange = 0;
                break;
              case Difficulty.medium:
                expChange = 6;
                coinChange = 1;
                break;
              case Difficulty.hard:
                expChange = 9;
                coinChange = 2;
                break;
              default:
                expChange = 3;
                coinChange = 0;
            }
          } else {
            switch (task.difficulty) {
              case Difficulty.easy:
                healthChange = -2;
                break;
              case Difficulty.medium:
                healthChange = -4;
                break;
              case Difficulty.hard:
                healthChange = -6;
                break;
              default:
                healthChange = -2;
            }
          }
          break;

        case TaskType.daily:
          final now = DateTime.now();
          await updateTask(
            task.copyWith(isCompleted: !isPenalty, lastCompletedDate: now),
          );
          if (!isPenalty) {
            switch (task.difficulty) {
              case Difficulty.easy:
                expChange = 3;
                coinChange = 0;
                break;
              case Difficulty.medium:
                expChange = 6;
                coinChange = 1;
                break;
              case Difficulty.hard:
                expChange = 9;
                coinChange = 2;
                break;
              default:
                expChange = 3;
                coinChange = 0;
            }
          } else {
            switch (task.difficulty) {
              case Difficulty.easy:
                healthChange = -2;
                break;
              case Difficulty.medium:
                healthChange = -4;
                break;
              case Difficulty.hard:
                healthChange = -6;
                break;
              default:
                healthChange = -2;
            }
          }

          break;

        case TaskType.todo:
          if (!isPenalty) {
            await updateTask(task.copyWith(isCompleted: true));

            switch (task.difficulty) {
              case Difficulty.easy:
                expChange = 3;
                coinChange = 0;
                break;
              case Difficulty.medium:
                expChange = 6;
                coinChange = 1;
                break;
              case Difficulty.hard:
                expChange = 9;
                coinChange = 2;
                break;
              default:
                expChange = 3;
                coinChange = 0;
            }
          } else {
            switch (task.difficulty) {
              case Difficulty.easy:
                healthChange = -2;
                break;
              case Difficulty.medium:
                healthChange = -4;
                break;
              case Difficulty.hard:
                healthChange = -6;
                break;
              default:
                healthChange = -2;
            }
          }
          break;

        case TaskType.reward:
          coinChange = -(task.cost!);
          break;
      }
      if (expChange != 0 || healthChange != 0 || coinChange != 0) {
        await _userService.updateUserStats(
          uid: task.uid,
          expChange: expChange,
          healthChange: healthChange,
          coinChange: coinChange,
        );
      }
    } catch (e) {
      throw Exception('Error completing task: ${e.toString()}');
    }
  }

  Future<void> resetDailyTasks(String uid) async {
    try {
      final dailyTasks =
          await getTasksByType(uid: uid, type: TaskType.daily, isCompleted: true);

      final batch = _firestore.batch();
      final now = DateTime.now();

      for (final task in dailyTasks) {
        if (shouldResetTask(task, now)) {
          batch.update(_firestore.collection('tasks').doc(task.taskId),
              {'isCompleted': false}
          );
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Error resetting daily tasks: ${e.toString()}');
    }
  }

  bool shouldResetTask(Task task, DateTime now) {
    final lastCompletedDate = task.lastCompletedDate!;
    final interval = task.interval!;

    final lastDate = DateTime(lastCompletedDate.year, lastCompletedDate.month, lastCompletedDate.day);
    final today = DateTime(now.year, now.month, now.day);

    switch (task.repeat) {
      case RepeatInterval.daily:

        final dayDiff = today.difference(lastDate).inDays;
        return dayDiff >= interval;

      case RepeatInterval.weekly:
        final weekDifference = today.difference(lastDate).inDays ~/ 7;
        return weekDifference >= interval;

      case RepeatInterval.monthly:
        final yearDiff = today.year - lastDate.year;
        final monthDiff = today.month - lastDate.month + (yearDiff * 12);
        return monthDiff >= interval &&
            (today.day >= lastDate.day || _isEndOfMonth(today, lastDate));

      default:
        return false;
    }
  }

  bool _isEndOfMonth(DateTime current, DateTime original) {
    final nextMonth = DateTime(original.year, original.month + 1, 1);
    final lastDayOfOriginalMonth = nextMonth.subtract(const Duration(days: 1)).day;
    return original.day == lastDayOfOriginalMonth;
  }

  Future<void> penalizeMissedDailyTasks(String uid) async {
    try {
      final dailyTasks = await getTasksByType(
        uid: uid,
        type: TaskType.daily,
        isCompleted: false,
      );

      final now = DateTime.now();
      final List<Task> tasksToProcessAfterBatch = [];

      for (final task in dailyTasks) {
        if (task.lastCompletedDate == null) continue;

        if (shouldResetTask(task, now)) {
          tasksToProcessAfterBatch.add(task);
        }
      }

      for (final task in tasksToProcessAfterBatch) {
        await completeTask(task, isPenalty: true);
      }
    } catch (e) {
      throw Exception('Error penalizing missed daily tasks: ${e.toString()}');
    }
  }

  Future<void> penalizeOverdueTodoTasks(String uid) async {
    try {
      final todoTasks = await getTasksByType(
        uid: uid,
        type: TaskType.todo,
        isCompleted: false,
      );

      final now = DateTime.now();
      final List<Task> tasksToProcessAfterBatch = [];

      for (final task in todoTasks) {
        if (task.dueDate == null) continue;

        if (now.isAfter(task.dueDate!) &&
            (task.lastCompletedDate == null ||
                task.lastCompletedDate!.year != now.year ||
                task.lastCompletedDate!.month != now.month ||
                task.lastCompletedDate!.day != now.day)) {
          tasksToProcessAfterBatch.add(task);
        }
      }

      for (final task in tasksToProcessAfterBatch) {
        await completeTask(task, isPenalty: true);
      }
    } catch (e) {
      throw Exception('Error penalizing overdue todo tasks: ${e.toString()}');
    }
  }

  Future<List<Task>> getTasksByType({
    required String uid,
    required TaskType type,
    bool? isCompleted,
  }) async {
    final typeString = type.toString().split('.').last;

    Query query = _firestore
        .collection('tasks')
        .where('uid', isEqualTo: uid)
        .where('type', isEqualTo: typeString);

    if (isCompleted != null) {
      query = query.where('isCompleted', isEqualTo: isCompleted);
    }

    final snapshot = await query.get();

    List<Task> tasks =
        snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();

    return tasks;
  }
}
