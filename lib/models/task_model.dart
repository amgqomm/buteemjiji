import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_enums.dart';

class Task {
  final String taskId;
  final String uid;
  final TaskType type;
  final String title;
  final List<String> categoryIds;
  final TaskDifficulty difficulty;
  final bool isPositive;
  final bool isCompleted;
  final bool isRepeatable;
  final RepeatInterval repeat;
  final int interval;
  final DateTime? dueDate;
  final int cost;

  Task({
    required this.taskId,
    required this.uid,
    required this.type,
    required this.title,
    this.categoryIds = const [],
    this.difficulty = TaskDifficulty.medium,
    this.isPositive = true,
    this.isCompleted = false,
    this.isRepeatable = false,
    this.repeat = RepeatInterval.none,
    this.interval = 1,
    this.dueDate,
    this.cost = 0,
  });

  factory Task.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Task(
      taskId: doc.id,
      uid: data['uid'] ?? '',
      type: _taskTypeFromString(data['type'] ?? 'todo'),
      title: data['title'] ?? 'Untitled Task',
      categoryIds: List<String>.from(data['categories'] ?? []),
      difficulty: _difficultyFromString(data['difficulty'] ?? 'medium'),
      isPositive: data['isPositive'] ?? true,
      isCompleted: data['isCompleted'] ?? false,
      isRepeatable: data['isRepeatable'] ?? false,
      repeat: _repeatIntervalFromString(data['repeat'] ?? 'none'),
      interval: data['interval'] ?? 1,
      dueDate: data['dueDate'] != null ? (data['dueDate'] as Timestamp).toDate() : null,
      cost: data['cost'] ?? 0,
    );
  }

  static TaskType _taskTypeFromString(String type) {
    switch (type.toLowerCase()) {
      case 'habit':
        return TaskType.habit;
      case 'daily':
        return TaskType.daily;
      case 'reward':
        return TaskType.reward;
      default:
        return TaskType.todo;
    }
  }

  static TaskDifficulty _difficultyFromString(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return TaskDifficulty.easy;
      case 'hard':
        return TaskDifficulty.hard;
      default:
        return TaskDifficulty.medium;
    }
  }

  static RepeatInterval _repeatIntervalFromString(String repeat) {
    switch (repeat.toLowerCase()) {
      case 'daily':
        return RepeatInterval.daily;
      case 'weekly':
        return RepeatInterval.weekly;
      case 'monthly':
        return RepeatInterval.monthly;
      default:
        return RepeatInterval.none;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'type': type.toString().split('.').last,
      'title': title,
      'categories': categoryIds,
      'difficulty': difficulty.toString().split('.').last,
      'isPositive': isPositive,
      'isCompleted': isCompleted,
      'isRepeatable': isRepeatable,
      'repeat': repeat.toString().split('.').last,
      'interval': interval,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'cost': cost,
    };
  }

  Task copyWith({
    String? taskId,
    String? uid,
    TaskType? type,
    String? title,
    List<String>? categoryIds,
    TaskDifficulty? difficulty,
    bool? isPositive,
    bool? isCompleted,
    bool? isRepeatable,
    RepeatInterval? repeat,
    int? interval,
    DateTime? dueDate,
    int? cost,
  }) {
    return Task(
      taskId: taskId ?? this.taskId,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      title: title ?? this.title,
      categoryIds: categoryIds ?? this.categoryIds,
      difficulty: difficulty ?? this.difficulty,
      isPositive: isPositive ?? this.isPositive,
      isCompleted: isCompleted ?? this.isCompleted,
      isRepeatable: isRepeatable ?? this.isRepeatable,
      repeat: repeat ?? this.repeat,
      interval: interval ?? this.interval,
      dueDate: dueDate ?? this.dueDate,
      cost: cost ?? this.cost,
    );
  }
}