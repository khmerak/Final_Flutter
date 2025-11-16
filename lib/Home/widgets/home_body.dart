import 'package:clothes_shop/controller/cart_controller.dart';
import 'package:clothes_shop/controller/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clothes_shop/controller/product_controller.dart';
import 'package:get_storage/get_storage.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();
    final WishlistController wishlistController = Get.put(WishlistController());
    // ignore: unused_local_variable
    final CartController cartController = Get.find<CartController>();
    final storage = GetStorage();
    final int userId = storage.read("user_id") ?? 0;

    wishlistController.fetchWishlist(userId);

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.purple),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Brand",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // ===============================
            // BRAND LIST
            // ===============================
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.brands.length,
                separatorBuilder: (_, __) => const SizedBox(width: 20),
                itemBuilder: (context, index) {
                  final brand = controller.brands[index];
                  return GestureDetector(
                    onTap: () => controller.filterByBrand(brand),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          brand,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "New Arrival",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            // ===============================
            // PRODUCT GRID
            // ===============================
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final item = controller.products[index];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          // ===========================
                          // PRODUCT IMAGE (CLICK)
                          // ===========================
                          GestureDetector(
                            onTap: () => showProductDetails(context, item),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: item["image_url"] == null
                                  ? Image.asset(
                                      "assets/images/product.png",
                                      height: 170,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(
                                      item["image_url"],
                                      height: 170,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),

                          // ===========================
                          // ❤️ WISHLIST BUTTON
                          // ===========================
                          Positioned(
                            right: 10,
                            top: 10,
                            child: Obx(() {
                              bool isFav = wishlistController.isFavorite(
                                item['id'],
                              );

                              return InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  if (userId == 0) {
                                    Get.snackbar(
                                      "Please Login",
                                      "Login is required for wishlist",
                                    );
                                    return;
                                  }

                                  wishlistController.toggleFavorite(
                                    userId,
                                    item['id'],
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.black54,
                                    size: 26,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),

                      // ===========================
                      // TITLE & PRICE
                      // ===========================
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] ?? "Unknown Product",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              "\$${item['price']}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4C53A5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

/// ===============================
/// PRODUCT DETAILS POPUP
/// ===============================
void showProductDetails(BuildContext context, Map<String, dynamic> product) {
  final CartController cartController = Get.find<CartController>();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: product["image_url"] == null
                    ? Image.asset(
                        "assets/images/product.png",
                        height: 180,
                        fit: BoxFit.contain,
                      )
                    : Image.network(
                        product["image_url"],
                        height: 180,
                        fit: BoxFit.contain,
                      ),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              product["title"],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "\$${product["price"]}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.purple,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              product["description"] ?? "No description",
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  cartController.addToCart(product["id"]);
                  Navigator.pop(context);

                  Get.snackbar(
                    "Added",
                    "Product added to cart",
                    backgroundColor: Colors.purple,
                    colorText: Colors.white,
                  );
                },
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
