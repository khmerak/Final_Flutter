import 'package:clothes_shop/controller/cart_controller.dart';
import 'package:clothes_shop/controller/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final WishlistController wishlistController = Get.put(WishlistController());
  final CartController cartController = Get.find<CartController>();

  final storage = GetStorage();
  late int userId;

  @override
  void initState() {
    super.initState();
    userId = storage.read("user_id") ?? 0;
    wishlistController.fetchWishlist(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite"), centerTitle: true),
      body: Obx(() {
        if (wishlistController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (wishlistController.wishlist.isEmpty) {
          return const Center(
            child: Text("No favorites yet ❤️", style: TextStyle(fontSize: 18)),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: wishlistController.wishlist.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (context, index) {
            final item = wishlistController.wishlist[index];

            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  // IMAGE + HEART BUTTON
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Image.network(
                          item.product.imageUrl,
                          height: 120, // ↓ smaller image to avoid overflow
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),

                      Positioned(
                        right: 10,
                        top: 10,
                        child: InkWell(
                          onTap: () {
                            wishlistController.removeFromWishlist(
                              item.id,
                              userId,
                            );
                          },
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // CONTENT
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            item.product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),

                          // Price
                          Text(
                            "\$${item.product.price}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),

                          // ADD TO CART BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 38, // ↓ smaller height prevents overflow
                            child: ElevatedButton(
                              onPressed: () {
                                cartController.addToCart(item.product.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets
                                    .zero, // ↓ Important: remove extra padding
                              ),
                              child: const Text(
                                "Add to Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14, // ↓ slightly smaller text
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
