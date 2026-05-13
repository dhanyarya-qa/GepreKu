import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/product.dart';

// Firestore Instance
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Products Stream Provider
final productsProvider = StreamProvider<List<Product>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  
  return firestore
      .collection('products')
      .orderBy('sales_count', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Product.fromJson({
        'id': doc.id,
        ...doc.data(),
      });
    }).toList();
  });
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
  
  FirebaseFirestore get _firestore => ref.read(firestoreProvider);
  Box get _cacheBox => Hive.box('products_cache');
  
  // Get Product by ID
  Future<Product?> getProductById(String productId) async {
    try {
      final doc = await _firestore
          .collection('products')
          .doc(productId)
          .get();
      
      if (!doc.exists) return null;
      
      return Product.fromJson({
        'id': doc.id,
        ...doc.data()!,
      });
    } catch (e) {
      // Try to get from cache
      final cached = _cacheBox.get(productId);
      if (cached != null) {
        return Product.fromJson(Map<String, dynamic>.from(cached));
      }
      return null;
    }
  }
  
  // Get Recommendations based on product
  Future<List<Product>> getRecommendations(String productId) async {
    try {
      final product = await getProductById(productId);
      if (product == null) return [];
      
      // Get products from same category with high sales
      final snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: product.category)
          .where('id', isNotEqualTo: productId)
          .orderBy('sales_count', descending: true)
          .limit(3)
          .get();
      
      return snapshot.docs.map((doc) {
        return Product.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList();
    } catch (e) {
      return [];
    }
  }
  
  // Cache products for offline mode
  Future<void> cacheProducts(List<Product> products) async {
    for (final product in products) {
      await _cacheBox.put(product.id, product.toJson());
    }
  }
  
  // Get cached products
  List<Product> getCachedProducts() {
    final cached = _cacheBox.values.toList();
    return cached.map((item) {
      return Product.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }
}
