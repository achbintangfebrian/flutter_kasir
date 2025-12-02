import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../models/product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  int? _selectedCategoryId;
  bool _isEditing = false;
  int? _editingProductId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _showProductDialog([Product? product]) {
    if (product != null) {
      _isEditing = true;
      _editingProductId = product.id;
      _nameController.text = product.name ?? '';
      _priceController.text = product.price?.toString() ?? '';
      _stockController.text = product.stock?.toString() ?? '';
      _selectedCategoryId = product.categoryId;
    } else {
      _isEditing = false;
      _editingProductId = null;
      _nameController.clear();
      _priceController.clear();
      _stockController.clear();
      _selectedCategoryId = null;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(hintText: 'Product name'),
                      autofocus: true,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _priceController,
                      decoration: const InputDecoration(hintText: 'Price'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _stockController,
                      decoration: const InputDecoration(hintText: 'Stock'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    Consumer<CategoryProvider>(
                      builder: (context, categoryProvider, child) {
                        return DropdownButtonFormField<int>(
                          value: _selectedCategoryId,
                          hint: const Text('Select Category'),
                          items: categoryProvider.categories.map((category) {
                            return DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(category.name ?? ''),
                            );
                          }).toList() as List<DropdownMenuItem<int>>,
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          },
                        );
                      },
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
                  onPressed: () => _saveProduct(),
                  child: Text(_isEditing ? 'Update' : 'Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveProduct() {
    if (_nameController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _stockController.text.trim().isEmpty ||
        _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final productData = {
      'name': _nameController.text.trim(),
      'price': int.tryParse(_priceController.text.trim()) ?? 0,
      'stock': int.tryParse(_stockController.text.trim()) ?? 0,
      'category_id': _selectedCategoryId,
    };

    if (_isEditing && _editingProductId != null) {
      productProvider.updateProduct(_editingProductId!, productData).then((_) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully')),
        );
      }).catchError((error) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating product: $error')),
        );
      });
    } else {
      productProvider.createProduct(productData).then((_) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );
      }).catchError((error) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding product: $error')),
        );
      });
    }
  }

  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete "${product.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<ProductProvider>(context, listen: false)
                    .deleteProduct(product.id!)
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product deleted successfully')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting product: $error')),
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
    return Consumer2<ProductProvider, CategoryProvider>(
      builder: (context, productProvider, categoryProvider, child) {
        return Scaffold(
          body: productProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => productProvider.fetchProducts(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: productProvider.products.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Products',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _showProductDialog(),
                                icon: const Icon(Icons.add),
                                label: const Text('Add'),
                              ),
                            ],
                          ),
                        );
                      }

                      final product = productProvider.products[index - 1];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(product.name ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_formatCurrency(product.price)),
                              Text('Stock: ${product.stock}'),
                              Text('Category: ${product.category?.name ?? 'N/A'}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showProductDialog(product),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteProduct(product),
                              ),
                            ],
                          ),
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