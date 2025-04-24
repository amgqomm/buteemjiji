part of 'auth_cubit.dart';

enum AuthStatus { initial, authenticated, unauthenticated, registering }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });

  factory AuthState.initial() => AuthState();

  factory AuthState.authenticated(User user) =>
      AuthState(status: AuthStatus.authenticated, user: user);

  factory AuthState.unauthenticated([String? errorMessage]) =>
      AuthState(status: AuthStatus.unauthenticated, errorMessage: errorMessage);

  factory AuthState.registering(User user) =>
      AuthState(status: AuthStatus.registering, user: user);

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [status, user?.uid, errorMessage, isLoading];
}
