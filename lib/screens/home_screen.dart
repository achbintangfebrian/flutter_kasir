import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/transaction_provider.dart';
import 'category_screen.dart';
import 'product_screen.dart';
import 'customer_screen.dart';
import 'transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    CategoryScreen(),
    ProductScreen(),
    CustomerScreen(),
    TransactionScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Cashier'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Transactions',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<CategoryProvider, ProductProvider, CustomerProvider, TransactionProvider>(
      builder: (context, categoryProvider, productProvider, customerProvider, transactionProvider, child) {
        // Load data when the dashboard is accessed
        if (!categoryProvider.isLoading && categoryProvider.categories.isEmpty) {
          categoryProvider.fetchCategories();
        }
        if (!productProvider.isLoading && productProvider.products.isEmpty) {
          productProvider.fetchProducts();
        }
        if (!customerProvider.isLoading && customerProvider.customers.isEmpty) {
          customerProvider.fetchCustomers();
        }
        if (!transactionProvider.isLoading && transactionProvider.transactions.isEmpty) {
          transactionProvider.fetchTransactions();
        }
        if (!productProvider.isLoading && productProvider.recommendations.isEmpty) {
          productProvider.fetchRecommendations();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.category, size: 40, color: Colors.blue),
                            const SizedBox(height: 10),
                            const Text('Categories', style: TextStyle(fontSize: 16)),
                            Text('${categoryProvider.categories.length}', 
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.inventory, size: 40, color: Colors.blue),
                            const SizedBox(height: 10),
                            const Text('Products', style: TextStyle(fontSize: 16)),
                            Text('${productProvider.products.length}', 
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.people, size: 40, color: Colors.blue),
                            const SizedBox(height: 10),
                            const Text('Customers', style: TextStyle(fontSize: 16)),
                            Text('${customerProvider.customers.length}', 
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.receipt, size: 40, color: Colors.blue),
                            const SizedBox(height: 10),
                            const Text('Transactions', style: TextStyle(fontSize: 16)),
                            Text('${transactionProvider.transactions.length}', 
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Recommendations section
              const Text(
                'Top Recommendations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (productProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (productProvider.recommendations.isEmpty)
                const Text('No recommendations available')
              else
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.recommendations.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.recommendations[index];
                      return Card(
                        margin: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          width: 150,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Rp ${product.price?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Stock: ${product.stock}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}