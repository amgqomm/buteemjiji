import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'routes/app_router.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';
import 'services/task_service.dart';
import 'cubits/auth/auth_cubit.dart';
import 'cubits/user/user_cubit.dart';
import 'cubits/task/task_cubit.dart';
import 'utils/theme_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();
  final _userService = UserService();
  final _taskService = TaskService();

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authService: _authService),
        ),
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(userService: _userService),
        ),
        BlocProvider<TaskCubit>(
          create: (context) => TaskCubit(taskService: _taskService),
        ),
      ],
      child: MaterialApp.router(
        title: 'Buteemjiji',
        theme: appTheme,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
