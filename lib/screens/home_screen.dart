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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    final authState = context.read<AuthCubit>().state;
    if (authState.user != null) {
      final uid = authState.user!.uid;
      context.read<UserCubit>().loadUser(uid);
      context.read<TaskCubit>().loadTasks(uid);
      context.read<TaskCubit>().resetDailyTasks(uid);
    }
  }

  @override
  void dispose() {
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
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            final user = userState.user;

            if (user == null) {
              return const Center(child: CircularProgressIndicator());
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
          unselectedItemColor: Colors.white.withOpacity(0.7), // Fixed from withValues to withOpacity
          currentIndex: _tabController.index,
          onTap: (index) {
            if (index < 5) {
              setState(() {
                _tabController.index = index;
              });
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.sync), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label: '',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddTaskDialog(_getTaskTypeForTabIndex(_tabController.index));
          },
          backgroundColor: AppTheme.positiveGreen,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_tabController.index) {
      case 0:
        return 'Зуршил';
      case 1:
        return 'Даалгавар';
      case 2:
        return 'Зорилго';
      case 3:
        return 'Урамшуулал';
      case 4:
        return 'Профайл';
      default:
        return '';
    }
  }

  TaskType _getTaskTypeForTabIndex(int index) {
    switch (index) {
      case 0:
        return TaskType.habit;
      case 1:
        return TaskType.daily;
      case 2:
        return TaskType.todo;
      case 3:
        return TaskType.reward;
      default:
        return TaskType.habit;
    }
  }

  void _showAddTaskDialog(TaskType taskType) {
    context.router.push(AddTaskRoute(taskType: taskType));
  }
}

// @RoutePage()
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//
//     // Хэрэглэгч болон түүнд хамаарах даалгавруудыг баазаас татан бэлдэх
//     final authState = context.read<AuthCubit>().state;
//     if (authState.user != null) {
//       final uid = authState.user!.uid;
//       context.read<UserCubit>().loadUser(uid);
//       context.read<TaskCubit>().loadTasks(uid);
//
//       // Өдөр солигдоход биелэгдсэн даалгаврын төлөвийг солих
//       context.read<TaskCubit>().resetDailyTasks(uid);
//     }
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthCubit, AuthState>(
//       listener: (context, state) {
//         if (state.status == AuthStatus.unauthenticated) {
//           context.router.replace(const SignInRoute());
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title:
//               _tabController.index == 3
//                   ? const Text('Урамшуулал')
//                   : _tabController.index == 2
//                   ? const Text('Зорилго')
//                   : _tabController.index == 1
//                   ? const Text('Даалгавар')
//                   : _tabController.index == 0
//                   ? const Text('Зуршил')
//                   : const Text('Профайл'),
//           centerTitle: true,
//           elevation: 0,
//         ),
//         body: BlocBuilder<UserCubit, UserState>(
//           builder: (context, userState) {
//             final user = userState.user;
//
//             if (user == null) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             return Column(
//               children: [
//                 // Stats bar
//                 // Container(
//                 //   padding: const EdgeInsets.symmetric(
//                 //     vertical: 16.0,
//                 //     horizontal: 16.0,
//                 //   ),
//                 //   decoration: BoxDecoration(color: AppTheme.darkBackground),
//                 //   child:
//                 //       user != null
//                 //           ? Column(
//                 //             children: [
//                 //               Row(
//                 //                 children: [
//                 //                   CircleAvatar(
//                 //                     radius: 30,
//                 //                     backgroundColor: AppTheme.cardBackground,
//                 //                     child: CircleAvatar(
//                 //                       radius: 28,
//                 //                       backgroundColor: Colors.transparent,
//                 //                       // child: Center(
//                 //                       //   child: Text(
//                 //                       //     // todo Зураг оруулах
//                 //                       //     'O',
//                 //                       //     style: TextStyle(
//                 //                       //       fontSize: 24,
//                 //                       //       fontWeight: FontWeight.bold,
//                 //                       //       color: AppTheme.accentPurple,
//                 //                       //     ),
//                 //                       //   ),
//                 //                       // ),
//                 //                     ),
//                 //                   ),
//                 //                   const Spacer(),
//                 //                   // Username
//                 //                   Text(
//                 //                     user.username,
//                 //                     style: const TextStyle(
//                 //                       fontSize: 20,
//                 //                       fontWeight: FontWeight.bold,
//                 //                       color: Colors.white,
//                 //                     ),
//                 //                   ),
//                 //                   const Spacer(),
//                 //                 ],
//                 //               ),
//                 //               const SizedBox(height: 8),
//                 //
//                 //               // Амь
//                 //               Row(
//                 //                 children: [
//                 //                   Icon(
//                 //                     Icons.favorite,
//                 //                     color: AppTheme.healthRed,
//                 //                     size: 16,
//                 //                   ),
//                 //                   const SizedBox(width: 4),
//                 //                   Expanded(
//                 //                     child: ClipRRect(
//                 //                       borderRadius: BorderRadius.circular(4),
//                 //                       child: LinearProgressIndicator(
//                 //                         value: user.healthPoint / 100,
//                 //                         backgroundColor:
//                 //                             AppTheme.darkBackground,
//                 //                         valueColor:
//                 //                             AlwaysStoppedAnimation<Color>(
//                 //                               AppTheme.healthRed,
//                 //                             ),
//                 //                         minHeight: 10,
//                 //                       ),
//                 //                     ),
//                 //                   ),
//                 //                   const SizedBox(width: 4),
//                 //                   Text(
//                 //                     '${user.healthPoint}/100',
//                 //                     style: TextStyle(
//                 //                       color: AppTheme.textSecondary,
//                 //                       fontSize: 12,
//                 //                     ),
//                 //                   ),
//                 //                   const SizedBox(width: 8),
//                 //                   Text(
//                 //                     'Амь',
//                 //                     style: TextStyle(
//                 //                       color: AppTheme.textSecondary,
//                 //                       fontSize: 12,
//                 //                     ),
//                 //                   ),
//                 //                 ],
//                 //               ),
//                 //
//                 //               const SizedBox(height: 4),
//                 //
//                 //               // Туршлага
//                 //               Row(
//                 //                 children: [
//                 //                   Icon(
//                 //                     Icons.star,
//                 //                     color: AppTheme.expAmber,
//                 //                     size: 16,
//                 //                   ),
//                 //                   const SizedBox(width: 4),
//                 //                   Expanded(
//                 //                     child: ClipRRect(
//                 //                       borderRadius: BorderRadius.circular(4),
//                 //                       child: LinearProgressIndicator(
//                 //                         value:
//                 //                             user.expPoint / (user.level * 100),
//                 //                         backgroundColor:
//                 //                             AppTheme.darkBackground,
//                 //                         valueColor:
//                 //                             AlwaysStoppedAnimation<Color>(
//                 //                               AppTheme.expAmber,
//                 //                             ),
//                 //                         minHeight: 10,
//                 //                       ),
//                 //                     ),
//                 //                   ),
//                 //                   const SizedBox(width: 4),
//                 //                   Text(
//                 //                     '${user.expPoint}/100',
//                 //                     style: TextStyle(
//                 //                       color: AppTheme.textSecondary,
//                 //                       fontSize: 12,
//                 //                     ),
//                 //                   ),
//                 //                   const SizedBox(width: 8),
//                 //                   Text(
//                 //                     'Туршлага',
//                 //                     style: TextStyle(
//                 //                       color: AppTheme.textSecondary,
//                 //                       fontSize: 12,
//                 //                     ),
//                 //                   ),
//                 //                 ],
//                 //               ),
//                 //
//                 //               const SizedBox(height: 4),
//                 //
//                 //               // Түвшин болон зоос
//                 //               Row(
//                 //                 children: [
//                 //                   Text(
//                 //                     '${user.level}-р түвшин',
//                 //                     style: const TextStyle(
//                 //                       fontSize: 14,
//                 //                       color: Colors.white,
//                 //                     ),
//                 //                   ),
//                 //                   const Spacer(),
//                 //                   Icon(
//                 //                     Icons.monetization_on,
//                 //                     color: AppTheme.coinOrange,
//                 //                     size: 16,
//                 //                   ),
//                 //                   const SizedBox(width: 4),
//                 //                   Text(
//                 //                     '${user.coin}',
//                 //                     style: const TextStyle(
//                 //                       fontSize: 14,
//                 //                       fontWeight: FontWeight.bold,
//                 //                       color: Colors.white,
//                 //                     ),
//                 //                   ),
//                 //                 ],
//                 //               ),
//                 //             ],
//                 //           )
//                 //           : const Center(child: CircularProgressIndicator()),
//                 // ),
//                 UserStatsCard(user: user),
//                 // Tasks tabs
//                 Expanded(
//                   child: TabBarView(
//                     controller:
//                         _tabController,
//                     children: [
//                       // Habits tab
//                       _buildTaskList(TaskType.habit),
//
//                       // Dailies tab
//                       _buildTaskList(TaskType.daily),
//
//                       // To-Dos tab
//                       _buildTaskList(TaskType.todo),
//
//                       // Rewards tab
//                       _buildTaskList(TaskType.reward),
//
//                       // Profile tab
//                       _buildProfileTab(),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: AppTheme.primaryBlue,
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.white.withValues(alpha: 0.7),
//           currentIndex: _tabController.index,
//           onTap: (index) {
//             if (index < 5) {
//               setState(() {
//                 _tabController.index = index;
//               });
//             }
//           },
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.sync), label: ''),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.calendar_today),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.check_circle_outline),
//               label: '',
//             ),
//             BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: ''),
//             BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             _showAddTaskDialog(context, _tabController.index);
//           },
//           backgroundColor: AppTheme.positiveGreen,
//           child: const Icon(Icons.add, color: Colors.white),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTaskList(TaskType type) {
//     return BlocBuilder<TaskCubit, TaskState>(
//       builder: (context, state) {
//         if (state.status == TaskStatus.loading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (state.status == TaskStatus.error) {
//           return Center(
//             child: Text(
//               'Error: ${state.errorMessage}',
//               style: const TextStyle(color: Colors.red),
//             ),
//           );
//         }
//
//         final tasks = state.getTasksByType(type);
//
//         if (tasks.isEmpty) {
//           return EmptyTaskState(
//             taskType: type,
//             onAddPressed:
//                 () => _showAddTaskDialog(context, _getTabIndexForType(type)),
//           );
//         }
//
//         return ListView.builder(
//           itemCount: tasks.length,
//           itemBuilder: (context, index) {
//             final task = tasks[index];
//             return _buildTaskItem(task);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildProfileTab() {
//     return BlocBuilder<UserCubit, UserState>(
//       builder: (context, userState) {
//         final user = userState.user;
//
//         if (user == null) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 // User stats - you could use your UserStatsCard here for consistency
//                 // UserStatsCard(user: user),
//
//                 // Personal Information section
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Хувийн мэдээлэл', // Personal Information in Mongolian
//                         style: TextStyle(
//                           color: AppTheme.textSecondary,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: AppTheme.cardBackground,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 // Edit username functionality
//                               },
//                               child: _buildProfileItem(
//                                 label: 'Нэр',
//                                 value: user.username,
//                               ),
//                             ),
//                             const Divider(
//                               height: 1,
//                               color: AppTheme.darkBackground,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 // Edit email functionality
//                               },
//                               child: _buildProfileItem(
//                                 label: 'Имэйл',
//                                 value: user.email,
//                               ),
//                             ),
//                             const Divider(
//                               height: 1,
//                               color: AppTheme.darkBackground,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 // Edit password functionality
//                               },
//                               child: _buildProfileItem(
//                                 label: 'Нууц үг',
//                                 value: '********',
//                                 isPassword: true,
//                               ),
//                             ),
//                             const Divider(
//                               height: 1,
//                               color: AppTheme.darkBackground,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 // Edit gender functionality
//                               },
//                               child: _buildProfileItem(
//                                 label: 'Хүйс',
//                                 value: _getGenderText(user.gender),
//                               ),
//                             ),
//                             const Divider(
//                               height: 1,
//                               color: AppTheme.darkBackground,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 // Edit age functionality
//                               },
//                               child: _buildProfileItem(
//                                 label: 'Нас',
//                                 value: '${user.age}',
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Sign Out Button
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: TextButton(
//                     onPressed: () {
//                       context.read<AuthCubit>().signOut();
//                     },
//                     style: TextButton.styleFrom(
//                       foregroundColor: AppTheme.primaryBlue,
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Гарах', // Sign out in Mongolian
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//       },
//     );
//   }
//
// // Helper method to build profile items
//   Widget _buildProfileItem({
//     required String label,
//     required String value,
//     bool isPassword = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(color: Colors.white)),
//           Text(
//             value,
//             style: TextStyle(
//               color: isPassword ? AppTheme.textSecondary : Colors.white,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// // Helper method to get gender text
//   String _getGenderText(Gender gender) {
//     switch (gender) {
//       case Gender.male:
//         return 'Эр';
//       case Gender.female:
//         return 'Эм';
//       default:
//         return 'Бусад';
//     }
//   }
//
//   Widget _buildTaskItem(Task task) {
//     switch (task.type) {
//       case TaskType.habit:
//         return _buildHabitItem(task);
//       case TaskType.daily:
//         return _buildDailyItem(task);
//       case TaskType.todo:
//         return _buildTodoItem(task);
//       case TaskType.reward:
//         return _buildRewardItem(task);
//     }
//   }
//
//   Widget _buildHabitItem(Task task) {
//     final isPositive = task.isPositive ?? true;
//
//     return GestureDetector(
//       onTap: () {
//         context.router.push(EditTaskRoute(task: task));
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListTile(
//               leading: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (isPositive)
//                     IconButton(
//                       icon: const Icon(Icons.add, color: Colors.green),
//                       onPressed: () {
//                         context.read<TaskCubit>().completeTask(task);
//                       },
//                     ),
//                   if (!isPositive)
//                     IconButton(
//                       icon: const Icon(Icons.remove, color: Colors.red),
//                       onPressed: () {
//                         context.read<TaskCubit>().completeTask(task);
//                       },
//                     ),
//                 ],
//               ),
//               title: Text(task.title),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDailyItem(Task task) {
//     final isCompleted = task.isCompleted ?? false;
//
//     return GestureDetector(
//       onTap: () {
//         context.router.push(EditTaskRoute(task: task));
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListTile(
//               leading: Checkbox(
//                 value: isCompleted,
//                 onChanged: (bool? value) {
//                   if (value == true && !isCompleted) {
//                     context.read<TaskCubit>().completeTask(task);
//                   }
//                 },
//               ),
//               title: Text(
//                 task.title,
//                 style:
//                     isCompleted
//                         ? const TextStyle(
//                           decoration: TextDecoration.lineThrough,
//                           color: Colors.grey,
//                         )
//                         : null,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTodoItem(Task task) {
//     final isCompleted = task.isCompleted ?? false;
//     final dueDate = task.dueDate;
//     final isPastDue =
//         dueDate != null && dueDate.isBefore(DateTime.now()) && !isCompleted;
//
//     return GestureDetector(
//       onTap: () {
//         context.router.push(EditTaskRoute(task: task));
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//         elevation: isPastDue ? 3 : 1,
//         color: isPastDue ? Colors.red.shade50 : null,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: isPastDue
//               ? BorderSide(color: Colors.red.shade300, width: 1.0)
//               : BorderSide.none,
//         ),
//         child: ListTile(
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           leading: Checkbox(
//             value: isCompleted,
//             activeColor: isPastDue ? Colors.red : null,
//             onChanged: (bool? value) {
//               if (value == true && !isCompleted) {
//                 //final updatedTask = task.copyWith(isCompleted: true);
//
//                 context.read<TaskCubit>().completeTask(task);
//                 Future.delayed(const Duration(milliseconds: 800), () {
//                   // This is where you'd handle the actual deletion
//                   context.read<TaskCubit>().deleteTask(task);
//                 });
//               }
//             },
//           ),
//           title: Text(
//             task.title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: isPastDue && !isCompleted ? FontWeight.bold : null,
//               decoration: isCompleted ? TextDecoration.lineThrough : null,
//               color: isCompleted
//                   ? Colors.grey
//                   : isPastDue ? Colors.red.shade700 : null,
//             ),
//           ),
//           subtitle: dueDate != null
//               ? Padding(
//             padding: const EdgeInsets.only(top: 4.0),
//             child: Row(
//               children: [
//                 if (isPastDue)
//                   Icon(
//                     Icons.warning_rounded,
//                     color: Colors.red.shade700,
//                     size: 16,
//                   ),
//                 if (isPastDue) const SizedBox(width: 4),
//                 Text(
//                   isPastDue
//                       ? 'Past due: ${dueDate.day}/${dueDate.month}/${dueDate.year}'
//                       : 'Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: isPastDue ? Colors.red.shade700 : Colors.grey.shade600,
//                     fontWeight: isPastDue ? FontWeight.bold : null,
//                   ),
//                 ),
//               ],
//             ),
//           )
//               : null,
//           trailing: isPastDue
//               ? Container(
//             width: 4,
//             height: 45,
//             decoration: BoxDecoration(
//               color: Colors.red.shade400,
//               borderRadius: BorderRadius.circular(4),
//             ),
//           )
//               : null,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRewardItem(Task task) {
//     return BlocBuilder<UserCubit, UserState>(
//       builder: (context, userState) {
//         final hasEnoughCoins =
//             userState.user != null &&
//                 userState.user!.coin >= (task.cost ?? 0);
//
//         return GestureDetector(
//           onTap: () {
//             context.router.push(EditTaskRoute(task: task));
//           },
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ListTile(
//                   leading: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       GestureDetector(
//                         onTap: hasEnoughCoins
//                             ? () {
//                           context.read<TaskCubit>().completeTask(task);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text('${task.title} шагналыг амжилттай авлаа!'),
//                               backgroundColor: Colors.green,
//                               duration: const Duration(seconds: 2),
//                             ),
//                           );
//                         }
//                             : () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Худалдан авахад зоос хүрэхгүй байна!'),
//                               duration: Duration(seconds: 1),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           child: const Icon(
//                             Icons.attach_money,
//                             color: Colors.yellow,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   title: Text(task.title),
//                   subtitle: Text('${task.cost ?? 0} зоос'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _showAddTaskDialog(BuildContext context, int tabIndex) {
//     final taskTypes = [
//       TaskType.habit,
//       TaskType.daily,
//       TaskType.todo,
//       TaskType.reward,
//     ];
//     final taskType = taskTypes[tabIndex];
//
//     context.router.push(AddTaskRoute(taskType: taskType));
//   }
//
//   int _getTabIndexForType(TaskType type) {
//     switch (type) {
//       case TaskType.habit:
//         return 0;
//       case TaskType.daily:
//         return 1;
//       case TaskType.todo:
//         return 2;
//       case TaskType.reward:
//         return 3;
//     }
//   }
// }
