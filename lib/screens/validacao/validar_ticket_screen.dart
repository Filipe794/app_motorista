// TODO: Implementar integração com câmera
// TODO: Adicionar validação de ticket no backend
// TODO: Implementar histórico de validações
// TODO: Adicionar feedback sonoro de validação
// TODO: Implementar modo offline

import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../../utils/app_colors.dart';

class ValidarTicketScreen extends StatefulWidget {
  final String escalaId;
  
  const ValidarTicketScreen({
    super.key,
    required this.escalaId,
  });

  @override
  State<ValidarTicketScreen> createState() => _ValidarTicketScreenState();
}

class _ValidarTicketScreenState extends State<ValidarTicketScreen>
    with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  bool _flashEnabled = false;
  String? _lastScannedCode;
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scanLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    
    _animationController.repeat(reverse: true);
    
    // Inicia o scanner automaticamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScanning();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startScanning() {
    setState(() {
      _isScanning = true;
    });
    
    // Simulação de scan - substituir pela implementação real
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isScanning) {
        _simulateSuccessfulScan();
      }
    });
  }

  void _stopScanning() {
    setState(() {
      _isScanning = false;
    });
  }

  void _simulateSuccessfulScan() {
    setState(() {
      _isScanning = false;
      _lastScannedCode = 'TKT-2024-${DateTime.now().millisecondsSinceEpoch}';
    });
    
    _showValidationResult(
      success: true,
      passengerName: 'João Silva Santos',
      ticketCode: _lastScannedCode!,
      destination: 'E.M. José de Alencar',
    );
  }

  void _showValidationResult({
    required bool success,
    required String passengerName,
    required String ticketCode,
    required String destination,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? AppColors.success : AppColors.error,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              success ? 'Ticket Válido' : 'Ticket Inválido',
              style: TextStyle(
                color: success ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (success) ...[
              _buildDetailRow('Passageiro:', passengerName),
              _buildDetailRow('Código:', ticketCode),
              _buildDetailRow('Destino:', destination),
              _buildDetailRow('Data/Hora:', _formatDateTime(DateTime.now())),
            ] else ...[
              const Text(
                'Este ticket não é válido para esta rota ou já foi utilizado.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
        actions: [
          if (!success)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startScanning();
              },
              child: const Text('Tentar Novamente'),
            ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: success ? AppColors.success : AppColors.primaryDarkBlue,
              foregroundColor: AppColors.textOnDark,
            ),
            child: Text(success ? 'Confirmar' : 'Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _toggleFlash() {
    setState(() {
      _flashEnabled = !_flashEnabled;
    });
    // TODO: Implementar controle de flash da câmera
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: const Text(
          'Validar Ticket',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textOnDark,
          ),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textOnDark),
        actions: [
          IconButton(
            onPressed: _toggleFlash,
            icon: Icon(
              _flashEnabled ? Icons.flash_on : Icons.flash_off,
              color: _flashEnabled ? AppColors.warning : AppColors.textOnDark,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.maxContainerWidth,
            ),
            child: Column(
              children: [
                // Área de scan
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.all(context.horizontalPadding),
                    child: _buildScanArea(),
                  ),
                ),
                
                // Instruções e controles
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(context.horizontalPadding),
                    child: _buildControls(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanArea() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isScanning ? AppColors.success : AppColors.surfaceLight,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // Área da câmera (placeholder)
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: context.isTablet ? 100 : 80,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: context.verticalSpacing),
                    Text(
                      'Câmera será ativada aqui',
                      style: TextStyle(
                        fontSize: context.fontSize(14),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Overlay de scan
          if (_isScanning) _buildScanOverlay(),
          
          // Cantos do scanner
          _buildScanCorners(),
        ],
      ),
    );
  }

  Widget _buildScanOverlay() {
    return AnimatedBuilder(
      animation: _scanLineAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          child: CustomPaint(
            painter: ScanLinePainter(_scanLineAnimation.value),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }

  Widget _buildScanCorners() {
    const cornerSize = 24.0;
    const cornerThickness = 4.0;
    
    return Stack(
      children: [
        // Canto superior esquerdo
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            width: cornerSize,
            height: cornerSize,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.success,
                  width: cornerThickness,
                ),
                left: BorderSide(
                  color: AppColors.success,
                  width: cornerThickness,
                ),
              ),
            ),
          ),
        ),
        
        // Canto superior direito
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            width: cornerSize,
            height: cornerSize,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.success,
                  width: cornerThickness,
                ),
                right: BorderSide(
                  color: AppColors.success,
                  width: cornerThickness,
                ),
              ),
            ),
          ),
        ),
        
        // Canto inferior esquerdo
        Positioned(
          bottom: 20,
          left: 20,
          child: Container(
            width: cornerSize,
            height: cornerSize,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.success,
                  width: cornerThickness,
                ),
                left: BorderSide(
                  color: AppColors.success,
                  width: cornerThickness,
                ),
              ),
            ),
          ),
        ),
        
        // Canto inferior direito
        Positioned(
          bottom: 20,
          right: 20,
          child: Container(
            width: cornerSize,
            height: cornerSize,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.success,
                  width: cornerThickness,
                ),
                right: BorderSide(
                  color: AppColors.success,
                  width: cornerThickness,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Instruções
        Container(
          padding: EdgeInsets.all(context.isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.surfaceLight,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primaryDarkBlue,
                size: context.isTablet ? 20 : 18,
              ),
              SizedBox(height: context.verticalSpacing * 0.3),
              Text(
                _isScanning 
                    ? 'Aponte a câmera para o QR Code do ticket'
                    : 'Scanner iniciará automaticamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.fontSize(context.isTablet ? 14 : 12),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: context.verticalSpacing),
        
        // Botão para parar scanner
        if (_isScanning)
          SizedBox(
            width: double.infinity,
            height: context.isTablet ? 56 : 50,
            child: ElevatedButton.icon(
              onPressed: _stopScanning,
              icon: Icon(
                Icons.stop,
                size: context.isTablet ? 20 : 18,
              ),
              label: Text(
                'Parar Scanner',
                style: TextStyle(
                  fontSize: context.fontSize(context.isTablet ? 14 : 12),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.textOnDark,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: context.responsiveBorderRadius,
                ),
              ),
            ),
          ),
        
        // Botão para reiniciar scanner (só aparece quando parado)
        if (!_isScanning)
          SizedBox(
            width: double.infinity,
            height: context.isTablet ? 56 : 50,
            child: ElevatedButton.icon(
              onPressed: _startScanning,
              icon: Icon(
                Icons.qr_code_scanner,
                size: context.isTablet ? 20 : 18,
              ),
              label: Text(
                'Reiniciar Scanner',
                style: TextStyle(
                  fontSize: context.fontSize(context.isTablet ? 14 : 12),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDarkBlue,
                foregroundColor: AppColors.textOnDark,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: context.responsiveBorderRadius,
                ),
              ),
            ),
          ),
        
        if (_lastScannedCode != null) ...[
          SizedBox(height: context.verticalSpacing * 0.6),
          Text(
            'Último código: $_lastScannedCode',
            style: TextStyle(
              fontSize: context.fontSize(10),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class ScanLinePainter extends CustomPainter {
  final double animationValue;
  
  ScanLinePainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final y = size.height * animationValue;
    
    canvas.drawLine(
      Offset(40, y),
      Offset(size.width - 40, y),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}