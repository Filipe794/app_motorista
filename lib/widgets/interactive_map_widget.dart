import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../services/flutter_map_provider.dart';
import '../models/bus_route.dart';
import '../utils/app_colors.dart';

/// Widget de mapa interativo para exibir rotas e localização usando OpenStreetMap
class InteractiveMapWidget extends StatefulWidget {
  final double height;
  final bool showControls;
  final bool enableTracking;
  final VoidCallback? onMapReady;

  const InteractiveMapWidget({
    super.key,
    this.height = 200,
    this.showControls = true,
    this.enableTracking = false,
    this.onMapReady,
  });

  @override
  State<InteractiveMapWidget> createState() => _InteractiveMapWidgetState();
}

class _InteractiveMapWidgetState extends State<InteractiveMapWidget> {
  MapController? _controller;

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
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Mapa principal usando FlutterMap
                FlutterMap(
                  mapController: _controller,
                  options: MapOptions(
                    initialCenter: mapProvider.currentRoute?.center ?? 
                            const LatLng(-4.84, -43.355), // Centro de Caxias-MA
                    initialZoom: 13.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    // Camada de tiles do OpenStreetMap
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.caxias.transport.driver_app',
                      subdomains: const ['a', 'b', 'c'],
                      maxZoom: 19,
                    ),
                    
                    // Camada de polylines (rotas)
                    if (mapProvider.currentRoute != null)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: mapProvider.currentRoute!.waypoints,
                            color: Color(int.parse(mapProvider.currentRoute!.color.replaceAll('#', '0xFF'))),
                            strokeWidth: 4.0,
                          ),
                        ],
                      ),
                    
                    // Camada de marcadores (paradas)
                    if (mapProvider.currentRoute != null)
                      MarkerLayer(
                        markers: mapProvider.currentRoute!.stops.asMap().entries.map((entry) {
                          final index = entry.key;
                          final stop = entry.value;
                          final isFirst = index == 0;
                          final isLast = index == mapProvider.currentRoute!.stops.length - 1;
                          
                          return Marker(
                            point: LatLng(stop.latitude, stop.longitude),
                            child: Container(
                              width: isFirst || isLast ? 40 : 32,
                              height: isFirst || isLast ? 40 : 32,
                              decoration: BoxDecoration(
                                color: isFirst 
                                  ? Colors.green 
                                  : isLast 
                                    ? Colors.red 
                                    : Color(int.parse(mapProvider.currentRoute!.color.replaceAll('#', '0xFF'))),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isFirst 
                                  ? Icons.location_on 
                                  : isLast 
                                    ? Icons.flag 
                                    : Icons.directions_bus,
                                color: Colors.white,
                                size: isFirst || isLast ? 24 : 16,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    
                    // Marcador da localização atual (se rastreamento ativo)
                    if (mapProvider.isTracking && mapProvider.currentPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                              mapProvider.currentPosition!.latitude,
                              mapProvider.currentPosition!.longitude,
                            ),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
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

                // Indicador de carregamento
                if (_controller == null)
                  Container(
                    color: AppColors.surfaceLight.withValues(alpha: 0.8),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

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
  Widget _buildRouteInfo(BusRoute route) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.primaryDarkBlue.withValues(alpha: 0.9),
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
                  route.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${route.stops.length} paradas • ${route.distanceKm.toStringAsFixed(1)} km',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
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
              color: route.isActive 
                  ? AppColors.success 
                  : AppColors.surfaceMedium,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              route.isActive ? 'ATIVA' : 'INATIVA',
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