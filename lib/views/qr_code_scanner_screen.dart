import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr;
import 'package:image_picker/image_picker.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_icons.dart';
import '../widgets/app_images.dart';
import '../widgets/app_text_style.dart';
import 'package:google_ml_kit/google_ml_kit.dart' as ml_kit;
import '../views/game_details_screen.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  bool _isTorchOn = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  qr.QRViewController? controller;
  final ImagePicker _imagePicker = ImagePicker();
  final ml_kit.BarcodeScanner _barcodeScanner = ml_kit.GoogleMlKit.vision.barcodeScanner();

  @override
  void initState() {
    super.initState();
    // Simulate QR code scan after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GameDetailsScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _barcodeScanner.close();
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final inputImage = ml_kit.InputImage.fromFilePath(image.path);
        final List<ml_kit.Barcode> barcodes = await _barcodeScanner.processImage(inputImage);
        
        if (barcodes.isNotEmpty) {
          for (final barcode in barcodes) {
            debugPrint('Barcode found in image: ${barcode.rawValue}');
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('QR Code found: ${barcode.rawValue}'),
                backgroundColor: Colors.green,
              ),
            );
            return;
          }
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No QR code found in the image'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error scanning image: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error scanning image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onQRViewCreated(qr.QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        debugPrint('QR Code found: ${scanData.code}');
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR Code found! Redirecting...'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to game details after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const GameDetailsScreen(),
            ),
          );
        });
      }
    });
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: CustomPaint(
        painter: ScannerOverlayPainter(color: AppColors.purpleDark2),
        child: const SizedBox(
          width: 280,
          height: 280,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              // QR Scanner with overlay
              qr.QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: qr.QrScannerOverlayShape(
                  borderColor: Colors.transparent,
                  borderRadius: 24,
                  borderLength: 0,
                  borderWidth: 0,
                  cutOutSize: 280,
                ),
              ),
              _buildScannerOverlay(),

              // Top Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const AppImages(
                            imagePath: AppImageData.back,
                            height: 48,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'QR Code Scan',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.mochiyPopOne(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ],
                ),
              ),

              // Bottom Controls
              Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: AppIcons(
                              icon: AppIconData.image,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 46),
                        Container(
                          height: 32,
                          width: 2,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 46),
                        GestureDetector(
                          onTap: () async {
                            try {
                              await controller?.toggleFlash();
                              setState(() => _isTorchOn = !_isTorchOn);
                            } catch (e) {
                              debugPrint('Error toggling torch: $e');
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              _isTorchOn ? Icons.flash_on : Icons.flash_off,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Color color;

  ScannerOverlayPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    const double cornerLength = 60;
    const double radius = 40;

    // Top left corner
    canvas.drawPath(
      Path()
        ..moveTo(cornerLength, 0)
        ..lineTo(radius, 0)
        ..quadraticBezierTo(0, 0, 0, radius)
        ..lineTo(0, cornerLength),
      paint,
    );

    // Top right corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, 0)
        ..lineTo(size.width - radius, 0)
        ..quadraticBezierTo(size.width, 0, size.width, radius)
        ..lineTo(size.width, cornerLength),
      paint,
    );

    // Bottom left corner
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerLength)
        ..lineTo(0, size.height - radius)
        ..quadraticBezierTo(0, size.height, radius, size.height)
        ..lineTo(cornerLength, size.height),
      paint,
    );

    // Bottom right corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width, size.height - cornerLength)
        ..lineTo(size.width, size.height - radius)
        ..quadraticBezierTo(size.width, size.height, size.width - radius, size.height)
        ..lineTo(size.width - cornerLength, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 