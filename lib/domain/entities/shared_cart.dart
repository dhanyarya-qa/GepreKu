import 'package:freezed_annotation/freezed_annotation.dart';
import 'cart_item.dart';

part 'shared_cart.freezed.dart';
part 'shared_cart.g.dart';

@freezed
class SharedCart with _$SharedCart {
  const factory SharedCart({
    required String id,
    required String outletId,
    required String tableId,
    required String ownerId,
    required List<String> participantIds,
    required Map<String, CartItem> items,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SharedCart;

  factory SharedCart.fromJson(Map<String, dynamic> json) =>
      _$SharedCartFromJson(json);
}

extension SharedCartExtension on SharedCart {
  double get totalAmount {
    return items.values.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  int get totalItems {
    return items.values.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }
}
