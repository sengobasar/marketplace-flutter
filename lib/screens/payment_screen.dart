// lib/screens/payment_screen.dart

import 'package:flutter/material.dart';
import '../models/product.dart';

class PaymentScreen extends StatefulWidget {
  final Product product;
  const PaymentScreen({super.key, required this.product});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  int _selectedPaymentMethod = 0;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'label': 'Credit / Debit Card', 'icon': Icons.credit_card},
    {'label': 'PayPal', 'icon': Icons.account_balance_wallet},
    {'label': 'Apple Pay', 'icon': Icons.phone_iphone},
  ];

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod == 0 && !_formKey.currentState!.validate()) {
      return;
    }

    // Show confirmation dialog first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lock, color: Colors.green),
            SizedBox(width: 8),
            Text('Confirm Payment'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to purchase:'),
            const SizedBox(height: 8),
            Text(
              widget.product.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: Colors.green),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user, color: Colors.green, size: 16),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'This transaction is protected by 256-bit SSL encryption.',
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirm & Pay'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);

    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isProcessing = false);

    // Success dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'You have successfully purchased\n${widget.product.title}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${widget.product.price.toStringAsFixed(2)} charged',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green),
            ),
            const SizedBox(height: 4),
            const Text(
              'Transaction ID: TXN-2024-MOCK-7821',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close payment screen
              Navigator.pop(context); // go back to home
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: Colors.green,
            ),
            child: const Text('Back to Marketplace'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          maxLength: 19,
          decoration: InputDecoration(
            labelText: 'Card Number',
            prefixIcon: const Icon(Icons.credit_card),
            hintText: '1234 5678 9012 3456',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            counterText: '',
          ),
          onChanged: (value) {
            final digits = value.replaceAll(' ', '');
            final formatted = StringBuffer();
            for (int i = 0; i < digits.length; i++) {
              if (i > 0 && i % 4 == 0) formatted.write(' ');
              formatted.write(digits[i]);
            }
            final newVal = formatted.toString();
            if (newVal != value) {
              _cardNumberController.value = TextEditingValue(
                text: newVal,
                selection: TextSelection.collapsed(offset: newVal.length),
              );
            }
          },
          validator: (v) {
            if (v == null || v.replaceAll(' ', '').length < 16) {
              return 'Enter a valid 16-digit card number';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _cardNameController,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: 'Cardholder Name',
            prefixIcon: const Icon(Icons.person_outline),
            hintText: 'JOHN DOE',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? 'Enter cardholder name' : null,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                keyboardType: TextInputType.number,
                maxLength: 5,
                decoration: InputDecoration(
                  labelText: 'MM/YY',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  counterText: '',
                ),
                onChanged: (value) {
                  if (value.length == 2 && !value.contains('/')) {
                    _expiryController.text = '$value/';
                    _expiryController.selection = TextSelection.collapsed(
                        offset: _expiryController.text.length);
                  }
                },
                validator: (v) =>
                    v == null || v.length < 5 ? 'Invalid expiry' : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                keyboardType: TextInputType.number,
                maxLength: 3,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'CVV',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  counterText: '',
                ),
                validator: (v) =>
                    v == null || v.length < 3 ? 'Invalid CVV' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;
    final double fee = product.price * 0.02;
    final double total = product.price + fee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Checkout',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isProcessing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text('Processing Payment...',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Please do not close the app',
                      style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Order summary card
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order Summary',
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 60,
                                    height: 60,
                                    color:
                                        theme.colorScheme.surfaceVariant,
                                    child: const Icon(Icons.image),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(product.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(product.sellerName,
                                        style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          _summaryRow(
                              'Item Price',
                              '\$${product.price.toStringAsFixed(2)}'),
                          const SizedBox(height: 6),
                          _summaryRow(
                              'Service Fee (2%)',
                              '\$${fee.toStringAsFixed(2)}'),
                          const Divider(height: 16),
                          _summaryRow(
                            'Total',
                            '\$${total.toStringAsFixed(2)}',
                            bold: true,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Payment Method Selection
                  Text('Payment Method',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...List.generate(_paymentMethods.length, (index) {
                    final method = _paymentMethods[index];
                    final isSelected = _selectedPaymentMethod == index;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedPaymentMethod = index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline
                                    .withOpacity(0.3),
                            width: isSelected ? 2 : 1,
                          ),
                          color: isSelected
                              ? theme.colorScheme.primaryContainer
                                  .withOpacity(0.3)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              method['icon'] as IconData,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              method['label'] as String,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : null,
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              Icon(Icons.check_circle,
                                  color: theme.colorScheme.primary),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Card form (only for card payment)
                  if (_selectedPaymentMethod == 0) _buildCardForm(),

                  const SizedBox(height: 32),

                  // Security badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _securityBadge(Icons.lock, 'SSL Secured'),
                      const SizedBox(width: 16),
                      _securityBadge(Icons.verified_user, 'Buyer Protection'),
                      const SizedBox(width: 16),
                      _securityBadge(Icons.replay, 'Easy Returns'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Pay Button
                  FilledButton.icon(
                    onPressed: _processPayment,
                    icon: const Icon(Icons.lock),
                    label: Text(
                        'Pay \$${total.toStringAsFixed(2)} Securely'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      backgroundColor: Colors.green,
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

  Widget _summaryRow(String label, String value,
      {bool bold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color,
              fontSize: bold ? 16 : 14,
            )),
      ],
    );
  }

  Widget _securityBadge(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[400], size: 20),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(color: Colors.grey[400], fontSize: 10)),
      ],
    );
  }
}