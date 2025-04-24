part of 'task_cubit.dart';

enum TaskStatus { initial, loading, loaded, error }

class TaskState extends Equatable {
  final TaskStatus status;
  final List<Task> habits;
  final List<Task> dailies;
  final List<Task> todos;
  final List<Task> rewards;
  final String? errorMessage;

  const TaskState({
    this.status = TaskStatus.initial,
    this.habits = const [],
    this.dailies = const [],
    this.todos = const [],
    this.rewards = const [],
    this.errorMessage,
  });

  factory TaskState.initial() => TaskState();

  factory TaskState.loading() => TaskState(status: TaskStatus.loading);

  factory TaskState.loaded({
    required List<Task> habits,
    required List<Task> dailies,
    required List<Task> todos,
    required List<Task> rewards,
  }) => TaskState(
    status: TaskStatus.loaded,
    habits: habits,
    dailies: dailies,
    todos: todos,
    rewards: rewards,
  );

  factory TaskState.error(String message) => TaskState(
    status: TaskStatus.error,
    errorMessage: message,
  );

  TaskState copyWith({
    TaskStatus? status,
    List<Task>? habits,
    List<Task>? dailies,
    List<Task>? todos,
    List<Task>? rewards,
    String? errorMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      habits: habits ?? this.habits,
      dailies: dailies ?? this.dailies,
      todos: todos ?? this.todos,
      rewards: rewards ?? this.rewards,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, habits, dailies, todos, rewards, errorMessage];
}