import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../utils/app_enums.dart';

// import 'auth_state.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // final AuthService _authService;
  //
  // AuthCubit({required AuthService authService})
  //     : _authService = authService,
  //       super(AuthInitial()) {
  //   // Check if user is already logged in when cubit is created
  //   checkAuthStatus();
  // }

  final AuthService _authService = AuthService();

  AuthCubit() : super(AuthInitial()) {
    checkCurrentUser();
  }

  // void checkAuthStatus() async {
  //   final currentUser = _authService.currentUser;
  //
  //   if (currentUser != null) {
  //     final appUser = await _authService.getUserData(currentUser.uid);
  //     if (appUser != null) {
  //       emit(Authenticated(appUser));
  //     } else {
  //       emit(PartiallyAuthenticated(currentUser));
  //     }
  //   } else {
  //     emit(Unauthenticated());
  //   }
  // }

  void checkCurrentUser() async {
    final user = _authService.currentUser;
    if (user != null) {
      try {
        final userData = await _authService.getUserData(user.uid);
        if (userData != null) {
          emit(AuthAuthenticated(userData));
        } else {
          emit(AuthRegistered(email: user.email ?? '', uid: user.uid));
        }
      } catch (e) {
        emit(AuthError('Failed to load user data'));
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // void signInWithEmail(String email, String password) async {
  //   emit(AuthLoading());
  //
  //   try {
  //     final success = await _authService.signIn(email, password);
  //
  //     if (success) {
  //       final currentUser = _authService.currentUser;
  //       if (currentUser != null) {
  //         final appUser = await _authService.getUserData(currentUser.uid);
  //         if (appUser != null) {
  //           emit(Authenticated(appUser));
  //         } else {
  //           emit(PartiallyAuthenticated(currentUser));
  //         }
  //       } else {
  //         emit(Unauthenticated());
  //       }
  //     } else {
  //       emit(AuthError('Authentication failed'));
  //     }
  //   } catch (e) {
  //     emit(AuthError(e.toString()));
  //   }
  // }

  void signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final credential = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      final userData = await _authService.getUserData(credential.user!.uid);
      if (userData != null) {
        emit(AuthAuthenticated(userData));
      } else {
        emit(AuthError('User data not found'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // void signUpWithEmail(String email, String password) async {
  //   emit(AuthLoading());
  //
  //   try {
  //     final user = await _authService.signUpWithEmail(
  //       email: email,
  //       password: password,
  //     );
  //
  //     if (user != null) {
  //       emit(PartiallyAuthenticated(user));
  //     } else {
  //       emit(AuthError('Sign up failed'));
  //     }
  //   } catch (e) {
  //     emit(AuthError(e.toString()));
  //   }
  // }

  void signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      final credential = await _authService.signUpWithEmailAndPassword(
        email,
        password,
      );
      emit(AuthRegistered(email: email, uid: credential.user!.uid));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // void completeSignUp({
  //   required String username,
  //   required int age,
  //   required String gender,
  // }) async {
  //   if (state is PartiallyAuthenticated) {
  //     final user = (state as PartiallyAuthenticated).user;
  //     emit(AuthLoading());
  //
  //     try {
  //       await _authService.completeSignUp(
  //         uid: user.uid,
  //         username: username,
  //         age: age,
  //         gender: gender,
  //       );
  //
  //       final appUser = await _authService.getUserData(user.uid);
  //       if (appUser != null) {
  //         emit(Authenticated(appUser));
  //       } else {
  //         emit(AuthError('Failed to retrieve user data'));
  //       }
  //     } catch (e) {
  //       emit(AuthError(e.toString()));
  //     }
  //   }
  // }

  void completeSignUp(String uid, String username, int age, Gender gender) async {
    emit(AuthLoading());
    try {
      await _authService.completeUserProfile(uid, username, age, gender);
      final userData = await _authService.getUserData(uid);
      if (userData != null) {
        emit(AuthAuthenticated(userData));
      } else {
        emit(AuthError('Failed to create user profile'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // void signOut() async {
  //   emit(AuthLoading());
  //
  //   try {
  //     await _authService.signOut();
  //     emit(Unauthenticated());
  //   } catch (e) {
  //     emit(AuthError(e.toString()));
  //   }
  // }

  void signOut() async {
    try {
      await _authService.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // void checkUsernameAvailability(String username) async {
  //   try {
  //     final isAvailable = await _authService.isUsernameAvailable(username);
  //     emit(UsernameAvailabilityChecked(username, isAvailable));
  //   } catch (e) {
  //     // Keep the current state, just notify about error
  //     if (state is Authenticated) {
  //       emit(UsernameCheckError(e.toString(), (state as Authenticated).user));
  //     } else if (state is PartiallyAuthenticated) {
  //       emit(UsernameCheckError(e.toString(), null, (state as PartiallyAuthenticated).user));
  //     }
  //   }
  // }
}