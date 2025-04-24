part of 'user_cubit.dart';

enum UserStatus { initial, loading, loaded, error }

class UserState extends Equatable {
  final UserStatus status;
  final AppUser? user;
  final String? errorMessage;

  const UserState({
    this.status = UserStatus.initial,
    this.user,
    this.errorMessage,
  });

  factory UserState.initial() => UserState();

  factory UserState.loading() => UserState(status: UserStatus.loading);

  factory UserState.loaded(AppUser user) =>
      UserState(status: UserStatus.loaded, user: user);

  factory UserState.error(String message) =>
      UserState(status: UserStatus.error, errorMessage: message);

  UserState copyWith({
    UserStatus? status,
    AppUser? user,
    String? errorMessage,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
