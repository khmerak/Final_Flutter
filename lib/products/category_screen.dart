import 'package:clothes_shop/Home/home_screen.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        "image": "assets/images/product1.png",
        "title": "Nike Sportswear Club Fleece",
        "price": "\$99",
      },
      {
        "image": "assets/images/product2.png",
        "title": "Trail Running Jacket Nike Windrunner",
        "price": "\$99",
      },
      {
        "image": "assets/images/product3.png",
        "title": "Training Top Nike Sport Clash",
        "price": "\$99",
      },
      {
        "image": "assets/images/product.png",
        "title": "Trail Running Jacket Nike Windrunner",
        "price": "\$99",
      },
    ];
    String selectedSort = 'Newest';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 👈 Back Button
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                ),
              ),

              // 🏷️ Brand Logo
              Image.asset("assets/images/Nike.png", height: 28),

              // 👜 Bag Icon
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade100,
                child: IconButton(
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧾 Title + Subtitle + Sort Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "365 Items",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Available in stock",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedSort,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black87,
                      ),
                      dropdownColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Newest',
                          child: Text('Newest'),
                        ),
                        DropdownMenuItem(
                          value: 'Lowest Price',
                          child: Text('Lowest Price'),
                        ),
                        DropdownMenuItem(
                          value: 'Highest Price',
                          child: Text('Highest Price'),
                        ),
                        DropdownMenuItem(
                          value: 'Most Popular',
                          child: Text('Most Popular'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          // you can add sorting logic here later
                          
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🧥 Product Grid
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final item = products[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.asset(
                                item['image']!,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: 170,
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: GestureDetector(
                                onTap: () {},
                                child: const Icon(
                                  Icons.favorite_border,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title']!.length > 20
                                    ? "${item['title']!.substring(0, 20)}..."
                                    : item['title']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                item['price']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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
            ),
          ],
        ),
      ),
    );
  }
}
