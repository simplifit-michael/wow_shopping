import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/di_widget.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_icon.dart';

@immutable
class WishlistButton extends StatefulWidget with WatchItStatefulWidgetMixin {
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
      GetIt.I<WishlistRepo>().removeFromWishlist(widget.item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = watch(GetIt.I<WishlistRepo>()).currentWishlistItems;
    final inWishlist = items.contains(widget.item);
    return IconButton(
      onPressed: () => _onTogglePressed(!inWishlist),
      icon: AppIcon(
        iconAsset: inWishlist //
            ? Assets.iconHeartFilled
            : Assets.iconHeartEmpty,
        color: inWishlist //
            ? AppTheme.of(context).appColor
            : const Color(0xFFD0D0D0),
      ),
    );
  }
}
