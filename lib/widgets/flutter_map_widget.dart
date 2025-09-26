import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../services/flutter_map_provider.dart';
import '../utils/app_colors.dart';

/// Widget de mapa interativo usando OpenStreetMap (sem API Key)
class FlutterMapWidget extends StatefulWidget {
  final double height;
  final bool showControls;
  final bool enableTracking;
  final VoidCallback? onMapReady;

  const FlutterMapWidget({
    super.key,
    this.height = 200,
    this.showControls = true,
    this.enableTracking = false,
    this.onMapReady,
  });

  @override
  State<FlutterMapWidget> createState() => _FlutterMapWidgetState();
}

class _FlutterMapWidgetState extends State<FlutterMapWidget> {
  MapController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FlutterMapProvider>(
      builder: (context, mapProvider, child) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Mapa principal
                FlutterMap(
                  mapController: _controller,
                  options: MapOptions(
                    initialCenter: mapProvider.currentRoute?.center ?? 
                                   const LatLng(-23.550520, -46.633308),
                    initialZoom: 13.0,
                    onMapReady: () {
                      if (_controller != null) {
                        mapProvider.setController(_controller!);
                        widget.onMapReady?.call();
                      }
                    },
                  ),
                  children: [
                    // Tiles do OpenStreetMap
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.rota_mais',
                      maxZoom: 19,
                    ),
                    
                    // Polylines das rotas
                    PolylineLayer(
                      polylines: mapProvider.buildPolylines(),
                    ),
                    
                    // Marcadores
                    MarkerLayer(
                      markers: mapProvider.buildMarkers(),
                    ),
                  ],
                ),

                // Controles customizados
                if (widget.showControls) ...[
                  // Botão para ajustar zoom na rota
                  Positioned(
                    top: 16,
                    right: 16,
                    child: _buildControlButton(
                      icon: Icons.center_focus_strong,
                      onPressed: () => mapProvider.fitRouteToScreen(),
                      tooltip: 'Ajustar visualização',
                    ),
                  ),

                  // Botão de rastreamento (se habilitado)
                  if (widget.enableTracking)
                    Positioned(
                      top: 70,
                      right: 16,
                      child: _buildControlButton(
                        icon: mapProvider.isTracking 
                            ? Icons.location_on 
                            : Icons.location_off,
                        onPressed: () {
                          if (mapProvider.isTracking) {
                            mapProvider.stopLocationTracking();
                          } else {
                            mapProvider.startLocationTracking();
                          }
                        },
                        tooltip: mapProvider.isTracking 
                            ? 'Parar rastreamento' 
                            : 'Iniciar rastreamento',
                        color: mapProvider.isTracking 
                            ? AppColors.success 
                            : AppColors.surfaceMedium,
                      ),
                    ),
                ],

                // Informações da rota (overlay)
                if (mapProvider.currentRoute != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildRouteInfo(mapProvider.currentRoute!),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Constrói botões de controle do mapa
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: AppColors.primaryDarkBlue,
        tooltip: tooltip,
        iconSize: 20,
      ),
    );
  }

  /// Constrói informações da rota na parte inferior
  Widget _buildRouteInfo(dynamic route) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.primaryDarkBlue.withOpacity(0.9),
          ],
        ),
      ),
      child: Row(
        children: [
          // Ícone da rota
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.directions_bus,
              color: AppColors.primaryDarkBlue,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Informações da rota
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  route.name ?? 'Rota Atual',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${route.stops?.length ?? 0} paradas • ${route.distanceKm?.toStringAsFixed(1) ?? '0.0'} km',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Status indicador
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: route.isActive == true 
                  ? AppColors.success 
                  : AppColors.surfaceMedium,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              route.isActive == true ? 'ATIVA' : 'INATIVA',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}