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

  void loadUser(String uid) {
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
            onError: (error) {
              emit(UserState.error(error.toString()));
            },
          );
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  Future<void> updateUser(String uid) async {
    try {
      if (state.user == null) {
        return;
      }
      await _userService.updateUser(state.user!.uid);
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
