class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String? model3dUrl;
  final String fallbackImageUrl;
  final int salesCount;
  final bool isSpicy;
  final Map<String, int> stockByOutlet;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.model3dUrl,
    required this.fallbackImageUrl,
    required this.salesCount,
    required this.isSpicy,
    required this.stockByOutlet,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      model3dUrl: json['model_3d_url'] as String?,
      fallbackImageUrl: json['fallback_image_url'] as String,
      salesCount: json['sales_count'] as int,
      isSpicy: json['is_spicy'] as bool,
      stockByOutlet: Map<String, int>.from(json['stock_by_outlet'] as Map),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'model_3d_url': model3dUrl,
      'fallback_image_url': fallbackImageUrl,
      'sales_count': salesCount,
      'is_spicy': isSpicy,
      'stock_by_outlet': stockByOutlet,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
