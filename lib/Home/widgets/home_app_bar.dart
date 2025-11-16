import 'package:clothes_shop/cart/cart_screen.dart';
import 'package:clothes_shop/controller/cart_controller.dart';
import 'package:clothes_shop/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback openDrawer;
  const HomeAppBar({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row (menu + bag)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 👇 menu button opens drawer
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade100,
                child: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: openDrawer, // ✅ triggers openDrawer()
                ),
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade100,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      ),
                    ),

                    // 🔥 Cart Count Badge
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Obx(() {
                        final cart = Get.find<CartController>();
                        if (cart.cartItems.isEmpty) {
                          return const SizedBox(); // no badge if empty
                        }

                        return Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cart.cartItems.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            "Hello",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Text(
            "Welcome to Laza.",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 20),

          // Search Bar
          Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 10),

                // 🚀 SEARCH FIELD (FIXED)
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      controller.searchProduct(
                        value,
                      ); // 🔥 filter items correctly
                    },
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
