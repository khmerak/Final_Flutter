import 'package:clothes_shop/helper/cart_service.dart';
import 'package:clothes_shop/helper/checkout_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartController extends GetxController {
  // ======================
  // VARIABLES
  // ======================
  var cartItems = [].obs;
  var isLoading = false.obs;

  var selectedItems = <int>[].obs; // index-based selection

  final CartService _service = CartService();
  final CheckoutService _checkoutService = CheckoutService();

  final storage = GetStorage();
  late int userId;

  // ======================
  // INIT LOAD
  // ======================
  @override
  void onInit() {
    super.onInit();
    userId = storage.read("user_id") ?? 0;
    loadCart();
  }

  // ======================
  // SELECT / UNSELECT ITEM
  // ======================
  void toggleSelectItem(int index) {
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
  }

  // ======================
  // LOAD CART
  // ======================
  Future<void> loadCart() async {
    try {
      isLoading(true);
      final data = await _service.getCart(userId);
      cartItems.value = data;
    } catch (e) {
      print("❌ Failed to load cart: $e");
    } finally {
      isLoading(false);
    }
  }

  // ======================
  // ADD TO CART
  // ======================
  Future<void> addToCart(int productId) async {
    bool success = await _service.addToCart(userId, productId);

    if (success) {
      loadCart();
      Get.snackbar("Success", "Product added to cart");
    } else {
      Get.snackbar("Error", "Failed to add to cart");
    }
  }

  // ======================
  // UPDATE QUANTITY
  // ======================
  Future<void> increaseQuantity(int index) async {
    try {
      final cartId = cartItems[index]["id"];
      int qty = int.parse(cartItems[index]["quantity"].toString()) + 1;

      if (await _service.updateQuantity(cartId, qty)) {
        cartItems[index]["quantity"] = qty;
        cartItems.refresh();
      }
    } catch (e) {
      print("❌ Increase qty error: $e");
    }
  }

  Future<void> decreaseQuantity(int index) async {
    try {
      final cartId = cartItems[index]["id"];
      int qty = int.parse(cartItems[index]["quantity"].toString());

      if (qty > 1) {
        qty--;
        if (await _service.updateQuantity(cartId, qty)) {
          cartItems[index]["quantity"] = qty;
          cartItems.refresh();
        }
      }
    } catch (e) {
      print("❌ Decrease qty error: $e");
    }
  }

  // ======================
  // REMOVE CART ITEM
  // ======================
  Future<void> removeItem(int index) async {
    try {
      final cartId = cartItems[index]["id"];

      if (await _service.removeCartItem(cartId)) {
        cartItems.removeAt(index);
        selectedItems.remove(index);
      }
    } catch (e) {
      print("❌ Remove item error: $e");
    }
  }

  // ======================
  // SELECTED SUBTOTAL
  // ======================
  double get selectedSubtotal {
    double sum = 0;

    for (var index in selectedItems) {
      if (index < 0 || index >= cartItems.length) continue;
      var item = cartItems[index];

      double price =
          double.tryParse(item["product"]["price"].toString()) ?? 0;
      int qty = int.tryParse(item["quantity"].toString()) ?? 1;

      sum += price * qty;
    }

    return sum;
  }

  // ======================
  // CHECKOUT (FINAL VERSION)
  // ======================
  Future<bool> checkout() async {
    if (selectedItems.isEmpty) {
      Get.snackbar("Error", "Please select at least 1 item");
      return false;
    }

    try {
      isLoading(true);

      List<Map<String, dynamic>> items = [];

      // Build payload items
      for (var index in selectedItems) {
        final cart = cartItems[index];

        double price =
            double.tryParse(cart["product"]["price"].toString()) ?? 0;

        items.add({
          "cart_item_id": cart["id"],
          "product_id": cart["product_id"],
          "quantity": cart["quantity"],
          "price": price,
        });
      }

      Map<String, dynamic> payload = {
        "user_id": userId,
        "payment_method": "cash",
        "total_amount": selectedSubtotal + 10,
        "items": items,
      };

      bool success = await _checkoutService.checkout(payload);

      if (success) {
        Get.snackbar("Success", "Checkout completed");

        // Remove selected items locally
        selectedItems.sort();
        for (var index in selectedItems.reversed) {
          cartItems.removeAt(index);
        }

        selectedItems.clear();

        return true;
      } else {
        Get.snackbar("Error", "Checkout failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Checkout error");
      print("Checkout error: $e");
      return false;
    } finally {
      isLoading(false);
    }
  }
}
