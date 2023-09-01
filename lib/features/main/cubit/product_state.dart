part of 'product_cubit.dart';

@immutable
class ProductState {
  final List<ProductItem> topSelling;
  final List<ProductItem> items;

  const ProductState(this.topSelling, this.items);
}
