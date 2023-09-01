import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/models/product_item.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo _repo;

  late final StreamSubscription _onCartChangedSubscription;

  CartCubit(this._repo) : super(const CartState(items: [])) {
    emit(CartState(items: _repo.currentCartItems));
    _onCartChangedSubscription = _repo.streamCartItems.listen(_onCartChanged);
  }

  void _onCartChanged(List<CartItem> items) {
    emit(CartState(items: items));
  }

  @override
  Future<void> close() async {
    await _onCartChangedSubscription.cancel();
    return super.close();
  }

  void updateQuantity(String id, int quantity) =>
      _repo.updateQuantity(id, quantity);

  void removeToCart(String id) => _repo.removeToCart(id);

  void addToCart(ProductItem item) => _repo.addToCart(item);
}
