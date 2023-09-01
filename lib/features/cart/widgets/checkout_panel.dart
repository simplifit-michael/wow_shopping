import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/features/cart/cubit/cart_cubit.dart';
import 'package:wow_shopping/utils/formatting.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/app_panel.dart';
import 'package:wow_shopping/widgets/common.dart';

class CheckoutPanel extends StatelessWidget {
  const CheckoutPanel({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Hero(
          tag: CheckoutPanel,
          child: AppPanel(
            padding: horizontalPadding24 + topPadding12 + bottomPadding24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order amount:'),
                      Text(formatCurrency(state.cartTotal)),
                    ],
                  ),
                ),
                DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: appGreyColor,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Your total amount of discount:'),
                      Text('-'),
                    ],
                  ),
                ),
                verticalMargin12,
                AppButton(
                  onPressed: onPressed,
                  style: AppButtonStyle.highlighted,
                  label: label,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
