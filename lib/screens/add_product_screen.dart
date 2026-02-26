// lib/screens/add_product_screen.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/mock_data.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedCategory = 'Electronics';
  ListingType _listingType = ListingType.sale;
  bool _isSubmitting = false;

  final List<String> _categories =
      productCategories.where((c) => c != 'All').toList();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));

    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0,
      category: _selectedCategory,
      imageUrl:
          'https://picsum.photos/id/${DateTime.now().second + 100}/400/300',
      sellerName: 'You',
      sellerLocation: _locationController.text.trim(),
      listingType: _listingType,
      postedAt: DateTime.now(),
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.pop(context, newProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Listing',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Image placeholder
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.4),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined,
                      size: 40, color: theme.colorScheme.primary),
                  const SizedBox(height: 8),
                  Text('Photo will be auto assigned',
                      style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600)),
                  Text('from picsum.photos',
                      style:
                          TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Listing Type
            Text('Listing Type',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: ListingType.values.map((type) {
                final labels = {
                  ListingType.sale: 'For Sale',
                  ListingType.exchange: 'Exchange',
                  ListingType.both: 'Both',
                };
                final icons = {
                  ListingType.sale: Icons.sell,
                  ListingType.exchange: Icons.swap_horiz,
                  ListingType.both: Icons.all_inclusive,
                };
                final isSelected = _listingType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _listingType = type),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceVariant
                                .withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(icons[type],
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : Colors.grey),
                          const SizedBox(height: 4),
                          Text(
                            labels[type]!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Product Title *',
                hintText: 'e.g. iPhone 13 Pro 256GB',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Please enter a title' : null,
            ),

            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category *',
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              items: _categories
                  .map((c) =>
                      DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),

            const SizedBox(height: 16),

            // Price
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price (USD) *',
                prefixIcon: const Icon(Icons.attach_money),
                hintText: '0.00',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter a price';
                if (double.tryParse(v) == null) return 'Invalid price';
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description *',
                hintText: 'Describe your item in detail...',
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Icon(Icons.description),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => v == null || v.length < 10
                  ? 'Description must be at least 10 characters'
                  : null,
            ),

            const SizedBox(height: 16),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location *',
                hintText: 'e.g. New York, NY',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Please enter location' : null,
            ),

            const SizedBox(height: 32),

            // Submit
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _submitProduct,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(_isSubmitting ? 'Posting...' : 'Post Listing'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}