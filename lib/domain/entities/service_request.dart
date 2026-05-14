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

class ServiceRequest {
  final String id;
  final String outletId;
  final String tableId;
  final ServiceCategory category;
  final ServiceStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const ServiceRequest({
    required this.id,
    required this.outletId,
    required this.tableId,
    required this.category,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'] as String,
      outletId: json['outlet_id'] as String,
      tableId: json['table_id'] as String,
      category: ServiceCategory.values.firstWhere(
        (e) => e.toString() == 'ServiceCategory.${json['category']}',
      ),
      status: ServiceStatus.values.firstWhere(
        (e) => e.toString() == 'ServiceStatus.${json['status']}',
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'outlet_id': outletId,
      'table_id': tableId,
      'category': category.toString().split('.').last,
      'status': status.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
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
