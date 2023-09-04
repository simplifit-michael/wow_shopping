import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:wow_shopping/models/wishlist_storage.dart';

class WishlistRepo with ChangeNotifier{
  WishlistRepo._(this._productsRepo, this._file, this._wishlist);

  final ProductsRepo _productsRepo;
  final File _file;
  WishlistStorage _wishlist;
  Timer? _saveTimer;

  static Future<WishlistRepo> create(ProductsRepo productsRepo) async {
    WishlistStorage wishlist;
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      final file = File(path.join(dir.path, 'wishlist.json'));
      if (await file.exists()) {
        wishlist = WishlistStorage.fromJson(
          json.decode(await file.readAsString()),
        );
      } else {
        wishlist = WishlistStorage.empty;
      }
      return WishlistRepo._(productsRepo, file, wishlist);
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
