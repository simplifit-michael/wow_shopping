part of 'cart_cubit.dart';

@immutable
class CartState {
  final List<CartItem> items;

  const CartState({required this.items});
}

extension CartCalculationExstension on CartState {
  Decimal get cartTotal {
    return items.fold<Decimal>(Decimal.zero, (prev, el) => prev + el.total);
  }
}
