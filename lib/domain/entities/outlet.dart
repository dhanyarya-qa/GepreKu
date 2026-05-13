import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'outlet.freezed.dart';
part 'outlet.g.dart';

enum OutletStatus {
  open,
  closed,
}

@freezed
class Outlet with _$Outlet {
  const factory Outlet({
    required String id,
    required String name,
    required String address,
    required GeoPoint location,
    required Map<String, OperatingHours> operatingHours,
    required OutletStatus status,
    required DateTime createdAt,
  }) = _Outlet;

  factory Outlet.fromJson(Map<String, dynamic> json) => _$OutletFromJson(json);
}

@freezed
class OperatingHours with _$OperatingHours {
  const factory OperatingHours({
    required String open,
    required String close,
  }) = _OperatingHours;

  factory OperatingHours.fromJson(Map<String, dynamic> json) =>
      _$OperatingHoursFromJson(json);
}
