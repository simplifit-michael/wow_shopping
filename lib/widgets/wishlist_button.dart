import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/di_widget.dart';
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
      GetIt.I<WishlistRepo>().addToWishlist(widget.item.id);
    } else {
      GetIt.I<WishlistRepo>().removeToWishlist(widget.item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: GetIt.I<WishlistRepo>().isInWishlist(widget.item),
      stream: GetIt.I<WishlistRepo>().streamIsInWishlist(widget.item),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        final value = snapshot.requireData;
        return IconButton(
          onPressed: () => _onTogglePressed(!value),
          icon: AppIcon(
            iconAsset: value //
                ? Assets.iconHeartFilled
                : Assets.iconHeartEmpty,
            color: value //
                ? AppTheme.of(context).appColor
                : const Color(0xFFD0D0D0),
          ),
        );
      },
    );
  }
}
