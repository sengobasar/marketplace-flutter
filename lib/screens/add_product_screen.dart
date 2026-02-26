// lib/screens/add_product_screen.dart

import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  // Image picking
  XFile? _pickedImageFile;
  Uint8List? _webImageBytes;
  String? _localImagePath;

  final List<String> _categories =
      productCategories.where((c) => c != 'All').toList();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image =
          await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (image == null) return;

      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _pickedImageFile = image;
          _webImageBytes = bytes;
          _localImagePath = image.path;
        });
      } else {
        setState(() {
          _pickedImageFile = image;
          _localImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick image: $e')),
        );
      }
    }
  }

  Widget _buildImagePreview() {
    final theme = Theme.of(context);

    if (_pickedImageFile != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: kIsWeb && _webImageBytes != null
                ? Image.memory(
                    _webImageBytes!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    _pickedImageFile!.path,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => setState(() {
                _pickedImageFile = null;
                _webImageBytes = null;
                _localImagePath = null;
              }),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child:
                    const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: const Row(
                  children: [
                    Icon(Icons.edit, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('Change',
                        style:
                            TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    // No image selected yet
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
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
            Text('Tap to add photos',
                style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600)),
            Text('Choose from gallery',
                style:
                    TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
      ),
    );
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
      imageUrl: 'https://picsum.photos/id/100/400/300',
      localImagePath: _localImagePath,
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
            // Image Picker
            _buildImagePreview(),

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