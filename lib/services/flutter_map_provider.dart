import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../models/bus_location.dart';
import '../models/bus_route.dart';

class FlutterMapProvider extends ChangeNotifier {
  MapController? _controller;
  Position? _currentPosition;
  BusLocation? _currentBusLocation;
  BusRoute? _currentRoute;
  Timer? _locationTimer;
  bool _isTracking = false;

  // Getters
  MapController? get controller => _controller;
  Position? get currentPosition => _currentPosition;
  BusLocation? get currentBusLocation => _currentBusLocation;
  BusRoute? get currentRoute => _currentRoute;
  bool get isTracking => _isTracking;

  /// Define o controlador do mapa
  void setController(MapController controller) {
    _controller = controller;
    notifyListeners();
  }

  /// Define a rota atual
  void setCurrentRoute(BusRoute route) {
    _currentRoute = route;
    notifyListeners();
  }

  /// Inicia o rastreamento de localização
  Future<void> startLocationTracking() async {
    if (_isTracking) return;

    try {
      // Verificar permissões
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permissão de localização negada');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permissão de localização negada permanentemente');
      }

      // Obter localização inicial
      await _updateCurrentLocation();

      // Iniciar timer para atualizações periódicas
      _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        _updateCurrentLocation();
      });

      _isTracking = true;
      notifyListeners();
    } catch (e) {
      print('Erro ao iniciar rastreamento: $e');
    }
  }

  /// Para o rastreamento de localização
  void stopLocationTracking() {
    _locationTimer?.cancel();
    _locationTimer = null;
    _isTracking = false;
    notifyListeners();
  }

  /// Atualiza a localização atual
  Future<void> _updateCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = position;

      // Criar BusLocation com os dados atuais
      _currentBusLocation = BusLocation(
        busId: 'MOTORISTA_001',
        latitude: position.latitude,
        longitude: position.longitude,
        routeName: _currentRoute?.name ?? 'Rota Atual',
        timestamp: DateTime.now(),
        speed: position.speed,
        direction: _getCardinalDirection(position.heading),
        status: position.speed > 2 ? 'moving' : 'stopped',
      );

      // Atualizar câmera se necessário
      if (_controller != null) {
        _controller!.move(
          LatLng(position.latitude, position.longitude),
          _controller!.camera.zoom,
        );
      }

      notifyListeners();
    } catch (e) {
      print('Erro ao atualizar localização: $e');
    }
  }

  /// Converte graus em direção cardinal
  String _getCardinalDirection(double heading) {
    if (heading < 0) heading += 360;
    
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((heading + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  /// Cria marcadores para o mapa
  List<Marker> buildMarkers() {
    final markers = <Marker>[];

    // Marcador da localização atual do ônibus
    if (_currentBusLocation != null) {
      markers.add(
        Marker(
          point: LatLng(
            _currentBusLocation!.latitude,
            _currentBusLocation!.longitude,
          ),
          width: 25, // Reduzido de 80 para 25
          height: 25, // Reduzido de 80 para 25
          child: Icon(
            Icons.directions_bus,
            color: _currentBusLocation!.status == 'moving' 
                ? Colors.green
                : Colors.orange,
            size: 15, // Reduzido de 40 para 15
          ),
        ),
      );
    }

    // Marcadores das paradas da rota atual
    if (_currentRoute != null) {
      for (int i = 0; i < _currentRoute!.stops.length; i++) {
        final stop = _currentRoute!.stops[i];
        markers.add(
          Marker(
            point: LatLng(stop.latitude, stop.longitude),
            width: 32, // Reduzido de 60 para 32
            height: 32, // Reduzido de 60 para 32
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12, // Reduzido de 16 para 12
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return markers;
  }

  /// Cria polylines para o mapa
  List<Polyline> buildPolylines() {
    final polylines = <Polyline>[];

    if (_currentRoute != null && _currentRoute!.waypoints.isNotEmpty) {
      polylines.add(
        Polyline(
          points: _currentRoute!.waypoints,
          color: _parseColor(_currentRoute!.color),
          strokeWidth: 4.0,
          isDotted: !_currentRoute!.isActive, // Linha tracejada se inativo
        ),
      );
    }

    return polylines;
  }

  /// Converte string de cor para Color
  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  /// Move câmera para mostrar a rota completa
  void fitRouteToScreen() {
    if (_controller == null || _currentRoute == null) return;

    if (_currentRoute!.waypoints.isEmpty) return;

    double minLat = _currentRoute!.waypoints.first.latitude;
    double maxLat = _currentRoute!.waypoints.first.latitude;
    double minLng = _currentRoute!.waypoints.first.longitude;
    double maxLng = _currentRoute!.waypoints.first.longitude;

    for (final point in _currentRoute!.waypoints) {
      minLat = min(minLat, point.latitude);
      maxLat = max(maxLat, point.latitude);
      minLng = min(minLng, point.longitude);
      maxLng = max(maxLng, point.longitude);
    }

    final bounds = LatLngBounds(
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    );

    _controller!.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50),
      ),
    );
  }

  @override
  void dispose() {
    stopLocationTracking();
    super.dispose();
  }
}