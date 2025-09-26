import 'dart:convert';

/// Modelo para representar uma parada de ônibus
class BusStop {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final List<String> routeIds;
  final bool isActive;
  final DateTime? estimatedArrival;
  final int? passengerCount;

  const BusStop({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.routeIds = const [],
    this.isActive = true,
    this.estimatedArrival,
    this.passengerCount,
  });

  /// Cria uma instância a partir de um Map
  factory BusStop.fromMap(Map<String, dynamic> map) {
    return BusStop(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      address: map['address'] ?? '',
      routeIds: List<String>.from(map['routeIds'] ?? []),
      isActive: map['isActive'] ?? true,
      estimatedArrival: map['estimatedArrival'] != null 
          ? DateTime.tryParse(map['estimatedArrival'])
          : null,
      passengerCount: map['passengerCount']?.toInt(),
    );
  }

  /// Converte para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'routeIds': routeIds,
      'isActive': isActive,
      'estimatedArrival': estimatedArrival?.toIso8601String(),
      'passengerCount': passengerCount,
    };
  }

  /// Converte para JSON
  String toJson() => json.encode(toMap());

  /// Cria uma instância a partir de JSON
  factory BusStop.fromJson(String source) => 
      BusStop.fromMap(json.decode(source));

  /// Cria uma cópia com novos valores
  BusStop copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    List<String>? routeIds,
    bool? isActive,
    DateTime? estimatedArrival,
    int? passengerCount,
  }) {
    return BusStop(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      routeIds: routeIds ?? this.routeIds,
      isActive: isActive ?? this.isActive,
      estimatedArrival: estimatedArrival ?? this.estimatedArrival,
      passengerCount: passengerCount ?? this.passengerCount,
    );
  }

  @override
  String toString() {
    return 'BusStop(id: $id, name: $name, latitude: $latitude, longitude: $longitude, address: $address, routeIds: $routeIds, isActive: $isActive, estimatedArrival: $estimatedArrival, passengerCount: $passengerCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BusStop &&
      other.id == id &&
      other.name == name &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.address == address &&
      other.routeIds == routeIds &&
      other.isActive == isActive &&
      other.estimatedArrival == estimatedArrival &&
      other.passengerCount == passengerCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      address.hashCode ^
      routeIds.hashCode ^
      isActive.hashCode ^
      estimatedArrival.hashCode ^
      passengerCount.hashCode;
  }
}