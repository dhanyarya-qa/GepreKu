class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final int? spiceLevel;
  final String? addedBy;
  final String? addedByName;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.spiceLevel,
    this.addedBy,
    this.addedByName,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      spiceLevel: json['spice_level'] as int?,
      addedBy: json['added_by'] as String?,
      addedByName: json['added_by_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'product_name': productName,
    'quantity': quantity,
    'price': price,
    'spice_level': spiceLevel,
    'added_by': addedBy,
    'added_by_name': addedByName,
  };

  OrderItem copyWith({
    int? quantity,
    int? spiceLevel,
  }) {
    return OrderItem(
      productId: productId,
      productName: productName,
      quantity: quantity ?? this.quantity,
      price: price,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      addedBy: addedBy,
      addedByName: addedByName,
    );
  }
}
