import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_request.freezed.dart';
part 'service_request.g.dart';

enum ServiceCategory {
  tisu,
  alatMakan,
  air,
  bantuanLain,
}

enum ServiceStatus {
  pending,
  completed,
}

@freezed
class ServiceRequest with _$ServiceRequest {
  const factory ServiceRequest({
    required String id,
    required String outletId,
    required String tableId,
    required ServiceCategory category,
    required ServiceStatus status,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _ServiceRequest;

  factory ServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestFromJson(json);
}

extension ServiceCategoryExtension on ServiceCategory {
  String get displayName {
    switch (this) {
      case ServiceCategory.tisu:
        return 'Tisu';
      case ServiceCategory.alatMakan:
        return 'Alat Makan';
      case ServiceCategory.air:
        return 'Air';
      case ServiceCategory.bantuanLain:
        return 'Bantuan Lain';
    }
  }
}
