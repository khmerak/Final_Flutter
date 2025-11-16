import 'dart:convert';
import 'package:clothes_shop/model/category_model.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  final String baseUrl = "http://127.0.0.1:8000/api";

  List<CategoryModel> brands = [];
  String? selectedBrand;

  Future<void> loadCategories() async {
    final url = Uri.parse("$baseUrl/categories");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      brands = data
          .map<CategoryModel>((cat) => CategoryModel.fromJson(cat))
          .toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }

  void filterByBrand(String brandName) {
    selectedBrand = brandName;
  }
}
