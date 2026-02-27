// lib/models/product.dart

enum ListingType { sale, exchange, both }

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final List<String> imageUrls;
  final List<String>? localImagePaths; // for user uploaded images
  final String sellerName;
  final String sellerLocation;
  final ListingType listingType;
  final DateTime postedAt;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrls,
    this.localImagePaths,
    required this.sellerName,
    required this.sellerLocation,
    required this.listingType,
    required this.postedAt,
    this.isFavorite = false,
  });
}