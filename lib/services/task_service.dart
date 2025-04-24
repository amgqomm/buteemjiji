import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import '../utils/app_enums.dart';
import 'user_service.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  // Stream<List<Task>> streamTasks(String uid) {
  //   return _firestore
  //       .collection('tasks')
  //       .where('uid', isEqualTo: uid)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //       .map((doc) => Task.fromFirestore(doc))
  //       .toList());
  // }

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
          await updateTask(
            task.copyWith(dueDate: DateTime.now().add(const Duration(days: 1))),
          );
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
          //await getTasksByType(uid: uid, type: TaskType.daily, isCompleted: true);
          await _firestore
              .collection('tasks')
              .where('uid', isEqualTo: uid)
              .where('type', isEqualTo: 'daily')
              .where('isCompleted', isEqualTo: true)
              .get();

      final batch = _firestore.batch();
      final now = DateTime.now();

      for (final doc in dailyTasks.docs) {
        final task = Task.fromFirestore(doc);

        if (shouldResetTask(task, now)) {
          batch.update(doc.reference, {'isCompleted': false});
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

    switch (task.repeat) {
      case RepeatInterval.daily:
        final daysSinceCompletion = now.difference(lastCompletedDate).inDays;
        return daysSinceCompletion >= interval;

      case RepeatInterval.weekly:
        final weeksSinceCompletion =
            now.difference(lastCompletedDate).inDays / 7;
        return weeksSinceCompletion.floor() >= interval;

      case RepeatInterval.monthly:
        DateTime targetDate = DateTime(
          lastCompletedDate.year,
          lastCompletedDate.month + interval,
          lastCompletedDate.day,
        );
        while (targetDate.month > (lastCompletedDate.month + interval) % 12) {
          targetDate = targetDate.subtract(const Duration(days: 1));
        }
        return now.isAfter(targetDate) || now.isAtSameMomentAs(targetDate);

      default:
        return false;
    }
  }

  Future<void> penalizeMissedDailyTasks(String uid) async {
    try {
      final dailyTasks = await getTasksByType(
        uid: uid,
        type: TaskType.daily,
        isCompleted: false,
      );

      final now = DateTime.now();
      //final batch = _firestore.batch();

      // for (final doc in dailyTasks.docs) {
      //   final task = Task.fromFirestore(doc);
      for (final task in dailyTasks) {
        if (task.lastCompletedDate == null) continue;

        if (shouldResetTask(task, now)) {
          await completeTask(task, isPenalty: true);
        }
      }

      //await batch.commit();
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

      // for (final doc in todoTasks.docs) {
      //   final task = Task.fromFirestore(doc);
      for (final task in todoTasks) {
        if (task.dueDate == null) continue;

        if (now.isAfter(task.dueDate!)) {
          // Apply penalty
          await completeTask(task, isPenalty: true);
        }
      }
    } catch (e) {
      throw Exception('Error penalizing overdue todo tasks: ${e.toString()}');
    }
  }

  // Future<QuerySnapshot> getUncompletedTasksByType(String uid, TaskType type) {
  //   final typeString = type.toString().split('.').last;
  //   return _firestore
  //       .collection('tasks')
  //       .where('uid', isEqualTo: uid)
  //       .where('type', isEqualTo: typeString)
  //       .where('isCompleted', isEqualTo: false)
  //       .get();
  // }

  Future<List<Task>> getTasksByType({
    required String uid,
    required TaskType type,
    bool? isCompleted,
  }) async {
    final typeString = type.toString().split('.').last;

    // Start with basic query
    Query query = _firestore
        .collection('tasks')
        .where('uid', isEqualTo: uid)
        .where('type', isEqualTo: typeString);

    // Add additional filters when specified
    if (isCompleted != null) {
      query = query.where('isCompleted', isEqualTo: isCompleted);
    }

    // Execute the query
    final snapshot = await query.get();

    // Convert to Task objects
    List<Task> tasks =
        snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();

    return tasks;
  }
}
