import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../utils/app_enums.dart';

class Task extends Equatable {
  final String taskId;
  final String uid;
  final TaskType type;
  final String title;
  final List<String> categoryIds;
  final Difficulty? difficulty;
  final bool? isPositive;
  final bool? isCompleted;
  final RepeatInterval? repeat;
  final int? interval;
  final DateTime? dueDate;
  final int? cost;
  final DateTime? lastCompletedDate;

  const Task({
    required this.taskId,
    required this.uid,
    required this.type,
    required this.title,
    this.categoryIds = const [],
    this.difficulty,
    this.isPositive,
    this.isCompleted = false,
    this.repeat,
    this.interval,
    this.dueDate,
    this.cost,
    this.lastCompletedDate,
  });

  factory Task.habit({
    required String taskId,
    required String uid,
    required String title,
    List<String> categoryIds = const [],
    required Difficulty difficulty,
    required bool isPositive,
  }) {
    return Task(
      taskId: taskId,
      uid: uid,
      type: TaskType.habit,
      title: title,
      categoryIds: categoryIds,
      difficulty: difficulty,
      isPositive: isPositive,
    );
  }

  factory Task.daily({
    required String taskId,
    required String uid,
    required String title,
    List<String> categoryIds = const [],
    required Difficulty difficulty,
    bool isCompleted = false,
    required RepeatInterval repeat,
    required int interval,
    required DateTime lastCompletedDate,
  }) {
    return Task(
      taskId: taskId,
      uid: uid,
      type: TaskType.daily,
      title: title,
      categoryIds: categoryIds,
      difficulty: difficulty,
      isCompleted: isCompleted,
      repeat: repeat,
      interval: interval,
      lastCompletedDate: lastCompletedDate,
    );
  }

  factory Task.todo({
    required String taskId,
    required String uid,
    required String title,
    List<String> categoryIds = const [],
    required Difficulty difficulty,
    bool isCompleted = false,
    required DateTime dueDate,
  }) {
    return Task(
      taskId: taskId,
      uid: uid,
      type: TaskType.todo,
      title: title,
      categoryIds: categoryIds,
      difficulty: difficulty,
      isCompleted: isCompleted,
      dueDate: dueDate,
    );
  }

  factory Task.reward({
    required String taskId,
    required String uid,
    required String title,
    List<String> categoryIds = const [],
    required int cost,
  }) {
    return Task(
      taskId: taskId,
      uid: uid,
      type: TaskType.reward,
      title: title,
      categoryIds: categoryIds,
      cost: cost,
    );
  }

  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final taskType = _taskTypeFromString(data['type'] ?? 'todo');

    Task task = Task(
      taskId: doc.id,
      uid: data['uid'] ?? '',
      type: taskType,
      title: data['title'] ?? '',
      categoryIds: List<String>.from(data['categoryIds'] ?? []),
    );

    switch (taskType) {
      case TaskType.habit:
        return task.copyWith(
          difficulty: data['difficulty'] != null ?
          _difficultyFromString(data['difficulty']) : null,
          isPositive: data['isPositive'],
        );

      case TaskType.daily:
        return task.copyWith(
          difficulty: data['difficulty'] != null ?
          _difficultyFromString(data['difficulty']) : null,
          repeat: data['repeat'] != null ?
          _repeatIntervalFromString(data['repeat']) : null,
          interval: data['interval'],
          lastCompletedDate: data['lastCompletedDate'] != null
              ? (data['lastCompletedDate'] as Timestamp).toDate()
              : null,
          isCompleted: data['isCompleted'] ?? false,
        );

      case TaskType.todo:
        return task.copyWith(
          difficulty: data['difficulty'] != null ?
          _difficultyFromString(data['difficulty']) : null,
          dueDate: data['dueDate'] != null
              ? (data['dueDate'] as Timestamp).toDate()
              : null,
          isCompleted: data['isCompleted'] ?? false,
        );

      case TaskType.reward:
        return task.copyWith(
          cost: data['cost'],
        );
    }

  }

  static TaskType _taskTypeFromString(String type) {
    switch (type.toLowerCase()) {
      case 'habit':
        return TaskType.habit;
      case 'daily':
        return TaskType.daily;
      case 'todo':
        return TaskType.todo;
      case 'reward':
        return TaskType.reward;
      default:
        return TaskType.todo;
    }
  }

  static Difficulty _difficultyFromString(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Difficulty.easy;
      case 'medium':
        return Difficulty.medium;
      case 'hard':
        return Difficulty.hard;
      default:
        return Difficulty.medium;
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
        return RepeatInterval.weekly;
    }
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'uid': uid,
      'type': type.toString().split('.').last,
      'title': title,
      'categoryIds': categoryIds,
    };

    if (difficulty != null) {
      map['difficulty'] = difficulty.toString().split('.').last;
    }
    if (isPositive != null) {
      map['isPositive'] = isPositive;
    }
    if (isCompleted != null) {
      map['isCompleted'] = isCompleted;
    }
    if (repeat != null) {
      map['repeat'] = repeat.toString().split('.').last;
    }
    if (interval != null) {
      map['interval'] = interval;
    }
    if (dueDate != null) {
      map['dueDate'] = Timestamp.fromDate(dueDate!);
    }
    if (cost != null) {
      map['cost'] = cost;
    }
    if (lastCompletedDate != null) {
      map['lastCompletedDate'] = lastCompletedDate;
    }
    return map;
  }

  Task copyWith({
    String? taskId,
    String? uid,
    TaskType? type,
    String? title,
    List<String>? categoryIds,
    Difficulty? difficulty,
    bool? isPositive,
    bool? isCompleted,
    RepeatInterval? repeat,
    int? interval,
    DateTime? dueDate,
    int? cost,
    DateTime? lastCompletedDate,
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
      repeat: repeat ?? this.repeat,
      interval: interval ?? this.interval,
      dueDate: dueDate ?? this.dueDate,
      cost: cost ?? this.cost,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }

  @override
  List<Object?> get props => [
    taskId, uid, type, title, categoryIds,
    difficulty, isPositive, isCompleted,
    repeat, interval, dueDate, cost, lastCompletedDate,
  ];
}