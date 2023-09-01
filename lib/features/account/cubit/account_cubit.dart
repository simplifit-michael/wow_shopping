import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/models/user.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AuthRepo _repo;
  AccountCubit(this._repo) : super(AccountLoggedOutState()) {
    _initAsync();
  }

  late final StreamSubscription _isLoggedInSubscription;

  Future<void> _initAsync() async {
    _isLoggedInSubscription = _repo.streamIsLoggedIn.listen(_onUserChanged);
    if (!_repo.isLoggedIn) return;
    emit(AccountLoggedInState(_repo.currentUser));
  }

  void _onUserChanged(bool isLoggedIn) {
    if (isLoggedIn) {
      emit(AccountLoggedInState(_repo.currentUser));
    } else {
      emit(AccountLoggedOutState());
    }
  }

  @override
  Future<void> close() async {
    await _isLoggedInSubscription.cancel();
    super.close();
  }

  Future<void> logout() => _repo.logout();

  Future<void> login(String userName, String password) =>
      _repo.login(userName, password);
}
