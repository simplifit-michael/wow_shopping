import 'dart:collection';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wow_shopping/models/cart_item.dart';

part 'cart_storage.g.dart';

@JsonSerializable()
class CartStorage extends ChangeNotifier {
  CartStorage({
    required List<CartItem> items,
  }) : _items = items;

  List<CartItem> _items;
  List<CartItem> get items => _items;
  set items(List<CartItem> value) {
    _items = value;
    notifyListeners();
  }

  static final empty = CartStorage(items: []);

  CartStorage copyWith({
    Iterable<CartItem>? items,
  }) {
    return CartStorage(
      items: items != null ? UnmodifiableListView(items) : this.items,
    );
  }

    Decimal get total {
    return items.fold<Decimal>(Decimal.zero, (prev, el) => prev + el.total);
  }

  factory CartStorage.fromJson(Map json) => _$CartStorageFromJson(json);

  Map<String, dynamic> toJson() => _$CartStorageToJson(this);

  @override
  String toString() => '${describeIdentity(this)}{${toJson()}}';
}
