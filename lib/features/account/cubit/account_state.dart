part of 'account_cubit.dart';

@immutable
sealed class AccountState {
  bool get isLoading => this is AccountLoadingState;
  bool get hasError =>
      this is AccountLoginErrorState || this is AccountLogoutErrorState;

  String? get lastError {
    if (this is AccountLoginErrorState) {
      return (this as AccountLoginErrorState).error;
    }
    if (this is AccountLogoutErrorState) {
      return (this as AccountLogoutErrorState).error;
    }
    return null;
  }
}

final class AccountLoadingState extends AccountState {}

final class AccountLoginErrorState extends AccountState {
  final String error;

  AccountLoginErrorState({required this.error});
}

final class AccountLogoutErrorState extends AccountState {
  final String error;

  AccountLogoutErrorState({required this.error});
}

final class AccountLoggedOutState extends AccountState {}

final class AccountLoggedInState extends AccountState {
  AccountLoggedInState(this.user);
  final User user;
}
