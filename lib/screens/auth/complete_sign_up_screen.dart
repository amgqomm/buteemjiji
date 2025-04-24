import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../routes/app_router.dart';
import '../../utils/app_enums.dart';

@RoutePage()
class CompleteSignUpScreen extends StatefulWidget {
  const CompleteSignUpScreen({super.key});

  @override
  _CompleteSignUpScreenState createState() => _CompleteSignUpScreenState();
}

class _CompleteSignUpScreenState extends State<CompleteSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();
  Gender _selectedGender = Gender.other;

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _completeSignUp() {
    if (_formKey.currentState!.validate()) {
      final age = int.tryParse(_ageController.text) ?? 0;

      context.read<AuthCubit>().completeUserProfile(
        username: _usernameController.text.trim(),
        age: age,
        gender: _selectedGender,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Хувийн мэдээлэл'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.router.replace(const HomeRoute());
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Ганцхан алхам дутуу!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Өөрийн гараар бүтээмжээ удирд',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Нэр',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Нэр оруулна уу?';
                          }
                          if (value.length < 3) {
                            return 'Нэрний урт хамгийн багадаа 3 байх ёстой';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Нас',
                          prefixIcon: Icon(Icons.cake),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Насаа оруулна уу?';
                          }
                          final age = int.tryParse(value);
                          if (age == null) {
                            return 'Тоо оруулна уу?';
                          }
                          if (age > 120 || age < 1) {
                            return 'Өөрийн жинхэнэ насаа оруулна уу?';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<Gender>(
                        decoration: const InputDecoration(
                          labelText: 'Хүйс',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedGender,
                        items:
                            Gender.values.map((Gender gender) {
                              return DropdownMenuItem<Gender>(
                                value: gender,
                                child: Text(genderTranslations[gender]!),
                              );
                            }).toList(),
                        onChanged: (Gender? value) {
                          if (value != null) {
                            setState(() {
                              _selectedGender = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: state.isLoading ? null : _completeSignUp,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child:
                            state.isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                  'Бүртгүүлэх',
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

final Map<Gender, String> genderTranslations = {
  Gender.male: 'Эр',
  Gender.female: 'Эм',
  Gender.other: 'Бусад',
};
