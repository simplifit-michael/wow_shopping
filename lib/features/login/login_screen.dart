import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/features/account/cubit/account_cubit.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';

class LoginScreen extends StatefulWidget {
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
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: BlocBuilder<AccountCubit, AccountState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  onPressed: state.isLoading
                      ? null
                      : () => context
                          .read<AccountCubit>()
                          .login('userName', 'password'),
                  label: 'Login',
                ),
                verticalMargin16,
                if (state.isLoading) //
                  const CircularProgressIndicator(),
                if (state.hasError) //
                  Text(state.lastError!),
              ],
            );
          },
        ),
      ),
    );
  }
}
