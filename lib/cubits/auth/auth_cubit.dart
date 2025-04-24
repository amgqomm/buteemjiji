import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import '../../services/auth_service.dart';
import '../../utils/app_enums.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  StreamSubscription<User?>? _authSubscription;

  AuthCubit({required AuthService authService})
    : _authService = authService,
      super(AuthState.initial()) {
    _authSubscription = _authService.authStateChanges.listen((
      User? user,
    ) async {
      if (user != null) {
        final userExists = await _authService.userExists(user.uid);
        if (userExists) {
          emit(AuthState.authenticated(user));
        } else {
          if (state.status == AuthStatus.initial) {
            await _authService.signOut();
          } else {
            emit(AuthState.registering(user));
          }
        }
      } else {
        emit(AuthState.unauthenticated());
      }
    });
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userExists = await _authService.userExists(user!.uid);

      if (userExists) {
        emit(AuthState.authenticated(user));
      } else {
        emit(AuthState.registering(user));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> completeUserProfile({
    required String username,
    required int age,
    required Gender gender,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      await _authService.completeUserProfile(
        username: username,
        age: age,
        gender: gender,
      );
      if (state.user != null) {
        emit(AuthState.authenticated(state.user!));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      await _authService.signOut();
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
