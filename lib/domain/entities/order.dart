import 'order_item.dart';

enum OrderStatus { pending, cooking, ready, completed, cancelled }

enum PaymentStatus { unpaid, paid, failed }

class Order {
  final String id;
  final String outletId;
  final String? tableId;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String? paymentTransactionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.outletId,
    this.tableId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    this.paymentTransactionId,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOverdue =>
      status == OrderStatus.pending &&
      DateTime.now().difference(createdAt).inMinutes > 10;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      outletId: json['outlet_id'] as String,
      tableId: json['table_id'] as String?,
      userId: json['user_id'] as String,
      items: (json['items'] as List)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == json['payment_status'],
        orElse: () => PaymentStatus.unpaid,
      ),
      paymentTransactionId: json['payment_transaction_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'outlet_id': outletId,
    'table_id': tableId,
    'user_id': userId,
    'items': items.map((e) => e.toJson()).toList(),
    'total_amount': totalAmount,
    'status': status.name,
    'payment_status': paymentStatus.name,
    'payment_transaction_id': paymentTransactionId,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
