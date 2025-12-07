import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/product_provider.dart';
import '../models/transaction.dart';
import '../models/transaction_item.dart';
import '../models/customer.dart';
import '../models/product.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TextEditingController _quantityController = TextEditingController();
  int? _selectedCustomerId;
  int? _selectedProductId;
  List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
      Provider.of<CustomerProvider>(context, listen: false).fetchCustomers();
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _showCreateTransactionDialog() {
    _selectedCustomerId = null;
    _selectedProductId = null;
    _cartItems.clear();
    _quantityController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Transaction'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Customer selection
                    Consumer<CustomerProvider>(
                      builder: (context, customerProvider, child) {
                        return DropdownButtonFormField<int>(
                          value: _selectedCustomerId,
                          hint: const Text('Select Customer'),
                          items: customerProvider.customers.map((Customer customer) {
                            return DropdownMenuItem<int>(
                              value: customer.id,
                              child: Text(customer.name ?? ''),
                            );
                          }).toList() as List<DropdownMenuItem<int>>,
                          onChanged: (value) {
                            setState(() {
                              _selectedCustomerId = value;
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    // Product selection
                    Consumer<ProductProvider>(
                      builder: (context, productProvider, child) {
                        return Column(
                          children: [
                            DropdownButtonFormField<int>(
                              value: _selectedProductId,
                              hint: const Text('Select Product'),
                              items: productProvider.products.map((Product product) {
                                return DropdownMenuItem<int>(
                                  value: product.id,
                                  child: Text('${product.name} (${product.stock} in stock)'),
                                );
                              }).toList() as List<DropdownMenuItem<int>>,
                              onChanged: (value) {
                                setState(() {
                                  _selectedProductId = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _quantityController,
                              decoration: const InputDecoration(hintText: 'Quantity'),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _selectedProductId != null &&
                                      _quantityController.text.isNotEmpty
                                  ? () {
                                      final product = productProvider.products
                                          .firstWhere((p) => p.id == _selectedProductId);
                                      final quantity =
                                          int.tryParse(_quantityController.text) ?? 0;
                                      
                                      if (quantity > 0 && quantity <= (product.stock ?? 0)) {
                                        setState(() {
                                          _cartItems.add({
                                            'product': product,
                                            'quantity': quantity,
                                            'price': product.price,
                                            'subtotal':
                                                (product.price ?? 0) * quantity,
                                          });
                                        });
                                        _quantityController.clear();
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Invalid quantity or not enough stock')),
                                        );
                                      }
                                    }
                                  : null,
                              child: const Text('Add to Cart'),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    // Cart items
                    if (_cartItems.isNotEmpty)
                      Column(
                        children: [
                          const Text('Cart Items:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 150,
                            child: ListView.builder(
                              itemCount: _cartItems.length,
                              itemBuilder: (context, index) {
                                final item = _cartItems[index];
                                final product = item['product'] as Product;
                                final quantity = item['quantity'] as int;
                                final subtotal = item['subtotal'] as int;
                                
                                return Card(
                                  child: ListTile(
                                    title: Text(product.name ?? ''),
                                    subtitle: Text(
                                        'Qty: $quantity, Subtotal: ${_formatCurrency(subtotal)}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          _cartItems.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: _cartItems.isNotEmpty && _selectedCustomerId != null
                      ? () => _saveTransaction()
                      : null,
                  child: const Text('Create Transaction'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveTransaction() {
    if (_selectedCustomerId == null || _cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer and add items to cart')),
      );
      return;
    }

    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    
    final items = _cartItems.map((item) {
      final product = item['product'] as Product;
      final quantity = item['quantity'] as int;
      final price = item['price'] as int;
      final subtotal = item['subtotal'] as int;
      
      return {
        'product_id': product.id,
        'quantity': quantity,
        'price': price,
        'subtotal': subtotal,
      };
    }).toList();

    final total = _cartItems.fold(0, (sum, item) => sum + (item['subtotal'] as int));

    final transactionData = {
      'customer_id': _selectedCustomerId,
      'items': items,
      'total': total,
    };

    transactionProvider.createTransaction(transactionData).then((_) {
      if (!mounted) return;
      Navigator.pop(context);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction created successfully')),
      );
    }).catchError((error) {
      if (!mounted) return;
      Navigator.pop(context);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating transaction: $error')),
      );
    });
  }

  void _deleteTransaction(Transaction transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Transaction'),
          content: Text(
              'Are you sure you want to delete transaction #${transaction.id}? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<TransactionProvider>(context, listen: false)
                    .deleteTransaction(transaction.id!)
                    .then((_) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transaction deleted successfully')),
                  );
                }).catchError((error) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting transaction: $error')),
                  );
                });
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  String _formatCurrency(int? amount) {
    if (amount == null) return 'Rp 0';
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<TransactionProvider, CustomerProvider, ProductProvider>(
      builder: (context, transactionProvider, customerProvider, productProvider, child) {
        return Scaffold(
          body: transactionProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => transactionProvider.fetchTransactions(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: transactionProvider.transactions.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Transactions',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _showCreateTransactionDialog(),
                                icon: const Icon(Icons.add),
                                label: const Text('New'),
                              ),
                            ],
                          ),
                        );
                      }

                      final transaction = transactionProvider.transactions[index - 1];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ExpansionTile(
                          title: Text('Transaction #${transaction.id}'),
                          subtitle: Text(
                              '${transaction.customer?.name ?? 'Unknown Customer'} - ${_formatCurrency(transaction.total)}'),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Customer: ${transaction.customer?.name ?? 'N/A'}',
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  Text('Date: ${transaction.createdAt?.split('T').first ?? 'N/A'}'),
                                  const SizedBox(height: 10),
                                  const Text('Items:',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  ...?transaction.items?.map((item) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 5.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                                '${item.product?.name ?? 'Unknown Product'}'),
                                          ),
                                          Text(
                                              'Qty: ${item.quantity}, ${_formatCurrency(item.subtotal)}'),
                                        ],
                                      ),
                                    );
                                  }),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total:',
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(_formatCurrency(transaction.total),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 16)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _deleteTransaction(transaction),
                                      icon: const Icon(Icons.delete, size: 18),
                                      label: const Text('Delete'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}