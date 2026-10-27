import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:async';

import 'package:buteemjiji/cubits/auth/auth_cubit.dart';
import 'package:buteemjiji/services/auth_service.dart';
import 'package:buteemjiji/utils/app_enums.dart';

@GenerateMocks([AuthService, User])
import 'auth_cubit_test.mocks.dart';

void main() {
  late MockAuthService mockAuthService;
  late MockUser mockUser;
  late StreamController<User?> authStateController;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUser = MockUser();
    authStateController = StreamController<User?>();

    when(mockUser.uid).thenReturn('test-user-id');
    when(mockAuthService.authStateChanges).thenAnswer((_) => authStateController.stream);
  });

  tearDown(() {
    authStateController.close();
  });

  group('AuthCubit', () {
    test('initial state is AuthStatus.initial', () {
      final authCubit = AuthCubit(authService: mockAuthService);

      expect(authCubit.state.status, equals(AuthStatus.initial));
      expect(authCubit.state.isLoading, isFalse);
      expect(authCubit.state.user, isNull);
      expect(authCubit.state.errorMessage, isNull);
    });

    blocTest<AuthCubit, AuthState>(
      'emits authenticated state when auth state changes with existing user',
      build: () {
        when(mockAuthService.userExists('test-user-id')).thenAnswer((_) async => true);
        return AuthCubit(authService: mockAuthService);
      },
      act: (cubit) {
        authStateController.add(mockUser);
      },
      expect: () => [
        AuthState(
          status: AuthStatus.authenticated,
          user: mockUser,
          isLoading: false,
          errorMessage: null,
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'calls signOut when auth state changes with new user in initial state',
      build: () {
        when(mockAuthService.userExists('test-user-id')).thenAnswer((_) async => false);
        when(mockAuthService.signOut()).thenAnswer((_) async => null);
        return AuthCubit(authService: mockAuthService);
      },
      act: (cubit) {
        authStateController.add(mockUser);
      },
      expect: () => [],
      verify: (_) {
        verify(mockAuthService.signOut()).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits registering state when auth state changes with new user in non-initial state',
      build: () {
        when(mockAuthService.userExists('test-user-id')).thenAnswer((_) async => false);
        return AuthCubit(authService: mockAuthService);
      },
      seed: () => AuthState(status: AuthStatus.unauthenticated),
      act: (cubit) {
        authStateController.add(mockUser);
      },
      expect: () => [
        AuthState(
          status: AuthStatus.registering,
          user: mockUser,
          isLoading: false,
          errorMessage: null,
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated state when auth state changes to null',
      build: () {
        return AuthCubit(authService: mockAuthService);
      },
      act: (cubit) {
        authStateController.add(null);
      },
      expect: () => [
        AuthState(
          status: AuthStatus.unauthenticated,
          user: null,
          isLoading: false,
          errorMessage: null,
        ),
      ],
    );

    group('signInWithEmailAndPassword', () {
      blocTest<AuthCubit, AuthState>(
        'emits loading then authenticated state on successful login with existing user',
        build: () {
          when(mockAuthService.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => mockUser);
          when(mockAuthService.userExists('test-user-id')).thenAnswer((_) async => true);
          return AuthCubit(authService: mockAuthService);
        },
        act: (cubit) => cubit.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
        expect: () => [
          AuthState(
            status: AuthStatus.initial,
            isLoading: true,
            errorMessage: null,
          ),
          AuthState(
            status: AuthStatus.authenticated,
            user: mockUser,
            isLoading: false,
            errorMessage: null,
          ),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits loading then registering state on successful login with new user',
        build: () {
          when(mockAuthService.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => mockUser);
          when(mockAuthService.userExists('test-user-id')).thenAnswer((_) async => false);
          return AuthCubit(authService: mockAuthService);
        },
        act: (cubit) => cubit.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
        expect: () => [
          AuthState(
            status: AuthStatus.initial,
            isLoading: true,
            errorMessage: null,
          ),
          AuthState(
            status: AuthStatus.registering,
            user: mockUser,
            isLoading: false,
            errorMessage: null,
          ),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits loading then error state on failed login',
        build: () {
          when(mockAuthService.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'wrong-password',
          )).thenThrow(Exception('Invalid credentials'));
          return AuthCubit(authService: mockAuthService);
        },
        act: (cubit) => cubit.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'wrong-password',
        ),
        expect: () => [
          AuthState(
            status: AuthStatus.initial,
            isLoading: true,
            errorMessage: null,
          ),
          AuthState(
            status: AuthStatus.initial,
            isLoading: false,
            errorMessage: 'Exception: Invalid credentials',
          ),
        ],
      );
    });

    group('signUpWithEmailAndPassword', () {
      blocTest<AuthCubit, AuthState>(
        'emits loading state on signup attempt',
        build: () {
          when(mockAuthService.signUpWithEmailAndPassword(
            email: 'new@example.com',
            password: 'password123',
          )).thenAnswer((_) async => null);
          return AuthCubit(authService: mockAuthService);
        },
        act: (cubit) => cubit.signUpWithEmailAndPassword(
          email: 'new@example.com',
          password: 'password123',
        ),
        expect: () => [
          AuthState(
            status: AuthStatus.initial,
            isLoading: true,
            errorMessage: null,
          ),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits error state on signup failure',
        build: () {
          when(mockAuthService.signUpWithEmailAndPassword(
            email: 'existing@example.com',
            password: 'password123',
          )).thenThrow(Exception('Email already in use'));
          return AuthCubit(authService: mockAuthService);
        },
        act: (cubit) => cubit.signUpWithEmailAndPassword(
          email: 'existing@example.com',
          password: 'password123',
        ),
        expect: () => [
          AuthState(
            status: AuthStatus.initial,
            isLoading: true,
            errorMessage: null,
          ),
          AuthState(
            status: AuthStatus.initial,
            isLoading: false,
            errorMessage: 'Exception: Email already in use',
          ),
        ],
      );
    });

    group('completeUserProfile', () {
      blocTest<AuthCubit, AuthState>(
        'emits authenticated state on successful profile completion',
        build: () {
          when(mockAuthService.completeUserProfile(
            username: 'testuser',
            age: 25,
            gender: Gender.male,
          )).thenAnswer((_) async => null);
          return AuthCubit(authService: mockAuthService);
        },
        seed: () => AuthState.registering(mockUser),
        act: (cubit) => cubit.completeUserProfile(
          username: 'testuser',
          age: 25,
          gender: Gender.male,
        ),
        expect: () => [
          AuthState(
            status: AuthStatus.registering,
            user: mockUser,
            isLoading: true,
            errorMessage: null,
          ),
          AuthState(
            status: AuthStatus.authenticated,
            user: mockUser,
            isLoading: false,
            errorMessage: null,
          ),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits error state on profile completion failure',
        build: () {
          when(mockAuthService.completeUserProfile(
            username: 'testuser',
            age: 25,
            gender: Gender.male,
          )).thenThrow(Exception('Failed to update profile'));
          return AuthCubit(authService: mockAuthService);
        },
        seed: () => AuthState.registering(mockUser),
        act: (cubit) => cubit.completeUserProfile(
          username: 'testuser',
          age: 25,
          gender: Gender.male,
        ),
        expect: () => [
          AuthState(
            status: AuthStatus.registering,
            user: mockUser,
            isLoading: true,
            errorMessage: null,
          ),
          AuthState(
            status: AuthStatus.registering,
            user: mockUser,
            isLoading: false,
            errorMessage: 'Exception: Failed to update profile',
          ),
        ],
      );
    });

    group('signOut', () {
      blocTest<AuthCubit, AuthState>(
        'emits loading state on signout attempt',
        build: () {
          when(mockAuthService.signOut()).thenAnswer((_) async => null);
          return AuthCubit(authService: mockAuthService);
        },
        seed: () => AuthState.authenticated(mockUser),
        act: (cubit) => cubit.signOut(),
        expect: () => [
          AuthState(
            status: AuthStatus.authenticated,
            user: mockUser,
            isLoading: true,
            errorMessage: null,
          ),
        ],
        verify: (_) {
          verify(mockAuthService.signOut()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits error state on signout failure',
        build: () {
          when(mockAuthService.signOut()).thenThrow(Exception('Network error'));
          return AuthCubit(authService: mockAuthService);
        },
        seed: () => AuthState.authenticated(mockUser),
        act: (cubit) => cubit.signOut(),
        expect: () => [
          AuthState(
            status: AuthStatus.authenticated,
            user: mockUser,
            isLoading: true,
            errorMessage: null,
          ),
          AuthState(
            status: AuthStatus.authenticated,
            user: mockUser,
            isLoading: false,
            errorMessage: 'Exception: Network error',
          ),
        ],
      );
    });
  });
}