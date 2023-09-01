import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';
import 'package:wow_shopping/models/product_item.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepo _repo;
  WishlistCubit(this._repo) : super(const WishlistState([])) {
    _onItemsChangedSubscription =
        _repo.streamWishlistItems.listen(_onItemsChanged);
  }

  late final StreamSubscription _onItemsChangedSubscription;

  void removeToWishlist(String selected) => _repo.removeToWishlist(selected);

  void addToWishlist(String id) => _repo.addToWishlist(id);

  void _onItemsChanged(List<ProductItem> items) {
    emit(WishlistState(items));
  }

  @override
  Future<void> close() async {
    await _onItemsChangedSubscription.cancel();
    return super.close();
  }
}
