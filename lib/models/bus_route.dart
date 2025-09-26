import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'bus_stop.dart';

/// Modelo para representar uma rota de ônibus
class BusRoute {
  final String id;
  final String name;
  final String description;
  final List<LatLng> waypoints;
  final List<BusStop> stops;
  final String color;
  final bool isActive;
  final double distanceKm;
  final int estimatedDurationMinutes;
  final String startTime;
  final String endTime;

  const BusRoute({
    required this.id,
    required this.name,
    required this.description,
    required this.waypoints,
    required this.stops,
    this.color = '#2196F3',
    this.isActive = true,
    this.distanceKm = 0.0,
    this.estimatedDurationMinutes = 0,
    this.startTime = '06:00',
    this.endTime = '22:00',
  });

  /// Cria uma instância a partir de um Map
  factory BusRoute.fromMap(Map<String, dynamic> map) {
    return BusRoute(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      waypoints: List<LatLng>.from(
        map['waypoints']?.map((x) => LatLng(
          (x['latitude'] ?? 0.0).toDouble(),
          (x['longitude'] ?? 0.0).toDouble(),
        )) ?? []
      ),
      stops: List<BusStop>.from(
        map['stops']?.map((x) => BusStop.fromMap(x)) ?? []
      ),
      color: map['color'] ?? '#2196F3',
      isActive: map['isActive'] ?? true,
      distanceKm: (map['distanceKm'] ?? 0.0).toDouble(),
      estimatedDurationMinutes: map['estimatedDurationMinutes']?.toInt() ?? 0,
      startTime: map['startTime'] ?? '06:00',
      endTime: map['endTime'] ?? '22:00',
    );
  }

  /// Converte para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'waypoints': waypoints.map((x) => {
        'latitude': x.latitude,
        'longitude': x.longitude,
      }).toList(),
      'stops': stops.map((x) => x.toMap()).toList(),
      'color': color,
      'isActive': isActive,
      'distanceKm': distanceKm,
      'estimatedDurationMinutes': estimatedDurationMinutes,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  /// Converte para JSON
  String toJson() => json.encode(toMap());

  /// Cria uma instância a partir de JSON
  factory BusRoute.fromJson(String source) => 
      BusRoute.fromMap(json.decode(source));

  /// Cria uma cópia com novos valores
  BusRoute copyWith({
    String? id,
    String? name,
    String? description,
    List<LatLng>? waypoints,
    List<BusStop>? stops,
    String? color,
    bool? isActive,
    double? distanceKm,
    int? estimatedDurationMinutes,
    String? startTime,
    String? endTime,
  }) {
    return BusRoute(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      waypoints: waypoints ?? this.waypoints,
      stops: stops ?? this.stops,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedDurationMinutes: estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  /// Retorna o ponto inicial da rota
  LatLng? get startPoint => waypoints.isNotEmpty ? waypoints.first : null;

  /// Retorna o ponto final da rota
  LatLng? get endPoint => waypoints.isNotEmpty ? waypoints.last : null;

  /// Retorna o centro da rota para posicionamento da câmera
  LatLng get center {
    if (waypoints.isEmpty) return const LatLng(-23.550520, -46.633308);
    
    double latSum = 0;
    double lngSum = 0;
    
    for (final point in waypoints) {
      latSum += point.latitude;
      lngSum += point.longitude;
    }
    
    return LatLng(latSum / waypoints.length, lngSum / waypoints.length);
  }

  @override
  String toString() {
    return 'BusRoute(id: $id, name: $name, description: $description, color: $color, isActive: $isActive, distanceKm: $distanceKm, estimatedDurationMinutes: $estimatedDurationMinutes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BusRoute &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.waypoints == waypoints &&
      other.stops == stops &&
      other.color == color &&
      other.isActive == isActive &&
      other.distanceKm == distanceKm &&
      other.estimatedDurationMinutes == estimatedDurationMinutes &&
      other.startTime == startTime &&
      other.endTime == endTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      waypoints.hashCode ^
      stops.hashCode ^
      color.hashCode ^
      isActive.hashCode ^
      distanceKm.hashCode ^
      estimatedDurationMinutes.hashCode ^
      startTime.hashCode ^
      endTime.hashCode;
  }
}