import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:wow_shopping/models/wishlist_storage.dart';

final wishlistProvider = ChangeNotifierProvider(
  (ref) => WishlistRepo(ref.read(productsProvider)),
);

class WishlistRepo extends ChangeNotifier{
  final ProductsRepo _productsRepo;
  late final File _file;
  late WishlistStorage _wishlist;
  Timer? _saveTimer;

  WishlistRepo(this._productsRepo);

  Future<void> create() async {
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      _file = File(path.join(dir.path, 'wishlist.json'));
      if (await _file.exists()) {
        _wishlist = WishlistStorage.fromJson(
          json.decode(await _file.readAsString()),
        );
      } else {
        _wishlist = WishlistStorage.empty;
      }
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
  }

  List<ProductItem> get currentWishlistItems =>
      _wishlist.items.map(_productsRepo.findProduct).toList();

  void addToWishlist(String productId) {
    if (_wishlist.items.contains(productId)) {
      return;
    }
    _wishlist = _wishlist.copyWith(
      items: {..._wishlist.items, productId},
    );
    _saveWishlist();
  }

  void removeFromWishlist(String productId) {
    _wishlist = _wishlist.copyWith(
      items: _wishlist.items.where((el) => el != productId),
    );
    _saveWishlist();
  }

  void _saveWishlist() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      await _file.writeAsString(json.encode(_wishlist.toJson()));
    });
    notifyListeners();
  }
}
