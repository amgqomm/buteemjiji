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
        theme: ThemeData.dark().copyWith(
          primaryColor: AppTheme.primaryBlue,
          scaffoldBackgroundColor: AppTheme.darkBackground,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppTheme.darkBackground,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          cardTheme: CardTheme(
            elevation: 0,
            color: AppTheme.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryBlue,
            ),
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppTheme.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderBlue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderBlue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            labelStyle: const TextStyle(color: AppTheme.textSecondary),
          ),
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            fillColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.primaryBlue;
              }
              return AppTheme.disabledGrey;
            }),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppTheme.primaryBlue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(color: Colors.white),
            displayMedium: TextStyle(color: Colors.white),
            displaySmall: TextStyle(color: Colors.white),
            headlineMedium: TextStyle(color: Colors.white),
            headlineSmall: TextStyle(color: Colors.white),
            titleLarge: TextStyle(color: Colors.white),
            titleMedium: TextStyle(color: Colors.white),
            titleSmall: TextStyle(color: Colors.white),
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            bodySmall: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        routerConfig: _appRouter.config(),
      ),
    );
  }
}