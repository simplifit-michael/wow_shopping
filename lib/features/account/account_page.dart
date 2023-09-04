import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';

@immutable
class AccountPage extends ConsumerStatefulWidget{
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
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
              onPressed: () => ref.read(authProvider).logout(),
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
