import 'package:clothes_shop/helper/wishlist_service.dart';
import 'package:get/get.dart';
import '../model/wishlist_model.dart';

class WishlistController extends GetxController {
  var wishlist = <WishlistItem>[].obs;
  var isLoading = false.obs;

  final WishlistService _service = WishlistService();

  // ============================
  // LOAD WISHLIST
  // ============================
  Future<void> fetchWishlist(int userId) async {
    if (userId == 0) return; // User not logged in

    try {
      isLoading(true);
      wishlist.value = await _service.getWishlist(userId);
    } catch (e) {
      print("❌ Error loading wishlist: $e");
    } finally {
      isLoading(false);
    }
  }

  // ============================
  // CHECK FAVORITE
  // ============================
  bool isFavorite(int productId) {
    return wishlist.any((item) => item.productId == productId);
  }

  // ============================
  // ADD TO WISHLIST
  // ============================
  Future<void> addToWishlist(int userId, int productId) async {
    try {
      final success = await _service.addToWishlist(userId, productId);
      if (success) {
        // Add instantly to UI (optimistic update)
        wishlist.add(
          WishlistItem(
            id: DateTime.now().millisecondsSinceEpoch, // temp id
            userId: userId,
            productId: productId,
            product: Product(
              id: productId,
              title: '',
              price: 0,
              imageUrl: '',
            ),
          ),
        );
        wishlist.refresh();
        fetchWishlist(userId); // refresh from API
      }
    } catch (e) {
      print("❌ Add error: $e");
    }
  }

  // ============================
  // REMOVE FROM WISHLIST
  // ============================
  Future<void> removeFromWishlist(int id, int userId) async {
    try {
      final success = await _service.removeWishlist(id);
      if (success) {
        wishlist.removeWhere((item) => item.id == id);
        wishlist.refresh();
      }
    } catch (e) {
      print("❌ Remove error: $e");
    }
  }

  // ============================
  // TOGGLE FAVORITE
  // ============================
  Future<void> toggleFavorite(int userId, int productId) async {
    if (userId == 0) {
      Get.snackbar("Please Login", "You must login to use wishlist");
      return;
    }

    if (isFavorite(productId)) {
      // Remove
      var item = wishlist.firstWhere((i) => i.productId == productId);
      await removeFromWishlist(item.id, userId);
    } else {
      // Add
      await addToWishlist(userId, productId);
    }
  }
}
