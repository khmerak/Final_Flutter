import 'package:clothes_shop/Home/home_screen.dart';
import 'package:clothes_shop/cart/order_comfired_screen.dart';
import 'package:clothes_shop/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.find<CartController>();
  final double shippingCost = 10.0;

  @override
  void initState() {
    super.initState();
    cartController.loadCart();
  }

  // Calculate selected total
  double get selectedSubtotal {
    double total = 0;

    for (var index in cartController.selectedItems) {
      if (index < 0 || index >= cartController.cartItems.length) continue;

      final item = cartController.cartItems[index];
      double price = double.tryParse(item["product"]["price"].toString()) ?? 0;
      int qty = int.tryParse(item["quantity"].toString()) ?? 1;

      total += price * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Get.offAll(() => const HomeScreen()),
        ),
        title: const Text(
          "My Cart",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.purple),
          );
        }

        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text(
              "Your cart is empty 🛒",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  final product = item["product"];
                  final price =
                      double.tryParse(product["price"].toString()) ?? 0;
                  final qty = int.tryParse(item["quantity"].toString()) ?? 1;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        // Checkbox
                        Obx(() {
                          bool isSelected = cartController.selectedItems
                              .contains(index);

                          return Checkbox(
                            value: isSelected,
                            activeColor: Colors.purple,
                            onChanged: (_) =>
                                cartController.toggleSelectItem(index),
                          );
                        }),

                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            "http://10.0.2.2:8000/storage/${product["image"]}",
                            height: 80,
                            width: 80,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Title + Price + Qty
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["title"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "\$${price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.purple,
                                ),
                              ),
                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  _qtyBtn(Icons.remove, () {
                                    cartController.decreaseQuantity(index);
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      "$qty",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _qtyBtn(Icons.add, () {
                                    cartController.increaseQuantity(index);
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Delete
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => cartController.removeItem(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                children: [
                  _summaryRow(
                    "Subtotal",
                    "\$${selectedSubtotal.toStringAsFixed(2)}",
                  ),
                  _summaryRow(
                    "Shipping Fee",
                    "\$${shippingCost.toStringAsFixed(2)}",
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  _summaryRow(
                    "Total",
                    "\$${(selectedSubtotal + shippingCost).toStringAsFixed(2)}",
                    isTotal: true,
                  ),

                  const SizedBox(height: 15),

                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        bool ok = await cartController.checkout();

                        if (ok) {
                          Get.off(() => const OrderConfirmedScreen());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Checkout",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 16),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? Colors.purple : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
