import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../cubits/auth/auth_cubit.dart';
//import '../../cubits/auth/auth_state.dart';
import '../../routes/app_router.dart';
import '../../utils/app_enums.dart';

// @RoutePage()
// class CompleteSignUpScreen extends StatefulWidget {
//   const CompleteSignUpScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CompleteSignUpScreen> createState() => _CompleteSignUpScreenState();
// }
//
// class _CompleteSignUpScreenState extends State<CompleteSignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _ageController = TextEditingController();
//   String _selectedGender = 'other';
//   bool _isCheckingUsername = false;
//   bool? _isUsernameAvailable;
//
//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _ageController.dispose();
//     super.dispose();
//   }
//
//   void _checkUsernameAvailability() {
//     if (_usernameController.text.isNotEmpty) {
//       setState(() {
//         _isCheckingUsername = true;
//         _isUsernameAvailable = null;
//       });
//
//       context.read<AuthCubit>().checkUsernameAvailability(
//         _usernameController.text,
//       );
//     }
//   }
//
//   void _completeSignUp() {
//     if (_formKey.currentState?.validate() ?? false) {
//       final int age = int.tryParse(_ageController.text) ?? 0;
//
//       context.read<AuthCubit>().completeSignUp(
//         username: _usernameController.text.trim(),
//         age: age,
//         gender: _selectedGender,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Complete Your Profile'),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: BlocConsumer<AuthCubit, AuthState>(
//         listener: (context, state) {
//           if (state is Authenticated) {
//             context.router.replace(const HomeRoute());
//           } else if (state is UsernameAvailabilityChecked) {
//             setState(() {
//               _isCheckingUsername = false;
//               _isUsernameAvailable = state.isAvailable;
//             });
//           } else if (state is AuthError) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(SnackBar(content: Text(state.message)));
//           }
//         },
//         builder: (context, state) {
//           if (!(state is PartiallyAuthenticated) && !(state is AuthLoading)) {
//             // If we're not in the correct state, go back to sign in
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               context.router.replace(const SignInRoute());
//             });
//           }
//
//           return Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const Text(
//                       'Almost there! Let\'s set up your hero profile.',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     const SizedBox(height: 24),
//                     TextFormField(
//                       controller: _usernameController,
//                       decoration: InputDecoration(
//                         labelText: 'Username',
//                         border: const OutlineInputBorder(),
//                         prefixIcon: const Icon(Icons.person),
//                         suffixIcon:
//                             _isCheckingUsername
//                                 ? const SizedBox(
//                                   width: 15,
//                                   height: 15,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                   ),
//                                 )
//                                 : _isUsernameAvailable == null
//                                 ? IconButton(
//                                   icon: const Icon(Icons.check_circle_outline),
//                                   onPressed: _checkUsernameAvailability,
//                                 )
//                                 : Icon(
//                                   _isUsernameAvailable!
//                                       ? Icons.check_circle
//                                       : Icons.cancel,
//                                   color:
//                                       _isUsernameAvailable!
//                                           ? Colors.green
//                                           : Colors.red,
//                                 ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a username';
//                         }
//                         if (value.length < 3) {
//                           return 'Username must be at least 3 characters';
//                         }
//                         if (_isUsernameAvailable == false) {
//                           return 'Username is already taken';
//                         }
//                         return null;
//                       },
//                       onChanged: (value) {
//                         setState(() {
//                           _isUsernameAvailable = null;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _ageController,
//                       decoration: const InputDecoration(
//                         labelText: 'Age',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.calendar_today),
//                       ),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your age';
//                         }
//                         final age = int.tryParse(value);
//                         if (age == null || age <= 0 || age > 120) {
//                           return 'Please enter a valid age';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     const Text('Gender:'),
//                     RadioListTile<String>(
//                       title: const Text('Male'),
//                       value: 'male',
//                       groupValue: _selectedGender,
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedGender = value!;
//                         });
//                       },
//                     ),
//                     RadioListTile<String>(
//                       title: const Text('Female'),
//                       value: 'female',
//                       groupValue: _selectedGender,
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedGender = value!;
//                         });
//                       },
//                     ),
//                     RadioListTile<String>(
//                       title: const Text('Other'),
//                       value: 'other',
//                       groupValue: _selectedGender,
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedGender = value!;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     ElevatedButton(
//                       onPressed: state is AuthLoading ? null : _completeSignUp,
//                       child:
//                           state is AuthLoading
//                               ? const CircularProgressIndicator()
//                               : const Text('Complete Setup'),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     TextButton.icon(
//                       onPressed: () {
//                         context.read<AuthCubit>().signOut();
//                       },
//                       icon: const Icon(Icons.arrow_back),
//                       label: const Text('Go back to sign in'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
@RoutePage()
class CompleteSignUpScreen extends StatefulWidget {
  final String uid;
  final String email;

  const CompleteSignUpScreen({
    Key? key,
    @PathParam('uid') required this.uid,
    @PathParam('email') required this.email,
  }) : super(key: key);

  @override
  _CompleteSignUpScreenState createState() => _CompleteSignUpScreenState();
}

class _CompleteSignUpScreenState extends State<CompleteSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();
  Gender _selectedGender = Gender.other;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            AutoRouter.of(context).replace(const HomeRoute());
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Almost there! Complete your profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${widget.email}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age <= 0) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Gender', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<Gender>(
                          title: const Text('Male'),
                          value: Gender.male,
                          groupValue: _selectedGender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<Gender>(
                          title: const Text('Female'),
                          value: Gender.female,
                          groupValue: _selectedGender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<Gender>(
                          title: const Text('Other'),
                          value: Gender.other,
                          groupValue: _selectedGender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed:
                        _isLoading
                            ? null
                            : () {
                              if (_formKey.currentState!.validate()) {
                                final age = int.parse(_ageController.text);
                                context.read<AuthCubit>().completeSignUp(
                                  widget.uid,
                                  _usernameController.text,
                                  age,
                                  _selectedGender,
                                );
                              }
                            },
                    child:
                        _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Complete Setup'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
