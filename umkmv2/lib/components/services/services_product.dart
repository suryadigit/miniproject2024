// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';

import '../preferences/user.dart';
 
class ProductService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://yhvagkgcvehcbsexctmh.supabase.co/rest/v1/';
  final String _apiKey = '';

  Future<Response> getProduct() async {
    final id = await UserPreferences.getUserId();
    final String apiUrl = '${_baseUrl}product?select=*&userId=eq.$id';

    final response = await _dio.get(
      apiUrl,
      options: Options(
        headers: {
          'apikey': _apiKey,
          'Authorization': 'Bearer $_apiKey',
        },
      ),
    );

    return response;
  }

  Future<Response> addProduct(
    String userId,
    String title,
    String description,
    double price,
    int stock,
    int productCode,
  ) async {
    final String apiUrl = '${_baseUrl}product';

    final Map<String, dynamic> data = {
      'userId': userId,
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'productCode': productCode,
    };

    try {
      final Response response = await _dio.post(
        apiUrl,
        data: data,
        options: Options(
          headers: {
            'apikey': _apiKey,
            'Authorization': 'Bearer $_apiKey',
          },
        ),
      );
      return response;
    } catch (error) {
      throw Exception('Gagal menambahkan produk: $error');
    }
  }

  Future<Response> editProduct(
    int id,
    String userId,
    String title,
    String description,
    double price,
    int stock,
    int productCode,
  ) async {
    final String apiUrl = '${_baseUrl}product?id=eq.$id';

    final Map<String, dynamic> data = {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'productCode': productCode,
    };

    try {
      final Response response = await _dio.patch(
        apiUrl,
        data: data,
        options: Options(
          headers: {
            'apikey': _apiKey,
            'Authorization': 'Bearer $_apiKey',
          },
        ),
      );
      return response;
    } catch (error) {
      throw Exception('Gagal memperbarui produk: $error');
    }
  }

  Future<Response> deleteProduct(int id) async {
    final String apiUrl = '${_baseUrl}product?id=eq.$id';
    try {
      final Response response = await _dio.delete(
        apiUrl,
        options: Options(
          headers: {
            'apikey': _apiKey,
            'Authorization': 'Bearer $_apiKey',
          },
        ),
      );
      return response;
    } catch (error) {
      throw Exception('Gagal menghapus produk dengan ID $id. Error: $error');
    }
  }
}
