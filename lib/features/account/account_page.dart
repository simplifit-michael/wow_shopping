import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/features/account/cubit/account_cubit.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';

@immutable
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Account'),
            verticalMargin48,
            verticalMargin48,
            AppButton(
              onPressed: () => context.read<AccountCubit>().logout(),
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
