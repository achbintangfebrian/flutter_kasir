import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/transaction_provider.dart';
import 'category_screen.dart';
import 'product_screen.dart';
import 'customer_screen.dart';
import 'transaction_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      await apiService.logout();
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('HomeScreen: Building widget, selectedIndex: $_selectedIndex');
    
    // Define widget options inside build method to avoid forward reference issues
    final List<Widget> widgetOptions = [
      const DashboardScreen(),
      const CategoryScreen(),
      const ProductScreen(),
      const CustomerScreen(),
      const TransactionScreen(),
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Cashier'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: widgetOptions.elementAt(_selectedIndex),
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('DashboardScreen: didChangeDependencies called, isInitialized: $_isInitialized');
    
    if (!_isInitialized) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        print('DashboardScreen: addPostFrameCallback executed');
        try {
          final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
          final productProvider = Provider.of<ProductProvider>(context, listen: false);
          final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
          final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
          
          // Load data when the dashboard is accessed
          try {
            if (!categoryProvider.isLoading && categoryProvider.categories.isEmpty) {
              print('DashboardScreen: Loading categories');
              await categoryProvider.fetchCategories();
            }
          } catch (e) {
            print('DashboardScreen: Error loading categories: $e');
          }
          
          try {
            if (!productProvider.isLoading && productProvider.products.isEmpty) {
              print('DashboardScreen: Loading products');
              await productProvider.fetchProducts();
            }
          } catch (e) {
            print('DashboardScreen: Error loading products: $e');
          }
          
          try {
            if (!customerProvider.isLoading && customerProvider.customers.isEmpty) {
              print('DashboardScreen: Loading customers');
              await customerProvider.fetchCustomers();
            }
          } catch (e) {
            print('DashboardScreen: Error loading customers: $e');
          }
          
          try {
            if (!transactionProvider.isLoading && transactionProvider.transactions.isEmpty) {
              print('DashboardScreen: Loading transactions');
              await transactionProvider.fetchTransactions();
            }
          } catch (e) {
            print('DashboardScreen: Error loading transactions: $e');
          }
          
          try {
            if (!productProvider.isLoading && productProvider.recommendations.isEmpty) {
              print('DashboardScreen: Loading recommendations');
              await productProvider.fetchRecommendations();
            }
          } catch (e) {
            print('DashboardScreen: Error loading recommendations: $e');
          }
        } catch (e, stackTrace) {
          print('DashboardScreen: Error accessing providers: $e');
          print('DashboardScreen: Stack trace: $stackTrace');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('DashboardScreen: Building widget');
    // Use nested Consumers instead of Consumer4 which doesn't exist
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            return Consumer<CustomerProvider>(
              builder: (context, customerProvider, child) {
                return Consumer<TransactionProvider>(
                  builder: (context, transactionProvider, child) {
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
              },
            );
          },
        );
      },
    );
  }
}