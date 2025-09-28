import 'dart:convert';

/// Modelo para representar a localização de um ônibus
class BusLocation {
  final String busId;
  final double latitude;
  final double longitude;
  final String routeName;
  final DateTime timestamp;
  final double speed;
  final String direction;
  final String status; // 'moving', 'stopped', 'idle'

  const BusLocation({
    required this.busId,
    required this.latitude,
    required this.longitude,
    required this.routeName,
    required this.timestamp,
    this.speed = 0.0,
    this.direction = 'N',
    this.status = 'idle',
  });

  /// Cria uma instância a partir de um Map
  factory BusLocation.fromMap(Map<String, dynamic> map) {
    return BusLocation(
      busId: map['busId'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      routeName: map['routeName'] ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      speed: (map['speed'] ?? 0.0).toDouble(),
      direction: map['direction'] ?? 'N',
      status: map['status'] ?? 'idle',
    );
  }

  /// Converte para Map
  Map<String, dynamic> toMap() {
    return {
      'busId': busId,
      'latitude': latitude,
      'longitude': longitude,
      'routeName': routeName,
      'timestamp': timestamp.toIso8601String(),
      'speed': speed,
      'direction': direction,
      'status': status,
    };
  }

  /// Converte para JSON
  String toJson() => json.encode(toMap());

  /// Cria uma instância a partir de JSON
  factory BusLocation.fromJson(String source) => 
      BusLocation.fromMap(json.decode(source));

  /// Cria uma cópia com novos valores
  BusLocation copyWith({
    String? busId,
    double? latitude,
    double? longitude,
    String? routeName,
    DateTime? timestamp,
    double? speed,
    String? direction,
    String? status,
  }) {
    return BusLocation(
      busId: busId ?? this.busId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      routeName: routeName ?? this.routeName,
      timestamp: timestamp ?? this.timestamp,
      speed: speed ?? this.speed,
      direction: direction ?? this.direction,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'BusLocation(busId: $busId, latitude: $latitude, longitude: $longitude, routeName: $routeName, timestamp: $timestamp, speed: $speed, direction: $direction, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BusLocation &&
      other.busId == busId &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.routeName == routeName &&
      other.timestamp == timestamp &&
      other.speed == speed &&
      other.direction == direction &&
      other.status == status;
  }

  @override
  int get hashCode {
    return busId.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      routeName.hashCode ^
      timestamp.hashCode ^
      speed.hashCode ^
      direction.hashCode ^
      status.hashCode;
  }
}