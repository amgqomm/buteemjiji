part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

// class Authenticated extends AuthState {

class AuthAuthenticated extends AuthState {
  final AppUser user;

  // const Authenticated(this.user);

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

// class PartiallyAuthenticated extends AuthState {
//   final User user;
//
//   const PartiallyAuthenticated(this.user);
//
//   @override
//   List<Object> get props => [user];
// }

// class Unauthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthRegistered extends AuthState {
  final String email;
  final String uid;

  const AuthRegistered({required this.email, required this.uid});

  @override
  List<Object?> get props => [email, uid];
}


class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

// class UsernameAvailabilityChecked extends AuthState {
//   final String username;
//   final bool isAvailable;
//
//   const UsernameAvailabilityChecked(this.username, this.isAvailable);
//
//   @override
//   List<Object> get props => [username, isAvailable];
// }
//
// class UsernameCheckError extends AuthState {
//   final String message;
//   final AppUser? appUser;
//   final User? firebaseUser;
//
//   const UsernameCheckError(this.message, [this.appUser, this.firebaseUser]);
//
//   @override
//   List<Object?> get props => [message, appUser, firebaseUser];
// }