import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/models/product_item.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductsRepo _repo;
  ProductCubit(this._repo) : super(const ProductState([], [])) {
    _initAsync();
  }

  Future<void> _initAsync() async {
    final topSelling = await _repo.fetchTopSelling();
    final items = _repo.cachedItems;
    emit(ProductState(topSelling, items));
  }
}
