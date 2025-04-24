// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddTaskScreen]
class AddTaskRoute extends PageRouteInfo<AddTaskRouteArgs> {
  AddTaskRoute({
    Key? key,
    required TaskType taskType,
    List<PageRouteInfo>? children,
  }) : super(
         AddTaskRoute.name,
         args: AddTaskRouteArgs(key: key, taskType: taskType),
         initialChildren: children,
       );

  static const String name = 'AddTaskRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddTaskRouteArgs>();
      return AddTaskScreen(key: args.key, taskType: args.taskType);
    },
  );
}

class AddTaskRouteArgs {
  const AddTaskRouteArgs({this.key, required this.taskType});

  final Key? key;

  final TaskType taskType;

  @override
  String toString() {
    return 'AddTaskRouteArgs{key: $key, taskType: $taskType}';
  }
}

/// generated route for
/// [CompleteSignUpScreen]
class CompleteSignUpRoute extends PageRouteInfo<void> {
  const CompleteSignUpRoute({List<PageRouteInfo>? children})
    : super(CompleteSignUpRoute.name, initialChildren: children);

  static const String name = 'CompleteSignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CompleteSignUpScreen();
    },
  );
}

/// generated route for
/// [EditTaskScreen]
class EditTaskRoute extends PageRouteInfo<EditTaskRouteArgs> {
  EditTaskRoute({Key? key, required Task task, List<PageRouteInfo>? children})
    : super(
        EditTaskRoute.name,
        args: EditTaskRouteArgs(key: key, task: task),
        initialChildren: children,
      );

  static const String name = 'EditTaskRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditTaskRouteArgs>();
      return EditTaskScreen(key: args.key, task: args.task);
    },
  );
}

class EditTaskRouteArgs {
  const EditTaskRouteArgs({this.key, required this.task});

  final Key? key;

  final Task task;

  @override
  String toString() {
    return 'EditTaskRouteArgs{key: $key, task: $task}';
  }
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [SignInScreen]
class SignInRoute extends PageRouteInfo<void> {
  const SignInRoute({List<PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignInScreen();
    },
  );
}

/// generated route for
/// [SignUpScreen]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignUpScreen();
    },
  );
}
