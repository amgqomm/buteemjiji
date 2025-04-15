import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../cubits/auth/auth_cubit.dart';
//import '../../cubits/auth/auth_state.dart';
import '../../models/user_model.dart';
import '../../routes/app_router.dart';

// @RoutePage()
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _pages = [
//     const TasksTab(),
//     const StatsTab(),
//     const ProfileTab(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthCubit, AuthState>(
//       listener: (context, state) {
//         if (state is Unauthenticated) {
//           context.router.replace(const SignInRoute());
//         }
//       },
//       builder: (context, state) {
//         if (state is! Authenticated) {
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//
//         final user = (state as Authenticated).user;
//
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Productivity Hero'),
//             centerTitle: true,
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.logout),
//                 onPressed: () {
//                   context.read<AuthCubit>().signOut();
//                 },
//               ),
//             ],
//           ),
//           body: _pages[_selectedIndex],
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: _selectedIndex,
//             onTap: (index) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             },
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.task_alt),
//                 label: 'Tasks',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.bar_chart),
//                 label: 'Stats',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 label: 'Profile',
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class TasksTab extends StatelessWidget {
//   const TasksTab({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             'Tasks Tab',
//             style: TextStyle(fontSize: 24),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: () {
//               // TODO: Implement add task functionality
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Add Task button pressed')),
//               );
//             },
//             icon: const Icon(Icons.add),
//             label: const Text('Add Task'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class StatsTab extends StatelessWidget {
//   const StatsTab({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final user = context.select((AuthCubit cubit) =>
//     cubit.state is Authenticated ? (cubit.state as Authenticated).user : null);
//
//     if (user == null) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             'Your Hero Stats',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 30),
//           _buildStatCard(context, user),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatCard(BuildContext context, AppUser user) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       user.username,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text('Level ${user.level}'),
//                   ],
//                 ),
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Theme.of(context).primaryColor,
//                   child: Text(
//                     'Lv ${user.level}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             _buildProgressBar(
//               'Health',
//               user.healthPoint / 100,
//               Colors.red,
//               '${user.healthPoint}/100',
//             ),
//             const SizedBox(height: 10),
//             _buildProgressBar(
//               'Experience',
//               user.expPoint / (user.level * 100),
//               Colors.blue,
//               '${user.expPoint}/${user.level * 100}',
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.monetization_on, color: Colors.amber),
//                 const SizedBox(width: 8),
//                 Text(
//                   '${user.coin} coins',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProgressBar(
//       String label,
//       double value,
//       Color color,
//       String valueText,
//       ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 4),
//         Stack(
//           children: [
//             Container(
//               height: 20,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             Container(
//               height: 20,
//               width: value * 345, // Approximating available width
//               decoration: BoxDecoration(
//                 color: color,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//               width: double.infinity,
//               child: Center(
//                 child: Text(
//                   valueText,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     shadows: [
//                       Shadow(
//                         color: Colors.black,
//                         blurRadius: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class ProfileTab extends StatelessWidget {
//   const ProfileTab({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final user = context.select((AuthCubit cubit) =>
//     cubit.state is Authenticated ? (cubit.state as Authenticated).user : null);
//
//     if (user == null) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Column(
//               children: [
//                 const CircleAvatar(
//                   radius: 50,
//                   child: Icon(Icons.person, size: 50),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   user.username,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Level ${user.level} Hero',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 32),
//           const Text(
//             'Profile Information',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildProfileItem(Icons.email, 'Email', user.email),
//           _buildProfileItem(Icons.person, 'Gender', user.gender),
//           _buildProfileItem(Icons.calendar_today, 'Age', user.age.toString()),
//           const SizedBox(height: 32),
//           const Text(
//             'Game Stats',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildProfileItem(Icons.trending_up, 'Level', user.level.toString()),
//           _buildProfileItem(Icons.favorite, 'Health', '${user.healthPoint}/100'),
//           _buildProfileItem(Icons.stars, 'Experience', user.expPoint.toString()),
//           _buildProfileItem(Icons.monetization_on, 'Coins', user.coin.toString()),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfileItem(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.grey),
//           const SizedBox(width: 16),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const Spacer(),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HabitsTab(),
    const DailiesTab(),
    const TodosTab(),
    const RewardsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          AutoRouter.of(context).replace(const SignInRoute());
        }
      },
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Productivity App'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () {
                    context.read<AuthCubit>().signOut();
                  },
                ),
              ],
            ),
            drawer: _buildDrawer(user),
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.repeat),
                  label: 'Habits',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Dailies',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_box),
                  label: 'To-Dos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_giftcard),
                  label: 'Rewards',
                ),
              ],
            ),
          );
        }

        // Show loading indicator if not authenticated yet
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildDrawer(AppUser user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.username),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 40.0),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Navigate to profile page
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Navigate to settings page
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite),
                const SizedBox(width: 4),
                Text('${user.healthPoint}'),
              ],
            ),
            title: const Text('Health'),
          ),
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star),
                const SizedBox(width: 4),
                Text('${user.expPoint}'),
              ],
            ),
            title: const Text('Experience'),
          ),
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.monetization_on),
                const SizedBox(width: 4),
                Text('${user.coin}'),
              ],
            ),
            title: const Text('Coins'),
          ),
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.military_tech),
                const SizedBox(width: 4),
                Text('${user.level}'),
              ],
            ),
            title: const Text('Level'),
          ),
        ],
      ),
    );
  }
}

// Tab pages
class HabitsTab extends StatelessWidget {
  const HabitsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Habits',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Add habit logic
            },
            child: const Text('Add New Habit'),
          ),
        ],
      ),
    );
  }
}

class DailiesTab extends StatelessWidget {
  const DailiesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Dailies',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Add daily logic
            },
            child: const Text('Add New Daily'),
          ),
        ],
      ),
    );
  }
}

class TodosTab extends StatelessWidget {
  const TodosTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'To-Dos',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Add todo logic
            },
            child: const Text('Add New To-Do'),
          ),
        ],
      ),
    );
  }
}

class RewardsTab extends StatelessWidget {
  const RewardsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Rewards',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Add reward logic
            },
            child: const Text('Add New Reward'),
          ),
        ],
      ),
    );
  }
}