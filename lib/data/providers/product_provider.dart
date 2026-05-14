import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';

// Mock Products Provider
final productsProvider = StreamProvider<List<Product>>((ref) {
  // Return mock products
  return Stream.value(_mockProducts);
});

// Best Sellers Provider (Top 5)
final bestSellersProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider);
  
  return products.when(
    data: (list) => list.take(5).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Products by Category Provider
final productsByCategoryProvider = Provider.family<List<Product>, String>((ref, category) {
  final products = ref.watch(productsProvider);
  
  return products.when(
    data: (list) => list.where((p) => p.category == category).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Product Service
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService(ref);
});

class ProductService {
  final Ref ref;
  
  ProductService(this.ref);
  
  // Get Product by ID
  Future<Product?> getProductById(String productId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockProducts.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }
  
  // Get Recommendations based on product
  Future<List<Product>> getRecommendations(String productId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final product = await getProductById(productId);
      if (product == null) return [];
      
      // Get products from same category
      return _mockProducts
          .where((p) => p.category == product.category && p.id != productId)
          .take(3)
          .toList();
    } catch (e) {
      return [];
    }
  }
}

// Mock Data
final List<Product> _mockProducts = [
  Product(
    id: 'prod_001',
    name: 'Ayam Geprek Original',
    description: 'Ayam goreng crispy dengan sambal geprek level 1-10',
    category: 'Main Course',
    price: 25000,
    model3dUrl: null,
    fallbackImageUrl: 'https://via.placeholder.com/300x200?text=Ayam+Geprek',
    salesCount: 150,
    isSpicy: true,
    stockByOutlet: {'outlet_001': 50},
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: 'prod_002',
    name: 'Ayam Geprek Keju',
    description: 'Ayam geprek dengan topping keju mozarella',
    category: 'Main Course',
    price: 30000,
    model3dUrl: null,
    fallbackImageUrl: 'https://via.placeholder.com/300x200?text=Ayam+Geprek+Keju',
    salesCount: 120,
    isSpicy: true,
    stockByOutlet: {'outlet_001': 40},
    createdAt: DateTime.now().subtract(const Duration(days: 25)),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: 'prod_003',
    name: 'Nasi Goreng Spesial',
    description: 'Nasi goreng dengan telur, ayam, dan sayuran',
    category: 'Main Course',
    price: 20000,
    model3dUrl: null,
    fallbackImageUrl: 'https://via.placeholder.com/300x200?text=Nasi+Goreng',
    salesCount: 100,
    isSpicy: false,
    stockByOutlet: {'outlet_001': 60},
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: 'prod_004',
    name: 'Es Teh Jumbo',
    description: 'Es teh manis ukuran jumbo',
    category: 'Beverages',
    price: 8000,
    model3dUrl: null,
    fallbackImageUrl: 'https://via.placeholder.com/300x200?text=Es+Teh',
    salesCount: 200,
    isSpicy: false,
    stockByOutlet: {'outlet_001': 100},
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: 'prod_005',
    name: 'Jus Alpukat',
    description: 'Jus alpukat segar dengan susu',
    category: 'Beverages',
    price: 15000,
    model3dUrl: null,
    fallbackImageUrl: 'https://via.placeholder.com/300x200?text=Jus+Alpukat',
    salesCount: 80,
    isSpicy: false,
    stockByOutlet: {'outlet_001': 30},
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    updatedAt: DateTime.now(),
  ),
];
