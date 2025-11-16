import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  // ✅ Always get the latest token
  String? get _token {
    final box = GetStorage();
    return box.read('token');
  }

  // ✅ POST request
  Future<Response> postRequest(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: _mergeHeaders(headers)),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ GET request
  Future<Response> getRequest(
    String endpoint, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: params,
        options: Options(headers: _mergeHeaders(headers)),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ PUT request
  Future<Response> putRequest(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        options: Options(headers: _mergeHeaders(headers)),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ DELETE request
  Future<Response> deleteRequest(
    String endpoint, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        options: Options(headers: _mergeHeaders(headers)),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Combine custom headers + authorization
  Map<String, dynamic> _mergeHeaders(Map<String, dynamic>? customHeaders) {
    final Map<String, dynamic> defaultHeaders = {'Accept': 'application/json'};

    // Add token dynamically
    final token = _token;
    if (token != null) {
      defaultHeaders['Authorization'] = 'Bearer $token';
    }

    if (customHeaders != null) {
      defaultHeaders.addAll(customHeaders);
    }

    return defaultHeaders;
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      return error.response?.data['message'] ??
          'Error: ${error.response?.statusCode}';
    } else {
      return 'Connection error: ${error.message}';
    }
  }

  // ✅ Logout request
  Future<void> logout() async {
    try {
      final response = await _dio.post(
        'logout',
        options: Options(headers: _mergeHeaders(null)), // includes token
      );

      print(response.data); // Optional: print for debugging
    } on DioException catch (e) {
      print('Logout failed: ${_handleError(e)}');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get(
        'categories',
        options: Options(headers: _mergeHeaders(null)),
      );

      if (response.statusCode == 200) {
        List data = response.data;

        return data.map<String>((cat) => cat["name"].toString()).toList();
        
      } else {
        throw "Failed to load categories";
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getProducts() async {
    final response = await _dio.get('products');

    if (response.statusCode == 200) {
      List<dynamic> list = response.data;

      // Fix image URL for emulator
      for (var item in list) {
        item["imageUrl"] = item["imageUrl"].toString().replaceAll(
          "127.0.0.1",
          "10.0.2.2",
        );
      }

      return list;
    } else {
      throw Exception("Failed to load products");
    }
  }
}
