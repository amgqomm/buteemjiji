import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserService _userService;
  StreamSubscription<AppUser?>? _userSubscription;

  UserCubit({required UserService userService})
    : _userService = userService,
      super(UserState.initial());

  Future<void> loadUser(String uid) async {
    try {
      emit(UserState.loading());

      _userSubscription?.cancel();

      _userSubscription = _userService
          .streamUser(uid)
          .listen(
            (AppUser? user) {
              if (user != null) {
                emit(UserState.loaded(user));
              } else {
                emit(UserState.error('User not found'));
              }
            },
            onError: (e) {
              emit(
                UserState.error('Stream error: $e'),
              );
            },
          );
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  Future<void> updateUser(AppUser updatedUser) async {
    try {
      emit(UserState.loading());
      await _userService.updateUser(updatedUser);
      emit(UserState.loaded(updatedUser));
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  Future<void> updateUserStats({
    required int exp,
    required int health,
    required int coin,
  }) async {
    try {
      if (state.user == null) {
        return;
      }
      await _userService.updateUserStats(
        uid: state.user!.uid,
        expChange: exp,
        healthChange: health,
        coinChange: coin,
      );
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
