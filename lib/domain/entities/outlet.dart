enum OutletStatus { open, closed }

class OperatingHours {
  final String open;
  final String close;

  const OperatingHours({required this.open, required this.close});

  factory OperatingHours.fromJson(Map<String, dynamic> json) {
    return OperatingHours(
      open: json['open'] as String,
      close: json['close'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'open': open, 'close': close};
}

class GeoPoint {
  final double latitude;
  final double longitude;

  const GeoPoint({required this.latitude, required this.longitude});

  factory GeoPoint.fromJson(Map<String, dynamic> json) {
    return GeoPoint(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}

class Outlet {
  final String id;
  final String name;
  final String address;
  final GeoPoint location;
  final Map<String, OperatingHours> operatingHours;
  final OutletStatus status;
  final DateTime createdAt;

  const Outlet({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.operatingHours,
    required this.status,
    required this.createdAt,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      location: GeoPoint.fromJson(json['location'] as Map<String, dynamic>),
      operatingHours: (json['operating_hours'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, OperatingHours.fromJson(v as Map<String, dynamic>)),
      ),
      status: OutletStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OutletStatus.closed,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'location': location.toJson(),
    'operating_hours': operatingHours.map((k, v) => MapEntry(k, v.toJson())),
    'status': status.name,
    'created_at': createdAt.toIso8601String(),
  };
}
