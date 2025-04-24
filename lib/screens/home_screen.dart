import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/user/user_cubit.dart';
import '../../cubits/task/task_cubit.dart';
import '../../routes/app_router.dart';
import '../utils/app_enums.dart';
import '../utils/theme_constants.dart';
import '../widgets/user_stats_card.dart';
import '../widgets/task_list.dart';
import '../widgets/profile_section.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    _tabController.addListener(_handleTabChange);

    final authState = context.read<AuthCubit>().state;
    if (authState.user != null) {
      final uid = authState.user!.uid;
      _loadUserDataAndTasks(uid);
    }
  }

  Future<void> _loadUserDataAndTasks(String uid) async {
    final userCubit = context.read<UserCubit>();
    final taskCubit = context.read<TaskCubit>();

    try {
      await userCubit.loadUser(uid);
      await taskCubit.loadTasks(uid);
      await taskCubit.resetDailyTasks(uid);
      await taskCubit.penalizeMissedDailyTasks(uid);
      await taskCubit.penalizeOverdueTodoTasks(uid);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Алдаа гарлаа: ${e.toString()}')));
    }
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          context.router.replace(const SignInRoute());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getAppBarTitle()),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            final user = userState.user;

            if (userState.status == UserStatus.loading || user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (userState.status == UserStatus.error) {
              return Center(
                child: Text(
                  userState.errorMessage ??
                      'Хэрэглэгчийн мэдээллийг татахад алдаа гарлаа!',
                ),
              );
            }

            return Column(
              children: [
                UserStatsCard(user: user),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      TaskList(
                        taskType: TaskType.habit,
                        onAddPressed: _showAddTaskDialog,
                      ),
                      TaskList(
                        taskType: TaskType.daily,
                        onAddPressed: _showAddTaskDialog,
                      ),
                      TaskList(
                        taskType: TaskType.todo,
                        onAddPressed: _showAddTaskDialog,
                      ),
                      TaskList(
                        taskType: TaskType.reward,
                        onAddPressed: _showAddTaskDialog,
                      ),
                      ProfileSection(
                        user: user,
                        onSignOut: () => context.read<AuthCubit>().signOut(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.primaryBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withValues(alpha: 0.7),
          currentIndex: _tabController.index,
          onTap: (index) {
            if (index < 5) {
              _tabController.animateTo(index);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label: '',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: ''),
          ],
        ),
        floatingActionButton:
            _tabController.index == 4
                ? null
                : FloatingActionButton(
                  onPressed: () {
                    _showAddTaskDialog(
                      _getTaskTypeForTabIndex(_tabController.index),
                    );
                  },
                  backgroundColor: AppTheme.positiveGreen,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
      ),
    );
  }

  final _tabTitles = [
    'Зуршил',
    'Даалгавар',
    'Зорилго',
    'Урамшуулал',
    'Профайл'
  ];

  String _getAppBarTitle() {
    return _tabController.index < _tabTitles.length
        ? _tabTitles[_tabController.index]
        : '';
  }

  final _tabTaskTypes = [
    TaskType.habit,
    TaskType.daily,
    TaskType.todo,
    TaskType.reward,
  ];

  TaskType _getTaskTypeForTabIndex(int index) {
    return index < _tabTaskTypes.length
        ? _tabTaskTypes[index]
        : TaskType.habit;
  }

  void _showAddTaskDialog(TaskType taskType) {
    context.router.push(AddTaskRoute(taskType: taskType));
  }
}