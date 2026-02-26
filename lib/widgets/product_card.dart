// lib/widgets/product_card.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  Color _badgeColor(ListingType type) {
    switch (type) {
      case ListingType.sale:
        return Colors.green;
      case ListingType.exchange:
        return Colors.orange;
      case ListingType.both:
        return Colors.blue;
    }
  }

  String _badgeLabel(ListingType type) {
    switch (type) {
      case ListingType.sale:
        return 'For Sale';
      case ListingType.exchange:
        return 'Exchange';
      case ListingType.both:
        return 'Sale / Exchange';
    }
  }

  Widget _buildImage(BuildContext context) {
    final theme = Theme.of(context);

    // If user uploaded a local image
    if (product.localImagePath != null && product.localImagePath!.isNotEmpty) {
      if (kIsWeb) {
        return Image.network(
          product.localImagePath!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(theme),
        );
      } else {
        return Image.file(
          File(product.localImagePath!),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(theme),
        );
      }
    }

    // Default network image
    return Image.network(
      product.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: theme.colorScheme.surfaceVariant,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (_, __, ___) => _placeholder(theme),
    );
  }

  Widget _placeholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceVariant,
      child: const Icon(Icons.image_not_supported, size: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: _buildImage(context),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _badgeColor(product.listingType),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _badgeLabel(product.listingType),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: product.isFavorite
                            ? Colors.red
                            : Colors.grey[600],
                        size: 18,
                      ),
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
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          product.sellerLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}