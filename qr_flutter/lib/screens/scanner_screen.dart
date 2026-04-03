// lib/screens/scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';
import '../widgets/scan_result_card.dart';
import 'history_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _cameraController = MobileScannerController();

  String? _scannedText;
  bool _isLoading = false;
  bool? _isSuccess;
  String? _errorMessage;
  bool _isScannerActive = true;
  DateTime? _lastScanTime;

  // ── Debounce: ignore scans within 2 seconds of the last scan ──
  bool _canScan() {
    if (_lastScanTime == null) return true;
    return DateTime.now().difference(_lastScanTime!) >
        const Duration(seconds: 2);
  }

  Future<void> _onQRDetected(BarcodeCapture capture) async {
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final rawValue = barcodes.first.rawValue;
    if (rawValue == null || rawValue.trim().isEmpty) return;
    if (!_canScan()) return;

    _lastScanTime = DateTime.now();

    setState(() {
      _scannedText = rawValue;
      _isLoading = true;
      _isSuccess = null;
      _errorMessage = null;
      _isScannerActive = false;
    });

    _cameraController.stop();

    // Send to backend
    final result = await ApiService.storeScan(rawValue);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSuccess = result['success'] as bool;
        if (_isSuccess == false) {
          _errorMessage = result['message']?.toString() ?? 'Unknown error';
        }
      });
    }
  }

  void _resetScanner() {
    setState(() {
      _scannedText = null;
      _isLoading = false;
      _isSuccess = null;
      _errorMessage = null;
      _isScannerActive = true;
    });
    _cameraController.start();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'QR Scanner',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
            icon: const Icon(
              Icons.history_rounded,
              color: Color(0xFF1A1A2E),
            ),
            tooltip: 'Scan History',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ── Camera / Scanner Section ──────────────────────────
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Camera preview
                    MobileScanner(
                      controller: _cameraController,
                      onDetect: _onQRDetected,
                    ),

                    // Scanning overlay when active
                    if (_isScannerActive)
                      Center(
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2.5,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              // Corner decorations
                              ..._buildCorners(),
                            ],
                          ),
                        ),
                      ),

                    // Paused overlay
                    if (!_isScannerActive)
                      Container(
                        color: Colors.black.withOpacity(0.6),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isLoading
                                    ? Icons.cloud_upload_rounded
                                    : _isSuccess == true
                                        ? Icons.check_circle_rounded
                                        : Icons.error_rounded,
                                color: _isLoading
                                    ? Colors.white
                                    : _isSuccess == true
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFFE53935),
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _isLoading
                                    ? 'Saving scan...'
                                    : _isSuccess == true
                                        ? 'Scan saved!'
                                        : 'Save failed',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_errorMessage != null && _isSuccess == false)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                    // Flash toggle
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => _cameraController.toggleTorch(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.flashlight_on_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Result / Hint Section ─────────────────────────────
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  if (_scannedText == null)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.qr_code_2_rounded,
                            size: 40,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Point your camera at a QR code',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ScanResultCard(
                      scannedText: _scannedText!,
                      isLoading: _isLoading,
                      isSuccess: _isSuccess,
                    ),

                  // Scan Again button
                  if (_scannedText != null && !_isLoading)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _resetScanner,
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Scan Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCorners() {
    const color = Color(0xFF64B5F6);
    const size = 20.0;
    const thickness = 3.0;

    return [
      // Top-left
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: size,
          height: thickness,
          color: color,
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: thickness,
          height: size,
          color: color,
        ),
      ),
      // Top-right
      Positioned(
        top: 0,
        right: 0,
        child: Container(width: size, height: thickness, color: color),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: Container(width: thickness, height: size, color: color),
      ),
      // Bottom-left
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(width: size, height: thickness, color: color),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(width: thickness, height: size, color: color),
      ),
      // Bottom-right
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(width: size, height: thickness, color: color),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(width: thickness, height: size, color: color),
      ),
    ];
  }
}