import 'cart_item.dart';

class SharedCart {
  final String id;
  final String outletId;
  final String tableId;
  final String ownerId;
  final List<String> participantIds;
  final Map<String, CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SharedCart({
    required this.id,
    required this.outletId,
    required this.tableId,
    required this.ownerId,
    required this.participantIds,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalAmount =>
      items.values.fold(0.0, (sum, item) => sum + item.subtotal);

  int get totalItems =>
      items.values.fold(0, (sum, item) => sum + item.quantity);

  factory SharedCart.fromJson(Map<String, dynamic> json) {
    return SharedCart(
      id: json['id'] as String,
      outletId: json['outlet_id'] as String,
      tableId: json['table_id'] as String,
      ownerId: json['owner_id'] as String,
      participantIds: List<String>.from(json['participant_ids'] as List),
      items: (json['items'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, CartItem.fromJson(v as Map<String, dynamic>)),
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'outlet_id': outletId,
    'table_id': tableId,
    'owner_id': ownerId,
    'participant_ids': participantIds,
    'items': items.map((k, v) => MapEntry(k, v.toJson())),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
