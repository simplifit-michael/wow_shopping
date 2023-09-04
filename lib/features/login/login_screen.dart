import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';

class LoginScreen extends StatefulWidget with WatchItStatefulWidgetMixin{
  const LoginScreen._();

  static Route<void> route() {
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: const LoginScreen._(),
        );
      },
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final _logic = LoginLogic(GetIt.I<AuthRepo>());

  @override
  Widget build(BuildContext context) {
    watch(_logic);
    return Material(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              onPressed:
                  _logic.currentState.isLoading ? null : _logic.onLoginPressed,
              label: 'Login',
            ),
            verticalMargin16,
            if (_logic.currentState.isLoading) //
              const CircularProgressIndicator(),
            if (_logic.currentState.hasError) //
              Text(_logic.currentState.lastError),
          ],
        ),
      ),
    );
  }
}

class LoginLogic with ChangeNotifier {
  LoginLogic(this._authRepo);

  final AuthRepo _authRepo;
  var _state = LoginState.initial();

  LoginState get currentState => _state;
  set currentState(LoginState value) {
    _state = value;
    notifyListeners();
  }

  Future<void> onLoginPressed() async {
    currentState = LoginState.loading();
    try {
      await _authRepo.login('username', 'password');
    } catch (error) {
      currentState = LoginState.error(error);
    }
  }
}

class LoginState {
  LoginState.initial()
      : isLoading = false,
        lastError = '';

  LoginState.loading()
      : isLoading = true,
        lastError = '';

  LoginState.error(dynamic error)
      : isLoading = false,
        lastError = error.toString();

  final bool isLoading;
  final String lastError;

  bool get hasError => lastError.isNotEmpty;
}
