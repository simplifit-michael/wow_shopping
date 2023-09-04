import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';

final backendInitProvider = FutureProvider((ref) async {
  await ref.read(authProvider).create();
  await ref.read(productsProvider).create();
  await ref.read(wishlistProvider).create();
  await ref.read(cartProvider).create();
  return null;
});
