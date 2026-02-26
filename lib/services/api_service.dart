// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';

  // Get token from storage
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Headers with auth
  static Future<Map<String, String>> _authHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ─── PRODUCTS ───────────────────────────────

  static Future<List<Product>> getProducts({
    String? category,
    String? search,
  }) async {
    String url = '$baseUrl/products?';
    if (category != null && category != 'All') url += 'category=$category&';
    if (search != null && search.isNotEmpty) url += 'search=$search';

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((p) => Product(
        id: p['_id'],
        title: p['title'],
        description: p['description'],
        price: p['price'].toDouble(),
        category: p['category'],
        imageUrl: p['imageUrl'] ?? '',
        sellerName: p['sellerName'],
        sellerLocation: p['sellerLocation'],
        listingType: _parseListingType(p['listingType']),
        postedAt: DateTime.parse(p['createdAt']),
      )).toList();
    }
    throw Exception('Failed to load products');
  }

  static Future<Product> createProduct(Map<String, dynamic> data) async {
    final headers = await _authHeaders();
    final res = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: headers,
      body: jsonEncode(data),
    );
    if (res.statusCode == 201) {
      final p = jsonDecode(res.body);
      return Product(
        id: p['_id'],
        title: p['title'],
        description: p['description'],
        price: p['price'].toDouble(),
        category: p['category'],
        imageUrl: p['imageUrl'] ?? '',
        sellerName: p['sellerName'],
        sellerLocation: p['sellerLocation'],
        listingType: _parseListingType(p['listingType']),
        postedAt: DateTime.parse(p['createdAt']),
      );
    }
    throw Exception('Failed to create product');
  }

  // ─── OFFERS ─────────────────────────────────

  static Future<void> makeOffer({
    required String productId,
    required double offerPrice,
    required String buyerName,
  }) async {
    final headers = await _authHeaders();
    final res = await http.post(
      Uri.parse('$baseUrl/offers'),
      headers: headers,
      body: jsonEncode({
        'productId': productId,
        'offerPrice': offerPrice,
        'buyerName': buyerName,
      }),
    );
    if (res.statusCode != 201) throw Exception('Failed to send offer');
  }

  // ─── HELPER ─────────────────────────────────

  static ListingType _parseListingType(String type) {
    switch (type) {
      case 'exchange':
        return ListingType.exchange;
      case 'both':
        return ListingType.both;
      default:
        return ListingType.sale;
    }
  }
}