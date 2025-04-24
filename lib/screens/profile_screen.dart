// import 'package:buteemjiji/extensions/gender_extensions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:auto_route/auto_route.dart';
// import '../cubits/auth/auth_cubit.dart';
// //import '../cubits/auth/auth_state.dart';
// import '../cubits/user/user_cubit.dart';
// //import '../cubits/user/user_state.dart';
// import '../models/user_model.dart';
// import '../routes/app_router.dart';
// import '../utils/app_enums.dart';
// import '../utils/theme_constants.dart';
//
// @RoutePage()
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key}); // todo super key
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
//           title: const Text('Профайл'),
//           centerTitle: true,
//           elevation: 0,
//           automaticallyImplyLeading: false,
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
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 16.0,
//                     horizontal: 16.0,
//                   ),
//                   decoration: BoxDecoration(color: AppTheme.darkBackground),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundColor: AppTheme.cardBackground,
//                       //   child: user.gender == Gender.male
//                       // ?   Image.asset(
//                       //     'assets/images/male.png',
//                       //     width: 76,
//                       //     height: 76,
//                       //     fit: BoxFit.cover,
//                       //   )
//                       ),
//                       const SizedBox(height: 8),
//
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.favorite,
//                             color: AppTheme.healthRed,
//                             size: 16,
//                           ),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4),
//                               child: LinearProgressIndicator(
//                                 value: user.healthPoint / 100,
//                                 backgroundColor: AppTheme.darkBackground,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   AppTheme.healthRed,
//                                 ),
//                                 minHeight: 10,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${user.healthPoint}/100',
//                             style: TextStyle(
//                               color: AppTheme.textSecondary,
//                               fontSize: 12,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             'Амь', // Health in Mongolian
//                             style: TextStyle(
//                               color: AppTheme.textSecondary,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 4),
//
//                       Row(
//                         children: [
//                           Icon(Icons.star, color: AppTheme.expAmber, size: 16),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4),
//                               child: LinearProgressIndicator(
//                                 value: user.expPoint / (user.level * 100),
//                                 backgroundColor: AppTheme.darkBackground,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   AppTheme.expAmber,
//                                 ),
//                                 minHeight: 10,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${user.expPoint}/100',
//                             style: TextStyle(
//                               color: AppTheme.textSecondary,
//                               fontSize: 12,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             'Туршлага', // Experience in Mongolian
//                             style: TextStyle(
//                               color: AppTheme.textSecondary,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 4),
//
//                       // Level and coin indicators
//                       Row(
//                         children: [
//                           Text(
//                             '${user.level}-р түвшин', // Level in Mongolian
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const Spacer(),
//                           Icon(
//                             Icons.monetization_on,
//                             color: AppTheme.coinOrange,
//                             size: 16,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${user.coin}',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
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
//                                 _showEditUsernameDialog(context, user);
//
//                                 // todo Edit username functionality
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
//                                 _showEditEmailDialog(context, user);
//                                 // TODO Edit email functionality
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
//                                 _showChangePasswordDialog(context);
//                                 // todo Edit password functionality
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
//                                 _showEditGenderDialog(context, user);
//                                 // todo Edit gender functionality
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
//                                 _showEditAgeDialog(context, user);
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
//             );
//           },
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: AppTheme.primaryBlue,
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.white.withValues(alpha: 0.7),
//           currentIndex: 4,
//           onTap: (index) {
//             if (index != 4) {
//               context.router.replace(HomeRoute());
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
//       ),
//     );
//   }
//
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
//   // Edit username
//   void _showEditUsernameDialog(BuildContext context, AppUser user) {
//     final TextEditingController usernameController = TextEditingController(text: user.username);
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Нэр засах'),
//         content: TextField(
//           controller: usernameController,
//           decoration: const InputDecoration(
//             labelText: 'Шинэ нэр',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Цуцлах'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (usernameController.text.trim().isNotEmpty) {
//                 // Update user with new username
//                 final updatedUser = user.copyWith(username: usernameController.text.trim());
//                 context.read<UserCubit>().updateUser(updatedUser.uid);
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text('Хадгалах'),
//           ),
//         ],
//       ),
//     );
//   }
//
// // Edit email
//   void _showEditEmailDialog(BuildContext context, AppUser appUser) {
//     final TextEditingController emailController = TextEditingController(text: appUser.email);
//     final TextEditingController passwordController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Имэйл засах'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: const InputDecoration(
//                 labelText: 'Шинэ имэйл',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: 'Нууц үг баталгаажуулах',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Цуцлах'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (emailController.text.trim().isNotEmpty &&
//                   emailController.text.contains('@') &&
//                   passwordController.text.isNotEmpty) {
//                 try {
//                   // 1. Re-authenticate user first (required for sensitive operations)
//                   final user = FirebaseAuth.instance.currentUser;
//                   final credential = EmailAuthProvider.credential(
//                     email: FirebaseAuth.instance.currentUser!.email!,
//                     password: passwordController.text,
//                   );
//                   await user?.reauthenticateWithCredential(credential);
//
//                   // 2. Update email in Firebase Auth
//                   await user?.updateEmail(emailController.text.trim());
//
//                   // 3. Update email in Firestore
//                   final updatedUser = appUser?.copyWith(email: emailController.text.trim());
//                   context.read<UserCubit>().updateUser(updatedUser!.uid);
//
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Имэйл амжилттай шинэчлэгдлээ')),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Алдаа гарлаа: ${e.toString()}')),
//                   );
//                 }
//               }
//             },
//             child: const Text('Хадгалах'),
//           ),
//         ],
//       ),
//     );
//   }
//
// // Change password
//   void _showChangePasswordDialog(BuildContext context) {
//     final TextEditingController currentPasswordController = TextEditingController();
//     final TextEditingController newPasswordController = TextEditingController();
//     final TextEditingController confirmPasswordController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Нууц үг солих'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: currentPasswordController,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: 'Одоогийн нууц үг',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: newPasswordController,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: 'Шинэ нууц үг',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: confirmPasswordController,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: 'Шинэ нууц үг давтах',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Цуцлах'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (currentPasswordController.text.isNotEmpty &&
//                   newPasswordController.text.isNotEmpty &&
//                   newPasswordController.text == confirmPasswordController.text) {
//                 try {
//                   // 1. Re-authenticate user
//                   final user = FirebaseAuth.instance.currentUser;
//                   final credential = EmailAuthProvider.credential(
//                     email: user!.email!,
//                     password: currentPasswordController.text,
//                   );
//                   await user.reauthenticateWithCredential(credential);
//
//                   // 2. Update password
//                   await user.updatePassword(newPasswordController.text);
//
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Нууц үг амжилттай солигдлоо')),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Алдаа гарлаа: ${e.toString()}')),
//                   );
//                 }
//               } else if (newPasswordController.text != confirmPasswordController.text) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Шинэ нууц үгнүүд таарахгүй байна')),
//                 );
//               }
//             },
//             child: const Text('Хадгалах'),
//           ),
//         ],
//       ),
//     );
//   }
//
// // Edit gender
//   void _showEditGenderDialog(BuildContext context, AppUser user) {
//     Gender selectedGender = user.gender;
//
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: const Text('Хүйс сонгох'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: Gender.values.map((gender) {
//               return RadioListTile<Gender>(
//                 title: Text(_getGenderText(gender)),
//                 value: gender,
//                 groupValue: selectedGender,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedGender = value!;
//                   });
//                 },
//               );
//             }).toList(),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Цуцлах'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 final updatedUser = user.copyWith(gender: selectedGender);
//                 context.read<UserCubit>().updateUser(updatedUser.uid);
//                 Navigator.pop(context);
//               },
//               child: const Text('Хадгалах'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// // Edit age
//   void _showEditAgeDialog(BuildContext context, AppUser user) {
//     final TextEditingController ageController = TextEditingController(text: user.age.toString());
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Нас засах'),
//         content: TextField(
//           controller: ageController,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             labelText: 'Нас',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Цуцлах'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final age = int.tryParse(ageController.text);
//               if (age != null && age > 0) {
//                 final updatedUser = user.copyWith(age: age);
//                 context.read<UserCubit>().updateUser(updatedUser.uid);
//                 Navigator.pop(context);
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Зөв нас оруулна уу')),
//                 );
//               }
//             },
//             child: const Text('Хадгалах'),
//           ),
//         ],
//       ),
//     );
//   }
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
// }