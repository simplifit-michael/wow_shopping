import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/features/wishlist/cubit/wishlist_cubit.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_icon.dart';

@immutable
class WishlistButton extends StatefulWidget {
  const WishlistButton({
    super.key,
    required this.item,
  });

  final ProductItem item;

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  void _onTogglePressed(bool value) {
    if (value) {
      context.read<WishlistCubit>().addToWishlist(widget.item.id);
    } else {
      context.read<WishlistCubit>().removeToWishlist(widget.item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        final isInList = state.items.contains(widget.item);
        return IconButton(
          onPressed: () => _onTogglePressed(!isInList),
          icon: AppIcon(
            iconAsset: isInList //
                ? Assets.iconHeartFilled
                : Assets.iconHeartEmpty,
            color: isInList //
                ? AppTheme.of(context).appColor
                : const Color(0xFFD0D0D0),
          ),
        );
      },
    );
  }
}
