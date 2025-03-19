import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_icons.dart';
import '../widgets/app_images.dart';
import '../widgets/app_text_style.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  bool _isTorchOn = false;
  final MobileScannerController _controller = MobileScannerController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final result = await _controller.analyzeImage(image.path);
        if (result != null) {
          for (final barcode in result.barcodes) {
            debugPrint('QR Code found in image: ${barcode.rawValue}');
            // Handle the QR code data here
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      // Handle the QR code data here
    }
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: CustomPaint(
        painter: ScannerOverlayPainter(color: AppColors.purpleDark2),
        child: SizedBox(
          width: 280,
          height: 280,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // QR Scanner with overlay
            Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
                _buildScannerOverlay(),
              ],
            ),

            // Top Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Back button and title
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
                      const SizedBox(width: 48), // Balance the back button
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
                      // Image picker
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
                      // Flash toggle
                      GestureDetector(
                        onTap: () async {
                          try {
                            await _controller.toggleTorch();
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
        ..moveTo(0, radius)
        ..quadraticBezierTo(0, 0, radius, 0)
        ..lineTo(cornerLength, 0),
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