import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

enum OrderStatus {
  pending,
  cooking,
  ready,
  completed,
  cancelled,
}

enum PaymentStatus {
  unpaid,
  paid,
  failed,
}

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String outletId,
    String? tableId,
    required String userId,
    required List<OrderItem> items,
    required double totalAmount,
    required OrderStatus status,
    required PaymentStatus paymentStatus,
    String? paymentTransactionId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

extension OrderExtension on Order {
  bool get isOverdue {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    return status == OrderStatus.pending && diff.inMinutes > 10;
  }
}
