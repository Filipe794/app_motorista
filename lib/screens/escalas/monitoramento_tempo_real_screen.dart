import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../services/flutter_map_provider.dart';
import '../../services/student_app_data_service.dart';
import '../../widgets/flutter_map_widget.dart';
import '../../models/bus_route.dart';

/// Tela de visualização de paradas no mapa
class MonitoramentoTempoRealScreen extends StatefulWidget {
  const MonitoramentoTempoRealScreen({super.key});

  @override
  State<MonitoramentoTempoRealScreen> createState() => _MonitoramentoTempoRealScreenState();
}

class _MonitoramentoTempoRealScreenState extends State<MonitoramentoTempoRealScreen> {
  late FlutterMapProvider _mapProvider;
  BusRoute? _currentRoute;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _currentRoute = StudentAppDataService.getCurrentRoute();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FlutterMapProvider()..setCurrentRoute(_currentRoute!),
      child: Consumer<FlutterMapProvider>(
        builder: (context, mapProvider, child) {
          _mapProvider = mapProvider;
          
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: _buildAppBar(context),
            body: _buildMapSection(),
          );
        },
      ),
    );
  }

  /// Constrói a AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryDarkBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Visualizar Paradas',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Status de rastreamento
        Consumer<FlutterMapProvider>(
          builder: (context, mapProvider, child) {
            return Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: mapProvider.isTracking 
                    ? AppColors.success.withValues(alpha: 0.2)
                    : AppColors.error.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: mapProvider.isTracking 
                      ? AppColors.success
                      : AppColors.error,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    mapProvider.isTracking 
                        ? Icons.gps_fixed 
                        : Icons.gps_off,
                    size: 14,
                    color: mapProvider.isTracking 
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    mapProvider.isTracking ? 'ATIVO' : 'INATIVO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: mapProvider.isTracking 
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /// Constrói a seção do mapa
  Widget _buildMapSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: FlutterMapWidget(
        height: double.infinity,
        showControls: true,
        enableTracking: true,
        onMapReady: () {
          // Automaticamente ajustar o zoom para mostrar a rota
          Future.delayed(const Duration(milliseconds: 500), () {
            _mapProvider.fitRouteToScreen();
          });
        },
      ),
    );
  }

}