import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/user/user_cubit.dart';
import '../models/user_model.dart';
import '../utils/app_enums.dart';
import '../extensions/gender_extensions.dart';

class ProfileDialogs {
  static void showEditUsernameDialog(BuildContext context, AppUser user) {
    final TextEditingController usernameController = TextEditingController(text: user.username);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Нэр засах'),
        content: TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: 'Шинэ нэр',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Цуцлах'),
          ),
          ElevatedButton(
            onPressed: () {
              if (usernameController.text.trim().isNotEmpty) {
                final updatedUser = user.copyWith(username: usernameController.text.trim());
                context.read<UserCubit>().updateUser(updatedUser);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Нэр амжилттай шинэчлэгдлээ')),
                );
              }
            },
            child: const Text('Хадгалах'),
          ),
        ],
      ),
    );
  }

  static void showEditEmailDialog(BuildContext context, AppUser appUser) {
    final TextEditingController emailController = TextEditingController(text: appUser.email);
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Имэйл засах'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Шинэ имэйл',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Нууц үг баталгаажуулах',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Цуцлах'),
          ),
          ElevatedButton(
            onPressed: () async {
              final outerContext = context;

              if (emailController.text.trim().isNotEmpty &&
                  emailController.text.contains('@') &&
                  passwordController.text.isNotEmpty) {
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  final credential = EmailAuthProvider.credential(
                    email: user!.email!,
                    password: passwordController.text,
                  );
                  await user.reauthenticateWithCredential(credential);

                  final newEmail = emailController.text.trim();

                  await user.verifyBeforeUpdateEmail(newEmail);

                  Navigator.pop(dialogContext);

                  final updatedUser = appUser.copyWith(email: newEmail);
                  outerContext.read<UserCubit>().updateUser(updatedUser);

                  ScaffoldMessenger.of(outerContext).showSnackBar(
                    const SnackBar(
                      content: Text('Баталгаажуулах имэйл илгээгдлээ. Имэйл хаягаа баталгаажуулна уу.'),
                      duration: Duration(seconds: 5),
                    ),
                  );

                } catch (e) {
                  if (Navigator.canPop(dialogContext)) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text('Алдаа гарлаа: ${e.toString()}')),
                    );
                  }
                }
              } else {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Зөв имэйл хаяг оруулна уу')),
                );
              }
            },
            child: const Text('Хадгалах'),
          ),
        ],
      ),
    );
  }

  static void showChangePasswordDialog(BuildContext context) {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Нууц үг солих'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Одоогийн нууц үг',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Шинэ нууц үг',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Шинэ нууц үг давтах',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Цуцлах'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (currentPasswordController.text.isNotEmpty &&
                  newPasswordController.text.isNotEmpty &&
                  newPasswordController.text == confirmPasswordController.text) {
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  final credential = EmailAuthProvider.credential(
                    email: user!.email!,
                    password: currentPasswordController.text,
                  );
                  await user.reauthenticateWithCredential(credential);

                  await user.updatePassword(newPasswordController.text);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Нууц үг амжилттай солигдлоо')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Алдаа гарлаа: ${e.toString()}')),
                  );
                }
              } else if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Шинэ нууц үгнүүд таарахгүй байна')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Бүх талбарыг бөглөнө үү')),
                );
              }
            },
            child: const Text('Хадгалах'),
          ),
        ],
      ),
    );
  }

  static void showEditGenderDialog(BuildContext context, AppUser user) {
    Gender selectedGender = user.gender;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Хүйс сонгох'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: Gender.values.map((gender) {
              return RadioListTile<Gender>(
                title: Text(gender.translation),
                value: gender,
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Цуцлах'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedUser = user.copyWith(gender: selectedGender);
                context.read<UserCubit>().updateUser(updatedUser);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Хүйс амжилттай шинэчлэгдлээ')),
                );
              },
              child: const Text('Хадгалах'),
            ),
          ],
        ),
      ),
    );
  }

  static void showEditAgeDialog(BuildContext context, AppUser user) {
    final TextEditingController ageController = TextEditingController(text: user.age.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Нас засах'),
        content: TextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Нас',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Цуцлах'),
          ),
          ElevatedButton(
            onPressed: () {
              final age = int.tryParse(ageController.text);
              if (age != null && age > 0) {
                final updatedUser = user.copyWith(age: age);
                context.read<UserCubit>().updateUser(updatedUser);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Нас амжилттай шинэчлэгдлээ')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Зөв нас оруулна уу')),
                );
              }
            },
            child: const Text('Хадгалах'),
          ),
        ],
      ),
    );
  }
}