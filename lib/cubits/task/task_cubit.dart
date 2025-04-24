import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';
import '../../utils/app_enums.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskService _taskService;
  final Map<TaskType, StreamSubscription<List<Task>>?> _subscriptions = {};
  final Map<TaskType, List<Task>> _taskCollections = {
    TaskType.habit: [],
    TaskType.daily: [],
    TaskType.todo: [],
    TaskType.reward: [],
  };

  TaskCubit({required TaskService taskService})
      : _taskService = taskService,
        super(TaskState.initial());

  List<Task> get allTasks => [...state.habits, ...state.dailies, ...state.todos, ...state.rewards];

  List<Task> getTasksByType(TaskType type) {
    switch (type) {
      case TaskType.habit:
        return state.habits;
      case TaskType.daily:
        return state.dailies;
      case TaskType.todo:
        return state.todos;
      case TaskType.reward:
        return state.rewards;
    }
  }

  void loadTasks(String uid) {
    try {
      emit(TaskState.loading());

      _cancelSubscriptions();

      for (var type in TaskType.values) {
        _subscriptions[type] = _taskService
            .streamTasksByType(uid, type)
            .listen((tasks) {
          _taskCollections[type]!.clear();
          _taskCollections[type]!.addAll(tasks);
          _emitUpdatedState();
        });
      }
    } catch (e) {
      emit(TaskState.error(e.toString()));
    }
  }

  void _emitUpdatedState(
      ) {
    emit(TaskState.loaded(
      habits: List.unmodifiable(_taskCollections[TaskType.habit]!),
      dailies: List.unmodifiable(_taskCollections[TaskType.daily]!),
      todos: List.unmodifiable(_taskCollections[TaskType.todo]!),
      rewards: List.unmodifiable(_taskCollections[TaskType.reward]!),
    ));
  }

  Future<void> _executeServiceCall(Future<void> Function() serviceCall) async {
    try {
      await serviceCall();
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic error) {
    emit(TaskState.error(error.toString()));
  }

  Future<void> createTask(Task task) async {
    await _executeServiceCall(() => _taskService.createTask(task));
  }

  Future<void> updateTask(Task task) async {
    await _executeServiceCall(() => _taskService.updateTask(task));
  }

  Future<void> deleteTask(Task task) async {
    await _executeServiceCall(() => _taskService.deleteTask(task));
  }

  Future<void> completeTask(Task task) async {
    await _executeServiceCall(() => _taskService.completeTask(task));
  }

  Future<void> resetDailyTasks(String uid) async {
    await _executeServiceCall(() => _taskService.resetDailyTasks(uid));
  }

  void _cancelSubscriptions() {
    for (var subscription in _subscriptions.values) {
      subscription?.cancel();
    }
    _subscriptions.clear();
  }

  @override
  Future<void> close() {
    _cancelSubscriptions();
    return super.close();
  }
}