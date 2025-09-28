import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
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

  // Setters
  void setController(MapController controller) {
    _controller = controller;
    notifyListeners();
  }

  void setCurrentRoute(BusRoute? route) {
    _currentRoute = route;
    notifyListeners();
  }

  // Location tracking methods
  Future<void> startLocationTracking() async {
    if (_isTracking) return;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    _isTracking = true;
    _startLocationTimer();
    notifyListeners();
  }

  void stopLocationTracking() {
    _isTracking = false;
    _locationTimer?.cancel();
    _locationTimer = null;
    notifyListeners();
  }

  void _startLocationTimer() {
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) => _updateCurrentLocation(),
    );
  }

  Future<void> _updateCurrentLocation() async {
    if (!_isTracking) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = position;
      _currentBusLocation = BusLocation(
        busId: 'current_bus',
        latitude: position.latitude,
        longitude: position.longitude,
        routeName: _currentRoute?.name ?? 'Unknown Route',
        timestamp: DateTime.now(),
      );

      // Move camera to current position if controller is available
      if (_controller != null) {
        _controller!.move(
          LatLng(position.latitude, position.longitude),
          15.0,
        );
      }

      notifyListeners();
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  // Map markers and polylines for Flutter Map
  List<Marker> buildMarkers() {
    final markers = <Marker>[];

    // Add current bus location marker
    if (_currentBusLocation != null) {
      markers.add(
        Marker(
          point: LatLng(
            _currentBusLocation!.latitude,
            _currentBusLocation!.longitude,
          ),
          width: 40,
          height: 40,
          child: Icon(
            Icons.directions_bus,
            color: _isTracking ? Colors.green : Colors.orange,
            size: 30,
          ),
        ),
      );
    }

    // Add bus stops markers
    if (_currentRoute?.stops != null) {
      for (final stop in _currentRoute!.stops) {
        markers.add(
          Marker(
            point: LatLng(stop.latitude, stop.longitude),
            width: 30,
            height: 30,
            child: const Icon(
              Icons.location_on,
              color: Colors.blue,
              size: 24,
            ),
          ),
        );
      }
    }

    return markers;
  }

  List<Polyline> buildPolylines() {
    final polylines = <Polyline>[];

    if (_currentRoute?.waypoints != null) {
      final points = _currentRoute!.waypoints
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      polylines.add(
        Polyline(
          points: points,
          color: _currentRoute!.isActive ? Colors.blue : Colors.grey,
          strokeWidth: 4.0,
          isDotted: !_currentRoute!.isActive,
        ),
      );
    }

    return polylines;
  }

  // Fit bounds to show all route points
  void fitRouteBounds() {
    if (_controller == null || _currentRoute?.waypoints == null) return;

    final points = _currentRoute!.waypoints;
    if (points.isEmpty) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
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

  // Cleanup
  @override
  void dispose() {
    stopLocationTracking();
    _controller = null;
    super.dispose();
  }
}