import 'package:get/get.dart';
import 'package:clothes_shop/helper/api_service.dart';

class ProductController extends GetxController {
  final ApiService api = ApiService();

  // Observables
  var isLoading = true.obs;
  var brands = <String>[].obs;
  var products = <dynamic>[].obs;
  var allProducts = <dynamic>[].obs; // original
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading(true);

      // Fetch categories
      final categoryList = await api.getCategories();
      brands.assignAll(categoryList);
      brands.add("All");

      // Fetch products
      final productList = await api.getProducts();
      products.assignAll(productList);
      allProducts.assignAll(productList); // backup
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      isLoading(false);
    }
  }

  // 🔍 FILTER BY BRAND or CATEGORY
  void filterByBrand(String brand) {
    if (brand == "All") {
      products.assignAll(allProducts);
    } else {
      products.assignAll(
        allProducts.where((item) {
          return item["category"]["name"] == brand;
        }).toList(),
      );
    }
  }

  void searchProduct(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      products.assignAll(allProducts);
      return;
    }

    products.assignAll(
      allProducts.where((item) {
        final title = item["title"].toString().toLowerCase();
        return title.contains(query.toLowerCase());
      }).toList(),
    );
  }
}
