import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/app_icons.dart';
import '../widgets/app_images.dart';
import '../widgets/app_text_style.dart';
import '../routes/app_routes.dart';
import '../widgets/app_toast.dart';
import 'package:google_ml_kit/google_ml_kit.dart' as ml_kit;

class QRCodeScannerScreen extends StatefulWidget {
  final bool isInPerson;

  const QRCodeScannerScreen({
    super.key,
    required this.isInPerson,
  });

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen>
    with WidgetsBindingObserver {
  bool _isTorchOn = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final MobileScannerController cameraController = MobileScannerController();
  final ImagePicker _imagePicker = ImagePicker();
  final ml_kit.BarcodeScanner _barcodeScanner =
      ml_kit.GoogleMlKit.vision.barcodeScanner();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    cameraController.dispose();
    _barcodeScanner.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      cameraController.start();
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.stop();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Theme.of(context).platform == TargetPlatform.android) {
      cameraController.stop();
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      cameraController.start();
    });
  }

  void _handleScannedCode(String? code) {
    if (code != null) {
      debugPrint('QR Code found: $code');

      // Show custom toast with info icon but no close button
      AppToast.show(
        context,
        'QR Code detected! Processing game information...',
        showCloseIcon: false,
      );

      // Navigate to appropriate screen based on mode
      if (widget.isInPerson) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.gameDetails,
          arguments: code,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.remoteGameDetails,
          arguments: code,
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final inputImage = ml_kit.InputImage.fromFilePath(image.path);
        final List<ml_kit.Barcode> barcodes =
            await _barcodeScanner.processImage(inputImage);

        if (barcodes.isNotEmpty) {
          for (final barcode in barcodes) {
            if (!mounted) return;
            _handleScannedCode(barcode.rawValue);
            return;
          }
        } else {
          if (!mounted) return;
          AppToast.show(
            context,
            'No QR code found in the selected image',
            showCloseIcon: false,
          );
        }
      }
    } catch (e) {
      debugPrint('Error scanning image: $e');
      if (!mounted) return;
      AppToast.show(
        context,
        'Error scanning image. Please try again',
        showCloseIcon: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        cameraController.stop();
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              // QR Scanner with overlay
              MobileScanner(
                controller: cameraController,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (!mounted) return;
                    _handleScannedCode(barcode.rawValue);
                    return;
                  }
                },
              ),

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
                            height: 38,
                            width: 38,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'QR Code Scan',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.mochiyPopOne(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 44, vertical: 6),
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
                              await cameraController.toggleTorch();
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
        ..quadraticBezierTo(
            size.width, size.height, size.width - radius, size.height)
        ..lineTo(size.width - cornerLength, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
