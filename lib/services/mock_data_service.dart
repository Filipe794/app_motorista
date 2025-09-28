import 'package:latlong2/latlong.dart';
import '../models/bus_route.dart';
import '../models/bus_stop.dart';

/// Dados simulados para demonstração do mapa
class MockDataService {
  
  /// Retorna rotas simuladas para demonstração
  static List<BusRoute> getMockRoutes() {
    return [
      // Rota Centro - Antenor Viana
      BusRoute(
        id: 'rota_001',
        name: 'Centro - Antenor Viana',
        description: 'Linha principal conectando o centro da cidade ao bairro Antenor Viana',
        color: '#2196F3',
        distanceKm: 8.5,
        estimatedDurationMinutes: 35,
        startTime: '05:30',
        endTime: '23:00',
        waypoints: [
          const LatLng(-5.2015, -43.3546), // Centro de Caxias-MA
          const LatLng(-5.2025, -43.3520), // Direção ao Mercado
          const LatLng(-5.2040, -43.3500), // Av. Getúlio Vargas
          const LatLng(-5.2055, -43.3480), // Praça Gonçalves Dias
          const LatLng(-5.2070, -43.3460), // Hospital Municipal
          const LatLng(-5.2085, -43.3440), // Escola Técnica
          const LatLng(-5.2100, -43.3420), // Antenor Viana
        ],
        stops: [
          const BusStop(
            id: 'stop_001',
            name: 'Terminal Rodoviário',
            latitude: -5.2015,
            longitude: -43.3546,
            address: 'Rua do Terminal, Centro',
            routeIds: ['rota_001'],
            passengerCount: 25,
          ),
          const BusStop(
            id: 'stop_002',
            name: 'Mercado Municipal',
            latitude: -5.2025,
            longitude: -43.3520,
            address: 'Praça do Mercado, Centro',
            routeIds: ['rota_001'],
            passengerCount: 15,
          ),
          const BusStop(
            id: 'stop_003',
            name: 'Av. Getúlio Vargas',
            latitude: -5.2040,
            longitude: -43.3500,
            address: 'Av. Getúlio Vargas, 500',
            routeIds: ['rota_001'],
            passengerCount: 8,
          ),
          const BusStop(
            id: 'stop_004',
            name: 'Hospital Municipal',
            latitude: -5.2055,
            longitude: -43.3480,
            address: 'Rua da Saúde, Hospital',
            routeIds: ['rota_001'],
            passengerCount: 12,
          ),
          const BusStop(
            id: 'stop_005',
            name: 'IFMA - Campus Caxias',
            latitude: -5.2070,
            longitude: -43.3460,
            address: 'Instituto Federal do Maranhão',
            routeIds: ['rota_001'],
            passengerCount: 20,
          ),
          const BusStop(
            id: 'stop_006',
            name: 'Terminal Antenor Viana',
            latitude: -5.2100,
            longitude: -43.3420,
            address: 'Terminal Antenor Viana',
            routeIds: ['rota_001'],
            passengerCount: 5,
          ),
        ],
      ),
      
      // Rota Circular Norte
      BusRoute(
        id: 'rota_002',
        name: 'Circular Norte',
        description: 'Rota circular conectando os bairros da zona norte de Caxias',
        color: '#4CAF50',
        distanceKm: 6.8,
        estimatedDurationMinutes: 30,
        startTime: '06:00',
        endTime: '22:00',
        waypoints: [
          const LatLng(-5.1980, -43.3580), // Início - Centro Norte
          const LatLng(-5.1960, -43.3600), // Bairro São José
          const LatLng(-5.1940, -43.3620), // Vila Nova
          const LatLng(-5.1920, -43.3640), // Cohab
          const LatLng(-5.1940, -43.3660), // Volta pela BR
          const LatLng(-5.1960, -43.3640), // Retorno
          const LatLng(-5.1980, -43.3620), // Volta ao centro
          const LatLng(-5.1980, -43.3580), // Volta ao início
        ],
        stops: [
          const BusStop(
            id: 'stop_007',
            name: 'Praça Duque de Caxias',
            latitude: -5.1980,
            longitude: -43.3580,
            address: 'Praça Central, Centro',
            routeIds: ['rota_002'],
            passengerCount: 18,
          ),
          const BusStop(
            id: 'stop_008',
            name: 'São José',
            latitude: -5.1960,
            longitude: -43.3600,
            address: 'Bairro São José',
            routeIds: ['rota_002'],
            passengerCount: 10,
          ),
          const BusStop(
            id: 'stop_009',
            name: 'Vila Nova',
            latitude: -5.1940,
            longitude: -43.3620,
            address: 'Vila Nova, Escola Municipal',
            routeIds: ['rota_002'],
            passengerCount: 6,
          ),
          const BusStop(
            id: 'stop_010',
            name: 'Cohab',
            latitude: -5.1920,
            longitude: -43.3640,
            address: 'Conjunto Habitacional',
            routeIds: ['rota_002'],
            passengerCount: 14,
          ),
        ],
      ),

      // Rota Express Sul
      BusRoute(
        id: 'rota_003',
        name: 'Express Sul',
        description: 'Linha expressa para os bairros da zona sul de Caxias',
        color: '#FF9800',
        distanceKm: 12.2,
        estimatedDurationMinutes: 25,
        startTime: '05:45',
        endTime: '22:30',
        waypoints: [
          const LatLng(-5.2015, -43.3546), // Centro
          const LatLng(-5.2080, -43.3500), // Direção Sul - Baixada
          const LatLng(-5.2150, -43.3450), // Bairro Baixada
          const LatLng(-5.2220, -43.3400), // Terminal Sul - Periferia
        ],
        stops: [
          const BusStop(
            id: 'stop_011',
            name: 'Terminal Rodoviário',
            latitude: -5.2015,
            longitude: -43.3546,
            address: 'Terminal Central',
            routeIds: ['rota_003'],
            passengerCount: 30,
          ),
          const BusStop(
            id: 'stop_012',
            name: 'Baixada - Comércio',
            latitude: -5.2080,
            longitude: -43.3500,
            address: 'Rua do Comércio, Baixada',
            routeIds: ['rota_003'],
            passengerCount: 22,
          ),
          const BusStop(
            id: 'stop_013',
            name: 'Escola Municipal Baixada',
            latitude: -5.2150,
            longitude: -43.3450,
            address: 'Bairro Baixada, Escola',
            routeIds: ['rota_003'],
            passengerCount: 16,
          ),
          const BusStop(
            id: 'stop_014',
            name: 'Terminal Periferia Sul',
            latitude: -5.2220,
            longitude: -43.3400,
            address: 'Terminal da Periferia Sul',
            routeIds: ['rota_003'],
            passengerCount: 8,
          ),
        ],
      ),
    ];
  }

  /// Retorna a rota atual do motorista (simulada)
  static BusRoute getCurrentRoute() {
    return getMockRoutes().first; // Retorna a primeira rota como exemplo
  }

  /// Retorna todas as paradas
  static List<BusStop> getAllStops() {
    return getMockRoutes().expand((route) => route.stops).toList();
  }

  /// Retorna paradas de uma rota específica
  static List<BusStop> getStopsForRoute(String routeId) {
    final route = getMockRoutes().firstWhere(
      (r) => r.id == routeId,
      orElse: () => getMockRoutes().first,
    );
    return route.stops;
  }

  /// Simula estatísticas da rota
  static Map<String, dynamic> getRouteStats() {
    return {
      'totalPassengers': 85,
      'completedStops': 3,
      'totalStops': 6,
      'estimatedArrival': '14:45',
      'averageSpeed': 35.2,
      'distanceRemaining': 8.7,
    };
  }
}